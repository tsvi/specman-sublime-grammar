
This is comment
extend sys
for each in bla {

}

<'

// 99 Bottles of beer
// By Thorsten Dworzak

extend sys  {
   lyrics: list of string;
   keep lyrics.size() == 200;
   keep beer_c is for each (o) using index (n) in lyrics  {
      n==0                   => it == appendf("Go to the store and buy some more, 99 bottles of beer on the wall.");
      ((n%2==1) and (n!= 0)) => it == appendf("%s bottle%s of beer on the wall, %s bottle%s of beer.",
                                                  (n==1 ? "No more":(n/2).as_a(string)),
                                                  (n==3) ? "":"s",
                                                  (n==1 ? "no more":(n/2).as_a(string)),
                                                  (n==3) ? "":"s");
      (n%2==0) and (n!=0) => it == appendf("Take one down and pass it around, %s bottle%s of beer on the wall.",
                                           (n==2 ? "no more":(n/2-1).as_a(string)),
                                           ((n-1)==3) ? "":"s");
   };

   run() is also {
      for each in lyrics.reverse() {
         outf("%s\n", append(it, (index % 2 == 1 ? "\n":"")));
      };
   };
};

'>

This is comment


<'
  extend bla_s {

  };

'>
