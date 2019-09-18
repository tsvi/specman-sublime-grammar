<'

define <if_to_ternary'exp> "if_expr <cond'exp> {<cond_if'exp>;...} else {<cond_else'exp>;...}" as computed {
    result = append("(", <cond'exp>, ") ? ");
    
    if (<cond_if'exps> is not empty) {
        result = append(result, "(", str_join(<cond_if'exps>, ") and ("), ")");
    };

    result = append(result, " : ");
    
    if (<cond_else'exps> is not empty) {
        result = append(result, "(", str_join(<cond_else'exps>, ") and ("), ")");
    };
};

'>
