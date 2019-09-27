<'

extend sys {
    l1[20] : list of byte;

    run() is also {
        var a: int;
        var e1: [a,b,c];
        var e2: [a,b,c](bits:2);
        var x: int(bits:4);
        var y: longuint[0..21 ] ( bits: 5);
        print l1.apply(it > 127 ? 1 : 0);
        print l1.apply(it > 127 ? 1'b1 : 1'b0);

        all of {
            start foo();
        };
      };
    };
};

'>
