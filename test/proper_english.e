<'

define <better_english_1'exp> "I am (a|an) <type>" as {
    me is a <1>
};

define <better_english_2'exp> "<exp> is an <type>" as {
    <1> is a <2>
};

unit foo_agent {
    const active_passive : erm_active_passive_t;

       run() is also {
       	     if I am an ACTIVE foo_agent {
	     	print me;
	     };
       };
};

extend sys {
       agent : foo_agent;

       keep agent is an ACTIVE foo_agent;
};

'>
