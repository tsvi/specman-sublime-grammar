
<'

package singleagent;

package template struct packet of (<kind'type>, <data'type>:numeric, <data_size'exp>:uint) {
  size: uint;
  data1: <data'type>(bits: <data_size'exp>);
  data2: <data'type>(bits: <data_size'exp>);
  kind: <kind'type>;
  keep size < 256;
};

template extend struct packet of (<kind'type>:object, <data'type>:numeric, <data_size'exp>:uint = MAX_UINT) {
   sum_data(): <data'type>(bits: <data_size'exp>) is {
      return data1 + data2;
  };
};

template interface foo_if of (<data'exp>:uint = 1000) like base_if, advanced_if conditions { <data'exp> <= 1000;}
{

};

unit singleagent_flat_env_u like imc_base_env_u {
   static kind: env_kind_t = FLAT;
   // Environment configuration
   keep config.env_name == name;
};

// Define the environment unit and instantiate/hook-up the agents.
// Change active_passive, names as desired.

unit singleagent_env_u like singleagent_flat_env_u {

   // instantiate a default agent
   agent: agent default singleagent_agent_u is instance;
   keep agent.env_name == read_only(me.name);
   keep soft agent.active_passive == ACTIVE;

   connect_pointers() is also {
      agent.env_p = me;
      if me::kind == FLAT {
         print me;
      };
   };
};

package interface  foo_if  like base_if , advanced_if, third_if {

};

struct uses_foo_s implementing foo_if, third_if {

};

struct singleagent_data_item_s like imc_base_data_item_s {};

unit singleagent_port_map_u like imc_base_port_map_u implementing advance_if {};

unit singleagent_monitor_u like imc_base_monitor_u of (singleagent_data_item_s) {
   // Per default, use the type defined above.

   // Topology pointers
   !agent_p: singleagent_agent_u;
   !pmp_p  : singleagent_port_map_u;

   // default clock event is defined as clock-rise event in port-map
   event clk_unqualified_e is only @pmp_p.clock_rise_e;
   event clk_e             is only {not true(pmp_p.reset_active())}@clk_unqualified_e;

   // default reset event is asynchronous
   event reset_start_e is only @agent_p.pmp.reset_async_start_e;
   event reset_end_e   is only @agent_p.pmp.reset_async_end_e;

   on reset_start_e {
      message(LOW, "detected reset start");
   };

   on reset_end_e {
      message(LOW, "detected reset end");
   };
};

uvm_build_config env singleagent_flat_env_u singleagent_env_config_u singleagent_env_config_params_s ;
uvm_build_config agent singleagent_agent_u singleagent_agent_config_u singleagent_agent_config_params_s ;

sequence singleagent_sequence_s
   using testflow = TRUE,
   item           = singleagent_data_item_s,
   created_driver = singleagent_sequence_driver_u,
   created_kind   = singleagent_sequence_kind_t;

'>

//=============================================================================
// EOF
//=============================================================================
