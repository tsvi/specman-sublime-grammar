<'


struct test {
    %s: string;
};


extend sys {
    !test;
    
    run() is also {
        var lob : list of bit;
        var po: pack_options;
        
        test = new test with {
            .s = "ABC";
        };

	print test.s;

	out("=======================================");
        lob = pack(packing.high, test);
	print packing.high;
        print lob using radix=BIN;
        
	out("=======================================");
	print packing.low;
        lob = pack(packing.low, test);
        print lob using radix=BIN;
        
	out("=======================================");
        po = new pack_options with {
            .reverse_fields = TRUE;
            .reverse_list_items = FALSE;
        };

	print po;
        lob = pack(po, test);
        print lob using radix=BIN;
        
	out("=======================================");
        po = new pack_options with {
            .reverse_fields = FALSE;
            .reverse_list_items = TRUE;
	    .scalar_reorder = {1; 4};
        };

	print po;
        lob = pack(po, test);
        print lob using radix=BIN;
    
    };
};

'>
