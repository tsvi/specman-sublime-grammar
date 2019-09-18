<'

struct foo {
    flag1: bool;
    flag2: bool;
    flag3: bool;
    
    value : uint;

    foo(f1 : bool, f2 : bool, f3 : bool): set is {
        if not (flag1 or flag2 or flag3) {
            result = [0..MAX_UINT];
        } else {
            if f1 { result = result.union([ 0.. 9])};
            if f2 { result = result.union([10..19])};
            if f3 { result = result.union([20..29])};
        };

        messagef(LOW, "f1: %5s, f2: %5s, f3: %5s, result is %s", f1.to_string(), f2.to_string(), f3.to_string(), result.to_string());
    };
    
    keep value in foo(flag1, flag2, flag3);
};


extend sys {
    
    !bar: foo;
    
    run () is also {
        for i from 0 to 31 {
            gen bar;
        };
        
        bar.flag1 = FALSE;
        bar.flag2 = FALSE;
        bar.flag3 = FALSE;
        gen bar.value;
        
        bar.flag1 = TRUE;
        bar.flag2 = FALSE;
        bar.flag3 = TRUE;
        gen bar.value;
    };
};


'>
