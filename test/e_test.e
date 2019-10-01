<'

type bla: [BLUE, GREEN, YELLOW](bits: 2);

extend sys {
    l1[20] : list of byte;

    final sync_me(trans: cfg_trans)@sys.any is undefined;

    run() is also {
        var a: int;
        var e1: [a,b,c];
        var e2: [a,b,c](bits:2);
        var x: int(bits:4);
        var y: longuint[0..21 ] (bits: 5);
        print l1.apply(it > 127 ? 1 : 0);
        print l1.apply(it > 127 ? 1'b1 : 1'b0);

        all of {
            start foo();
        };
    };

    const member1: uint(bits:23);
    member2: list of list of my_struct_s;

    final sync_me (trans: cfg_trans, a: uint[0..7])@sys.any is only {
        -- body of method
    };
};

extend bla: [BLACK];
'>
