Coverage constructs

<'

extend sys {

   cover done using radix = HEX is {
      item len: uint (bits: 3) = me.len;
      item data: byte = data using
         ranges = {range([0..0xff], "", 4)},
         radix = HEX;
      item mask: uint (bits: 2) = sys.mask using radix = BIN;
   };

   cover ended is {
      item address : address_t = address
      using ranges = {
       range([set_of_values(address_t).min()], "First address");
       range([set_of_values(address_t).min() + 1..set_of_values(address_t).max() - 1], "",
                set_of_values(address_t).uint_size() / 10);
       range([set_of_values(address_t).max()], "Last address");
   };

};
'>
