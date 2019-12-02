<'

extend sys {
    run() is also {
        var str: string = "ABC";
        var po : pack_options;
        
        po = new with {
            .reverse_fields     = FALSE;
            .reverse_list_items = FALSE;
            .scalar_reorder     = {};
            .final_reorder      = {};
        };
        
        print pack(po, str) using radix=BIN;
    };
};

'>
