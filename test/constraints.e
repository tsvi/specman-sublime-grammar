
bla
-- bla
// ff

<'
   struct s {
      keep a;
      keep a == TRUE;
      keep soft a;
      keep b.reset_soft();
      keep b => foo == FALSE;
      keep soft a before b;

      keep soft for each (bla) using index (i) in (list_a) {
         x.reset_soft();
         it == read_only(me.x/2); -- comment
         a => implies_b;
      };
   };

'>
