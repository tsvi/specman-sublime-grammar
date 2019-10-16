 Experiment with Specman sign extension

<'

extend sys {
    single_bit : uint(bits: 1);

    short : uint(bits: 16);

    run() is also {
        single_bit = 1;
        short = single_bit << 4;

        outf("single_bit %x, short %x (expected: 10)\n", single_bit, short);

        single_bit = 0;
        short = single_bit << 4;

        -- print something
        outf("single_bit %x, short %x (expected: 0)\n", single_bit, short);

        // pprint more
        single_bit = 1;
        short = (~single_bit) << 4;

'>

Comment!
<'
        outf("~single_bit %x, short %x (expected: 0)\n", ~single_bit, short);

        single_bit = 0;
        short = (~single_bit) << 4;

        outf("~single_bit %x, short %x (expected: 10)\n", ~single_bit, short);

    };
};

'>
