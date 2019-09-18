<'

struct nest {
    %i1 : byte;
    %i2 : byte;
};

type test_kind : [NORMAL];

struct test {
    kind   : test_kind;
    
    %i1    : byte;
    %i2    : byte;
    %l1[8] : list of byte;
    %i3    : byte;
    %s1    : string;
    %r1    : real;
};

'>
