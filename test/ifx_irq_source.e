
#------------------------------------------------------------------------------
#-- Description :
#-- Author      : Marcus Harnisch (Verilab GmbH) <harnisch.external2@infineon.com>
#-- Project     : XMC3200
#--
#-- Copyright (c)2016 Infineon Technologies AG. All rights reserved.
#-- Proprietary and confidential information
#--
#------------------------------------------------------------------------------

Integrating
===========

1. Create an instance of ifx_irq_env and constrain number of agents
   according to number of IRQ of the logical group. Further constrain
   the number of possible IRQ destinations of each source.

2. The associated registers can in fact be any supported backend of
   ifx_data_sync, including NONE. This might be interesting in cases
   where there is no physical register behind a value, e.g. hard coded
   enable.

3. Connect registers (set, clear, state, enable, select) according to
   the ifx_data_sync API. Example:
      irq_env.sources[0].set_reg.connect(reg_file.my_set_reg, "IRQ0");
                                                       ^         ^
                                                       |         |
                                           vr_ad_reg --'         `-- field name

   Do the same for other registers.

4. Connect ports set and clr to events inside the DUT model for
   setting and clearing interrupts respectively.

5. Connect TLM analysis ports chg_raw and chg_dst to the (next level)
   interrupt controller model or scoreboard.

<'

package ifx_irq;

unit ifx_irq_source {
   const has_coverage : bool;
   keep soft has_coverage;

   name : string;

   // Number of interrupt outputs
   num_dst : uint;
   keep soft num_dst == 1;

   post_generate() is also {
      // the only real limitation is due to the limited number of bins
      // in the coverage item
      assert num_dst <= 16 else
        error(appendf("%s: Maximum number of IRQ destinations exceeded! %d > 16", e_path(), num_dst));
   };

   set: in event_port is instance;
   clr: in event_port is instance;

   chg_raw : out interface_port of tlm_analysis of ifx_irq_trans is instance;
   keep bind(chg_raw, empty);

   chg_dst : list of out interface_port of tlm_analysis of ifx_irq_trans is instance;
   keep soft chg_dst.size() == num_dst;
   keep for each in chg_dst {
      bind(it, empty);
   };

   set_reg   : ifx_data_sync of ifx_irq_state is instance;
   clr_reg   : ifx_data_sync of ifx_irq_state is instance;
   en_reg    : ifx_data_sync of ifx_irq_state is instance;
   state_reg : ifx_data_sync of ifx_irq_state is instance;
   sel_reg   : ifx_data_sync of uint is instance;

   // Use type constraint, so we have a reasonable default, which
   // could still be overwritten.
   keep type set_reg   is a REG ifx_data_sync of ifx_irq_state;
   keep type clr_reg   is a REG ifx_data_sync of ifx_irq_state;
   keep type en_reg    is a REG ifx_data_sync of ifx_irq_state;
   keep type state_reg is a REG ifx_data_sync of ifx_irq_state;
   keep type sel_reg   is a REG ifx_data_sync of uint;

   private !state : ifx_irq_state; // state_raw & enabled
   private !sel   : uint; // output select value

   // Use event ports rather than hard coded events, so that registers
   // can remain undefined (e.g. enable).
   private set_change   : in event_port is instance;
   private clr_change   : in event_port is instance;
   private en_change    : in event_port is instance;
   private state_change : in event_port is instance;
   private sel_change   : in event_port is instance;
   keep bind(clr_change  , empty);
   keep bind(set_change  , empty);
   keep bind(en_change   , empty);
   keep bind(state_change, empty);
   keep bind(sel_change,   empty);

   private event int_clr     is @clr$ or @clr_change$;
   private event int_set     is @set$ or @set_change$;
   private event int_any_chg is @en_change$ or @state_change$ or @sel_change$;

   private !trans: ifx_irq_trans;

   // There'll be race conditions (like in real life). We have no spec for this.

   on set$ {
      messagef(IFX_IRQ, HIGH, "IRQ set event trigger (%s)", name);
   };

   on clr$ {
      messagef(IFX_IRQ, HIGH, "IRQ clear event trigger (%s)", name);
   };

   on set_change$ {
      messagef(IFX_IRQ, HIGH, "IRQ set register written (%s)", name);
   };

   on clr_change$ {
      messagef(IFX_IRQ, HIGH, "IRQ clear register written (%s)", name);
   };

   on int_set {
      state_reg.put(SET);
   };

   on int_clr {
      state_reg.put(CLEAR);
   };

   on state_change$ {
      trans.state     = state_reg.get();
      trans.timestamp = sys.time;
      messagef(IFX_IRQ, HIGH, "(%s) :", trans.state, name, trans);
      messagef(IFX_IRQ, HIGH, "Raw IRQ %s change dected (%s): %s", trans.state, name, trans);
      chg_raw$.write(trans);
   };

   on int_any_chg {
      trans.timestamp = sys.time;

      // clear transaction when changing output select
      if (num_dst > 1 and sel_reg.get() != sel) {
         trans.state = CLEAR;
         chg_dst[sel]$.write(trans);

         messagef(IFX_IRQ, HIGH, "Rerouting IRQ from output %d to output %d (%s)", sel, sel_reg.get(), name);
         messagef(IFX_IRQ, HIGH, "IRQ %s emitted at output %d (%s): %s", trans.state, sel, name, trans);
         sel = sel_reg.get();
      };

      if (en_reg == NULL or en_reg.get() == SET) and (state_reg.get() == SET) {
         state = SET;
      } else {
         state = CLEAR;
      };

      trans.state = state;

      messagef(IFX_IRQ, HIGH, "IRQ %s emitted at output %d (%s): %s", trans.state, sel, name, trans);
      chg_dst[sel]$.write(trans);
   };

   connect_ports() is also {
      if set_reg != NULL {
         do_bind(set_change, set_reg.change);
      };
      if clr_reg != NULL {
         do_bind(clr_change, clr_reg.change);
      };
      if en_reg != NULL {
         do_bind(en_change, en_reg.change);
      };
      if state_reg != NULL {
         do_bind(state_change, state_reg.change);
      };
      if sel_reg != NULL {
         do_bind(sel_change, sel_reg.change);
      };
   };

   run() is also {
      trans = new with {
         .origin = me;
      };
      state = CLEAR;
      sel   = 0;
   };
};

extend has_coverage ifx_irq_source {
   // Do we need more coverage than this at that point?
   cover int_any_chg using per_unit_instance is {
      item enabled : ifx_irq_state = en_reg.get()    using no_collect;
      item state   : ifx_irq_state = state_reg.get() using no_collect;
      item select  : uint(bits: 4) = sel_reg.get()   using no_collect, instance_ignore=(select > inst.num_dst-1);

      cross enabled, state, select;
   };
};

extend ifx_irq_trans {
   origin : ifx_irq_source;
};

'>
