<'

struct s {
    %f : uint(bits: 16);
};

extend sys {
    
    lst[8]: list of s;
    keep for each in lst {
        it.f == index+1;
    };
    
    strings[3] : list of string;
    keep strings[0] == "ABC";
    keep strings[1] == "DEF";
    keep strings[2] == "GHI";
    
    run() is also {
        var po : pack_options;
        var s : s = new with { .f = 0xAAAA };
        
        po = new with {
            .reverse_fields     = FALSE;
            .reverse_list_items = FALSE;
            .scalar_reorder     = {1; UNDEF};
            .final_reorder      = {1; UNDEF};
        };
     
        print po;
        print pack(po, lst) using radix=BIN;
        print pack(po, strings) using radix=hex;
    };
};

'>
