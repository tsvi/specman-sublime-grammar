<'

type C_t : [FOO, BAR];

struct C {
    kind : C_t;
};


//define <list_pm_shuffle'expr> as "<expr>.shuffle()" {
//    var l : typeof(<expr>);
//    gen l keeping { it.is_a_permutation(<expr>); };
//};

extend sys {
    Cs : list of C;
    
    keep Cs.size() in [10..20];
    
    run() is also {
        var c : list of FOO C;
        
        c = Cs.all(it is a FOO C).as_a(list of FOO C);
    };
};

'>
