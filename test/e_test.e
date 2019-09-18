<'

extend sys {
    l1[20] : list of byte;
    
    run() is also {
        print l1.apply(it > 127 ? 1 : 0);
        print l1.apply(it > 127 ? 1'b1 : 1'b0);
    };
};

'>
