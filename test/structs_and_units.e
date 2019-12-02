Structs and units

<'

extend sys {

   foo: BLUE'det foo_u is instance;

   setup() is also {
      print me;
   };
};

struct bar_s {
   my_det: [LARGE, SMALL];

};

unit foo_u {
   bar    : GREEN'my_det bar_s;
   const b: bool;
   det    : [BLUE, RED, GREEN];
   bar_l  : list of bar_s;
   const i: uint[0..10](bits: 3);

   when BLUE foo_u {

   };

   when b'TRUE RED'det {

   };

   s_p : list of in simple_port of uint(bits:3) is instance;
   m_p : out method_port of deliver_method_t is instance;

};

extend b'TRUE BLUE foo_u {
   keep s_p.hdl_path() == "~TB.dut.sub.p";
};


'>
