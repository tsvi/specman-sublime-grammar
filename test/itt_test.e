<'

import if_to_ternary;

extend sys {
    number : uint;
    within_1k_and_2k : bool;

    keep number < 30000;

    keep if_expr (within_1k_and_2k) {
          number >= 1000;
          number <= 2000;
    } else {
          number < 1000 or number > 2000;
    };
};

'>
