 Testcase to show that <multi-dimensional-list>.is_a_permutation(<other list>) is broken in Specman 13.2

<'
extend sys {
   lol: list of list of int;
   keep lol == {
      {0;1};
      {2;3};
      {98;99}
   };
   
   run() is also {
      var rnd_lol: list of list of int;
      
      gen rnd_lol keeping {
         -- This constraint is not adhered to and(!) also destroys lol
         it.is_a_permutation(lol);
      };
      
      print rnd_lol;
      
      print lol;
   };
};
'>
