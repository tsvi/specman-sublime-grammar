
Various (non-compilable) constructs

<'

export DPI-C verifier.e_impl();
export DPI-C verifier.e_impl();

method_type str2uint_method_t (s: string):uint;
method_type str2uint_method_t (s: string):uint @sys.any;

type bla: [BLUE, GREEN, YELLOW](bits: 2);

extend sys {
    l1[20] : list of byte;

    obj: obj_s is instance;

    final sync_me(trans: cfg_trans)@sys.any is undefined;

    my_e_import(i:int,s:string):int is import DPI-C sv_impl;

    run() is also {
        var a: int = 0;
        var e1: [a,b,c];
        var e2: [a,b,c](bits:2);
        var x: int(bits:4);
        var y: longuint[0..21 ] (bits: 5);
        print l1.apply(it > 127 ? 1 : 0);
        print l1.apply(it > 127 ? 1'b1 : 1'b0);

        all of {
            start foo(a+b);
        };

        var l: list of int;

        compute foo();

        print {3;4;5}.min(it);
    };

    const member1: uint(bits:23);
    member2: list of list of my_struct_s;

    final sync_me (trans: cfg_trans, a: uint[0..7], b: bool = TRUE)@sys.any is only {
        -- body of method
    };
};

extend bla: [BLACK];
'>
