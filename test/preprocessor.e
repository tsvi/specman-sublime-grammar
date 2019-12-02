<'


extend sys {
#ifdef set_this {
   when TRUE'has_this my_struct_s {

   };
} #else {

   when FALSE'has_this my_struct_s {
      print "#ifdef { ";

      #ifdef `FROM_VERILOG {
         // this is nested
      };
   };
};

#undef set_this;


};
'>
