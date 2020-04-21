
<'

extend sys {
  run() is also {
      var u: uint(bytes:2) = 0c"a";
      var c: int =  32'hffffxxxx;
      var c: int =  32'HFFFFXXXX;
      var c: int =  19'dL0001;
      var c: int =  14'D123;
      var c: int =  14'D1;
      var c: int =  64'bz_1111_0000_1111_0000 ;

      var kilos: list of uint := {32K; 32k; 128k};
      var megas: list of uint := {1m; 10M};

      var flt1: real := 7.321E-3;
      var flt2: real = 1.0e12;
      var pi: real := SN_M_PI;
  };
};

'>
