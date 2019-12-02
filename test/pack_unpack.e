<'

import pack_unpack_1;
import pack_unpack_2;

extend sys{
    n  : nest;
    t  : NORMAL test;
    tn : NESTED test;
    
    // compare with
    t_c  : NORMAL test;
    tn_c : NESTED test;

    run() is also {
        var l : list of bit;
        var po: pack_options;
        
        n = new with {
            .i1 = 0xB9;
            .i2 = 0x55;
        };
        
        t = new NORMAL test with {
            .i1 = 0x55;
            .i2 = 0xAA;
            .l1 = {1;2;3;4;5;6;7;8};
            .i3 = 0xF0;
            .s1 = "ABC";
            .r1 = 3.141592654;
        };
        
        tn = new NESTED test with {
            .i1 = 0x55;
            .i2 = 0xAA;
            .l1 = {1;2;3;4;5;6;7;8};
            .i3 = 0xF0;
            .s1 = "ABC";
            .r1 = 3.141592654;
            .n1 = n;
        };
        
        
        print t using radix=hex;
        
        out ("========================================");
        
        l = pack(packing.high, t);
        print l using radix=hex;
        
        unpack(packing.high, l, t_c);
        print t_c using radix=hex;
        
        assert (deep_compare_physical(t, t_c, 1).size() == 0);
        
        
        out ("========================================");
        
        l = pack(packing.low, t);
        print l using radix=hex;

        unpack(packing.low, l, t_c);
        print t_c using radix=hex;
        
        assert (deep_compare_physical(t, t_c, 1).size() == 0);
        
        out ("========================================");
        
        po = new with {
            .reverse_fields = FALSE;
            .reverse_list_items = TRUE;
            .scalar_reorder = {};
            .final_reorder  = {};
        };
        print po;
        l = pack(po, t);
        print l using radix=hex;

        unpack(po, l, t_c);
        print t_c using radix=hex;
        
        assert (deep_compare_physical(t, t_c, 1).size() == 0);
        
        out ("========================================");
        
        po = new with {
            .reverse_fields = TRUE;
            .reverse_list_items = FALSE;
            .scalar_reorder = {};
            .final_reorder  = {};
        };
        print po;
        l = pack(po, t);
        print l using radix=hex;

        unpack(po, l, t_c);
        print t_c using radix=hex;
        
        assert (deep_compare_physical(t, t_c, 1).size() == 0);
        
        out ("========================================");
        
        po = new with {
            .scalar_reorder = {1; UNDEF; 2; 4};
            .final_reorder  = {1; UNDEF};
        };
        print po;
        l = pack(po, t);
        print l using radix=hex;

        unpack(po, l, t_c);
        print t_c using radix=hex;
        
        assert (deep_compare_physical(t, t_c, 1).size() == 0);

        out ("\n\n\nNested struct");
        out ("========================================");
        
        l = pack(packing.high, tn);
        print l using radix=hex;
        
        unpack(packing.high, l, tn_c);
        print tn_c using radix=hex;
        
        assert (deep_compare_physical(tn, tn_c, 1).size() == 0);
        
        
        out ("========================================");
        
        l = pack(packing.low, tn);
        print l using radix=hex;

        unpack(packing.low, l, tn_c);
        print tn_c using radix=hex;
        
        assert (deep_compare_physical(tn, tn_c, 1).size() == 0);
        
        out ("========================================");
        
        po = new with {
            .reverse_fields = FALSE;
            .reverse_list_items = TRUE;
            .scalar_reorder = {};
            .final_reorder  = {};
        };
        print po;
        l = pack(po, tn);
        print l using radix=hex;

        unpack(po, l, tn_c);
        print tn_c using radix=hex;
        
        assert (deep_compare_physical(tn, tn_c, 1).size() == 0);
        
        out ("========================================");
        
        po = new with {
            .reverse_fields = TRUE;
            .reverse_list_items = FALSE;
            .scalar_reorder = {};
            .final_reorder  = {};
        };
        print po;
        l = pack(po, tn);
        print l using radix=hex;

        unpack(po, l, tn_c);
        print tn_c using radix=hex;
        
        assert (deep_compare_physical(tn, tn_c, 1).size() == 0);
        
        out ("========================================");
        
        po = new with {
            .scalar_reorder = {1; UNDEF; 2; 4};
            .final_reorder  = {1; UNDEF};
        };
        print po;
        l = pack(po, tn);
        print l using radix=hex;

        unpack(po, l, tn_c);
        print tn_c using radix=hex;
        
        assert (deep_compare_physical(tn, tn_c, 1).size() == 0);
    };
};

'>
