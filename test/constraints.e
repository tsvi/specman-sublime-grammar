
bla
-- bla
// ff

<'

struct s {
   keep a;
   keep named_constraint is a;
   keep a == TRUE;
   keep soft a;
   keep b.reset_soft();
   keep b => not foo;
   keep not read_only(b) => foo;

   keep soft p.hdl_path() == "bla\n";

   keep soft a before b;

   keep a.all_different();

   keep soft lst == {q;w;e;r;t}.sort();
   keep soft lst_elem in {a;b};

   keep lst2d == {matrix; {1;2;3}};

   keep soft for each (bla) using index (i) in lst {
      x.reset_soft();
         it == read_only(me.x/2); -- comment
         read_only(a) => implies_b;
   };

   keep foo => all of {
      l.unique();
   };

   keep my_constraint is  all of {

   };

   keep read_only(a) == b => all of {

   };

   keep  soft  a  ==  select  { 10: TRUE; 90: FALSE;};

   keep soft shden == read_only(shadow_upd_enable).as_a(bit);
   keep  soft  shden == read_only (shadow_updenable).as_a ( bit );

};


extend has_info Start vr_ad_sequence {
   keep start_reg.start == read_only(context.setup.is_selected(static_reg_file.name).as_a(bit));
};

'>
