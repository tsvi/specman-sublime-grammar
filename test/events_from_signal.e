<'


define <create_events'struct_member> "create events from <signal'name>[ in <path'exp>]" as {
    <signal'name>_rise_ep : in event_port is instance;
    keep <signal'name>_rise_ep.hdl_path() == (str_empty(<path'exp|"">) ?
                                              "<signal'name>" : append(<path'exp|"">, ".<signal'name>"));
    keep <signal'name>_rise_ep.edge()     == rise;
    
    event <signal'name>_rise is @<signal'name>_rise_ep$;
    
    <signal'name>_fall_ep : in event_port is instance;
    keep <signal'name>_fall_ep.hdl_path() == <signal'name>_rise_ep.hdl_path();
    keep <signal'name>_fall_ep.edge()     == fall;
    
    event <signal'name>_fall is @<signal'name>_fall_ep$;
};


extend sys {
    create events from foo;
    create events from bar in "~/tb/core";
};

'>
