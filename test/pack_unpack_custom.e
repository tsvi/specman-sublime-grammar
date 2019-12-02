<'

define NUM_BYTES 4;

struct mytrans {
    empty : uint;
    keep empty < NUM_BYTES;
    %payload : list of uint(bits: NUM_BYTES*8);
    keep payload.size() in [5 .. 10];

    do_pack(options : pack_options, l : *list of bit) is {
        var l_tmp : list of bit;

        assert (NUM_BYTES == 1 or options.reverse_list_items == FALSE)
          else error(appendf("Unsupported pack option (%s)! reverse_list_items != FALSE", options));

        packing.pack_struct(me, options, l_tmp);
        
        l.add(l_tmp[0 .. (l_tmp.size() - (me.empty*8) - 1)]);
    };

    do_unpack(options : pack_options, l : list of bit, begin : int) : int is only {
        var l_tmp : list of bit;
        
        assert (NUM_BYTES == 1 or options.reverse_list_items == FALSE)
          else error(appendf("Unsupported pack option (%s)! reverse_list_items != FALSE", options));

        l_tmp  = l[begin..];
        result = l.size()-1;
            
        options.final_reorder = {};
        options.scalar_reorder = {};
        
        if (NUM_BYTES > 1) {
            empty = NUM_BYTES - (l_tmp.size()/8)%NUM_BYTES;
        } else {
            empty = 0;
        };

        payload.resize((l_tmp.size()/8) + 1, TRUE, 0, FALSE);
        unpack(options, l_tmp, payload);
    };
};

struct mynewtrans like mytrans {
    do_pack(options : pack_options, l : *list of bit) is only {
        var l_tmp : list of bit;

        if (empty == 0 or not options.reverse_list_items) {
            packing.pack_struct(me, options, l_tmp);
        } else {
            var l_last : list of bit;
            l_last = pack(options, me.payload[me.payload.size()-1]);
            l_tmp.add(l_last[0..((NUM_BYTES*8) - (me.empty*8) - 1)]);
            
            if (me.payload.size() > 1) {
                l_tmp.add(pack(options, me.payload[0..me.payload.size()-2]));
            };
        };

        l.add(l_tmp);
    };

    do_unpack(options : pack_options, l : list of bit, begin : int) : int is only {
        var l_tmp : list of bit;
        var low  : int;
        var high : int;

        if (options.reverse_list_items) {
            low    = 0;
            high   = begin;
            result = low; // index of last bit unpacked
        } else {
            low    = begin;
            high   = l.size()-1;
            result = high;
        };
            
        l_tmp  = l[low..high];

        options.final_reorder = {};
        options.scalar_reorder = {};

        if (NUM_BYTES > 1) {
            empty = NUM_BYTES - (l_tmp.size()/8)%NUM_BYTES;
        } else {
            empty = 0;
        };

        if (empty == 0 or not options.reverse_list_items) {
            unpack(options, l_tmp, payload);
        } else {
            var l_last : list of bit;
            var p_last : uint(bits: NUM_BYTES*8);
            var p_tmp  : list of uint(bits: NUM_BYTES*8);
            
            l_last = l_tmp[low .. low+(NUM_BYTES-empty)*8-1];
            unpack(options, l_last, p_last);

            if (high - (low + (NUM_BYTES-empty)*8) > 0) {
                unpack(options, l_tmp[low+(NUM_BYTES-empty)*8 .. high], p_tmp);
                
                payload.add(p_tmp);
            };

            payload.add(p_last);
        };
    };
};


extend sys {
    
    m : mynewtrans;
    
    run() is also {
        var l : list of bit;
        var m_c : mynewtrans;
        
        print m using radix=HEX;
        
        l = pack(packing.high, m);
        print l using radix=HEX;
        
        unpack(packing.high, l, m_c);

        print m_c using radix=HEX;
        
        assert (l == pack(packing.high, m_c)); // can't compare directly due to padding garbage
    };
};

'>
