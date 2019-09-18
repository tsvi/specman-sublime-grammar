<'

struct s {
    %f1: uint(bits: 16);
    %f2: uint(bits: 8);
    
    do_pack(options: pack_options, l: *list of bit) is {
        var l_tmp: list of bit;
        
        packing.pack_struct(me, options, l_tmp);
        
        print l_tmp using radix=BIN;
        
        l = l_tmp;
    };
};

extend sys {
    run() is also {
        var po: pack_options = new with {
            .reverse_fields = TRUE;
            .reverse_list_items = FALSE;
            .scalar_reorder = {};
            .final_reorder = {};
        };
        
        var s: s = new with {
            .f1 = 0xAAF0;
            .f2 = 0xCC;
        };
        
        print s using radix=BIN;
        print pack(po, s) using radix=BIN;
    };
};
'>
