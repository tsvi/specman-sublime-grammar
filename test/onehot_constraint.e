<'


extend sys {
    !lob : list of uint(bits: 8);
    
    keep lob.size() <= 100;
    keep lob.count(it > 0) == 1;
    
    keep for each in lob {
        (it & (it - 1)) == 0;
    };
    
    run() is also {
        for i from 0 to 20 {
            gen lob;
            print lob;
            print "--------------------";
        };
    };
};

'>
