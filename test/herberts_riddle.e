Riddle from Herbert with concentric rings containing numbers.
Axial sum of numbers must be the same for all axis.

<'

define N 16;

define j0 (ring_turns[0]+j) % N;
define j1 (ring_turns[1]+j) % N;
define j2 (ring_turns[2]+j) % N;
define j3 (ring_turns[3]+j) % N;

extend sys {

   -- Every ring has two parts, an inner part and an outer part. the outer part overlaps
   -- with the inner part of the next ring. Each part has up to 16 numbers, if there is no
   -- number, we set it to -1;
   -- The order of the numbers on the rings is clock-wise, starting with the highest number
   -- on the outer ring;
   -- The rings itself are starting with the innermost ring.

   !rings_outer: list of list of int = {
      {13;-1; 3;-1; 3;-1; 6;-1;10;-1;10;-1;10;-1; 6;-1};
      {22;-1; 2;-1;17;-1;15;-1;14;-1; 5;-1;10;-1; 2;-1};
      {17;-1; 2;-1; 2;-1;10;-1;15;-1; 6;-1; 9;-1;16;-1};
      {27;10;19;10;13;10; 2;15;23;19; 3; 2; 3;27;20;11};
   };
   !rings_inner: list of list of int = {
      { 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0};
      {10; 2; 6;10; 4; 1; 5; 5; 4; 8; 6; 3; 1; 6;10; 6};
      {14; 5; 5; 7; 8;24; 8; 3; 6;15;22; 6; 1; 1;11;27};
      { 7; 3;12;24;10; 9;22; 9; 5;10; 5; 1;24; 2;10;9;};
   };
   !ring_initial_turns: list of int[0..N-1] = {
      0;0;0;0
   };

   ring_turns: list of int[0..N-1];
   keep ring_turns.size() == 4;
   keep ring_turns[3] == 0;

   sums: list of uint;
   keep sums.size() == N;

   keep for each (s) using index (j) in sums {
      s in [10..60];                    // min/max values
      s == ((rings_outer[0][j0] < 0) ? rings_inner[1][j1] : rings_outer[0][j0])
         + ((rings_outer[1][j1] < 0) ? rings_inner[2][j2] : rings_outer[1][j1])
         + ((rings_outer[2][j2] < 0) ? rings_inner[3][j3] : rings_outer[2][j2])
         +   rings_outer[3][j3]
         ;
      j > 0 => sums[j-1] == s;
   };

   // Print the rings on screen, innermost ring first, outermost ring is not turned
   render_disc(turns: list of int[0..N-1], with_sums: bool) is {
      if not with_sums {
         outf("Initial disc setting:\n");
      } else {
         outf("Solution:\n");
      };
      for i from 0 to 3 {
         outf("turns %2d ", turns[i]);
         for j from 0 to N-1 {
            var k: int = (turns[i] + j) % N;
            if (i == 0) {
               var kk: int = (turns[i+1] + j) % N;
               outf("|%2d", (rings_outer[i][k] < 0 ? rings_inner[i+1][kk] : rings_outer[i][k]));
            } else if i < 3 {
               var kkk: int = (turns[i + 1] + j) % N;
               outf("|%2d", (rings_outer[i][k] < 0 ? rings_inner[i+1][kkk] : rings_outer[i][k]));
            } else {
               outf("|%2d", rings_outer[i][k]);
            };
         };
         outf("|\n");
      };
      if with_sums {
         outf("\nSums:\n         ");
         for j from 0 to N-1 {
            outf("|%2d", sums[j]);
         };
         outf("|\n");
      };
   };

   init() is also {
      render_disc(ring_initial_turns, FALSE)
   };
   post_generate() is also {
      render_disc(ring_turns, TRUE);
   };
};

'>
