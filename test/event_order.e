<'

extend sys {
    !flag: bool;
    
    event e;
    
    on e {
        flag = FALSE;
    };
    
    run() is also {
        flag = TRUE;
        emit e;
        print flag; // prints FALSE
    };
};

'>
