
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

    final sync_all(trans: cfg_trans)@sys.any is undefined;

    my_e_import(i:int,s:string):int is import DPI-C sv_impl;

    run() is also {
        var a: int = 0;
        var e1: [a,b,c];
        var e2: [a,b,c](bits:2);
        var x: int(bits:4);
        var y: longuint[0..21 ] (bits: 5);
        out(b.l1.apply(it > 127 ? 1 : 0));
        var s: string := l1.apply(it > 127 ? 1'b1 : 1'b0);

        assert a==0;
        first of {
            start foo(a+b);
        };

        var l: list of int = {1;2;7;4}.sort();
        l = l.reverse(); -- TODO: DEBUG

        bar();
        compute foo();

        print {3;4;5}.min(it);
        outf("built-in function");

        q = get_info(bar).member_function();

        if p is a BLUE color_s (blue) {
          print p;
        };

        p = new;
        p = new with { it.enable };
        p = new colors_s;

        if p is a GREEN color_s (green) {

        };

        -- TODO: DEBUG
        msg = appendf("%s] triggered by %s", msg, str_join(source_events.apply(.to_string()), " and "));
    };

    const member1: uint(bits:23);
    member2: list of list of my_struct_s;

    final sync_all (trans: cfg_trans, a: uint[0..7], b: bool = TRUE)@sys.any is only {
      if (ls.size() > 2) {
         var pix: fme_video_rgb_s = new;
         var r8 : uint = ls[0].as_a(uint);
         var g8 : uint = ls[1].as_a(uint);
         pix.r = r8.as_a(uint (bits:8));
         pix.g = g8.as_a(uint (bits:8));
         img.data.add(pix);
      } else {
          message(NONE, "Error: Cannot read color data.");
          break;
      };
    };
};

extend bla: [BLACK];
'>
