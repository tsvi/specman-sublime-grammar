
Various (non-compilable) constructs

<'

export DPI-C verifier.e_impl();
export DPI-C verifier.e_impl();

method_type str2uint_method_t (s: string):uint;
method_type str2uint_method_t (s: string):uint @sys.any;
method_type method_set_sharedlut_entry(u1: uint, u2: uint(bits: 24));


type bla: [BLUE, GREEN, YELLOW](bits: 2);
type int_small: uint[0..500](bits: 10);

extend sys {

    @import_python(module_name="plot_i", python_name="addVal")
    addVal(groupName:string, cycle:int,grade:real) is imported;

    l1[20] : list of byte;

    obj: obj_s is instance;

    final sync_all(trans: cfg_trans)@sys.any is undefined;

    my_e_import(i:int,s:string):int is import DPI-C sv_impl;

    //fn_multi_line(a: bool,
    //              b: int):bool is empty;


    run() is also {
        var a: int = 0;
        var e1: [a,b,c];
        var e2: [a,b,c](bits: 0b10);
        var x: int(bits:4);
        var y: longuint[0..21 ] (bits: 5);
        out(b.l1.apply(it > 0x7f ? 1 : 0));
        var s: string := l1.apply(it > 127 ? 1'b1 : 1'b0);

        var matrix: list of list of int = {{1;2;3};{4;5;6}};
        var matix_3d: list of list of list of int = {matrix;{6;7;8};{9;10;11}};

        var cl: list of list(key: it) of uint(bits: 4);

        assert a==0;
        first of {
            start foo(a+b);
        };

        do sequence keeping { it == seq };

        var l: list of int = {1;2;7;4}.sort();
        l = l.reverse();

        for each (elem) using index (idx) in l {
          print elem, idx;
        };

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
          type bla is a parent;
          print p;
        };

        keep type p is a child;
        msg = appendf("%s] triggered by %s", msg, str_join(source_events.apply(.to_string()), " and "));
    };

    l: list(key: string) of uint;
    ll: list of list(key: it) of uint(bits: 4);
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

      start multi_line_method_params(get_a(a), b);
      assert (add == foo(x));
    };

    walk_objections(unt: any_unit, obj_kind: objection_kind) is {
      if unt.get_objection_counter(obj_kind) > 0 {
         outf("Still pending objections in unit %s: %d\n", unt, unt.get_objection_counter(obj_kind));
      };
      for each (u) in unt.get_objection_list(obj_kind) {
         walk_objections(u, obj_kind);
      };
      for each (v) in x.bla_list {
        a.quit();
      }
   };



   has_restriction(range: address_range_s,
                   restr: access_restriction_t,
                   master_name: bus_interface_names_t = UNDEFINED): bool is {
      if intersect_range(range) {
         result = (restrictions.has(it == restr) and (bus_interface_names.is_empty() or master_name == UNDEFINED or bus_interface_names.has(it == master_name))) ? TRUE : FALSE;
      };
   };



};

extend bla: [BLACK];
'>
