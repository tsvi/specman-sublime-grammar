<'

struct s2 {
    %f1 : uint(bits: 16);
    %f2 : uint(bits: 8);
};

struct s1 {
    %s2: s2;
};

struct s0 {
    %s1: s1;
};

extend sys {
    s : s0;
    
    run() is also {
        var po : pack_options;
        
        po = new with {
            .reverse_fields     = FALSE;
            .reverse_list_items = FALSE;
            .scalar_reorder     = {1; UNDEF};
            .final_reorder      = {};
        };
     
        print po;
        print pack(packing.low, s.s1.s2.f1, s.s1.s2.f2) using radix=BIN;
        out("==========================");
        print pack(po, s.s1.s2.f1, s.s1.s2.f2) using radix=BIN;
        print pack(po, s.s1.s2) using radix=BIN;
        print pack(po, s.s1) using radix=BIN;
        print pack(po, s) using radix=BIN;
    };
};

'>
