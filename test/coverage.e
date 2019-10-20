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
};
'>
