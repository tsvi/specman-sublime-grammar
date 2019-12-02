
<'

extend sys {
    transfer_started_i : in interface_port of tlm_analysis of MONITOR xbus_trans_s 
      of FOO bar of QUUX quax using prefix=pfx_ is instance;

    compare_payloads(exp_payload : xserial_frame_payload_s, compare_dest : bool): list of string is also {
        if exp_payload is a DATA xserial_frame_payload_s (d) and
           d.data != data {
            result.add(append("Expected data field: ", 
                              hex(d.data),
                              ", Actual data field: ", 
                              hex(data)));
        };

        // Lexer test only. This will not compile
        print sys.xbus_evc.active_masters[0].ACTIVE'MASTER'driver
    }; -- compare_payloads()

    test_payloads(exp_payload : xserial_frame_payload_s, compare_dest : bool): list of string @x is also {
    }; -- test_payloads()

    show_status() is empty;

};

'>
