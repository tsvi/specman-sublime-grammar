 

This file defines helper structs, used only by some macros, that
help with (and regularize) some aspects of macro parsing.

The long-term aim should be to factor-out any common parsing 
code here, so that it can be used by any macros.  This should
encourage consistency of macro syntax, facilitate future
enhancements, and make the main macro code more readable.

All these structs have names of the form ifx_soc_*_syntax_s.

There are also some helper macros and enum types.

<'
package ifx_soc;


//////////////////////////////////////////////////////////////////////////////////
// Enumerated types
//////////////////////////////////////////////////////////////////////////////////

// Parser outcome type.  DO NOT ATTEMPT TO EXTEND THIS TYPE.
// Whenever you call the parse(source) method of ifx_soc_macro_item_syntax_s,
// the method sets the struct's "outcome" member to be one of these values.
//
type ifx_soc_parser_outcome_t : [
   NO_MATCH,   // The source was not recognized at all by this parser.
   ERROR,      // The source was recognized (perhaps by a leading keyword or
               // some other syntactic feature) but does not fully match.
   OK];        // The source was recognized and has been parsed into the 
               // appropriate struct members of the parser subtype.

// Syntax item kind type.
// For each different syntactic pattern that we wish to match, we will create
// a new extension of this enum type and a new extension of ifx_soc_macro_item_syntax_s.
//
type ifx_soc_macro_item_syntax_kind_t : [UNKNOWN];

// Here are all the blocktags that can be used to label blocks like
//    <blocktag>; ...; </blocktag>;
// Each enum literal must exactly match its blocktag string,
// Spaces are not tolerated within the angle-brackets.
// Tagged-block nesting can be supported by means of a list of currently active
// blocktags, in which element 0 is the outermost and element size-1 is the
// innermost (most recently encountered) tag.  
// An empty list means that parsing is currently outside any tagged-block.
// Nesting can be outlawed by ensuring that the active blocktag list's size
// never exceeds 1.
//
type ifx_soc_syntax_blocktag_t : [
   address_ranges, 
   safe_address_ranges,
   unsafe_address_ranges,
   access_limitations,
   limitations,
   default_slave,
   routing
];


//////////////////////////////////////////////////////////////////////////////////
// Utility macros
//////////////////////////////////////////////////////////////////////////////////

// Factor out the generation of fatal parse errors, to avoid much code duplication
//
define <ifx_soc_macro_syntax_error'action> "macro_syntax_error <message'exp>,<bad_code'exp>" as {
   {
      var message  : string = <message'exp>;
      var bad_code : string = str_expand_dots(<bad_code'exp>);

      var b: ifx_soc_banner_s = new;
      b.set_title("ifx_soc MACRO USAGE ERROR");
      for each in str_split(message, "\n") {
         b.add_line(it);
      };
      if bad_code != "" {
         bad_code = str_replace(bad_code, "/({|;)/", "\1\n");
         bad_code = str_replace(bad_code, "}", ";\n}");
         b.add_line("");
         b.add_line("Offending code block:");
         for each in str_split(bad_code, "\n") {
            b.add_line(append("   ", it));
         };
      };
      b.display();
      error("I cannot continue until you fix this.");
   }
};

// Given a string pattern, get a list of enum labels of the chosen type that match it
//
define <ifx_soc_enumerals_matching'exp> "<src_list'exp>.all_matches\(<pattern'exp>\)" as {
   (<src_list'exp>.all(.as_a(string) ~ <pattern'exp>))
};

// Given a string, find whether it's the name of one of the enum labels
// in some enumeration type.
//
define <ifx_soc_is_member_of'exp> "<string_name'exp>.is_a_member_of\(<type_name'name>\)" as {
   (<string_name'exp> in all_values(<type_name'name>).apply(.as_a(string)))
};

// Given an enum type, find the length of its longest name
//
define <ifx_soc_max_name_len'exp> "<type_name'name>.max_name_len\(\)" as {
   all_values(<type_name'name>).max_value(str_len(it.as_a(string)))
};

//////////////////////////////////////////////////////////////////////////////////
// Parser-related structs
//////////////////////////////////////////////////////////////////////////////////

// Base class for item parsers
//
struct ifx_soc_macro_item_syntax_s {

   // Common properties required as part of the API for all subtypes
   //
   !kind       : ifx_soc_macro_item_syntax_kind_t;
   !outcome    : ifx_soc_parser_outcome_t;
   !error_text : string;  
   
   // This is the main method.  It takes a piece of source text and
   // attempts to parse it as the specified kind of syntactic construct.
   // Extend this method (using is-also) for each new kind.
   //
   parse(source: string) is {
      outcome = NO_MATCH;
      error_text = "";
   };
   
   // In most cases, parsing code does not know in advance what kind of 
   // construct to expect at any given point.  So it should call this method,
   // which is *not* designed to be extended, providing a list of all the
   // kinds that are acceptable in the current context.
   //
   try_parse(source: string, kinds: list of ifx_soc_macro_item_syntax_kind_t) is {
      for each in kinds {
         kind = it;
         parse(source);
         if outcome == NO_MATCH {
            // that one failed; keep trying
            continue;
         } else {
            // We have an unequivocal OK or ERROR:
            break;
         };
      };
      if outcome == NO_MATCH {
         // we got nowhere
         kind = UNKNOWN;
      };
   };
   
   // Convenience properties - could be declared in each subtype that
   // needs them, but in practice it's neater to declare here to
   // avoid code duplication and struct bloat.
   //
   private !details : string;  // working variable used by various parsers

};

//////////////////////////////////////////////////////////////////////////////////
// WORD parser.
// This is used to parse lists of identifiers matching [a-zA-Z0-9_] but starting
// with a letter (making this restriction to prevent matching of almost everything).
extend ifx_soc_macro_item_syntax_kind_t : [WORD];
extend WORD ifx_soc_macro_item_syntax_s {
   !name  : string;
   
   parse(source: string) is also {
      if not str_match(source, "/^\s*([a-zA-Z]\w*)\s*$/") {
         //                          ($1 ) 
         outcome = NO_MATCH;
         error_text = appendf("Cannot interpret this statement:\n   %s", source);
         return;
      };
      name    = $1;
      outcome = OK;
   };
};

//////////////////////////////////////////////////////////////////////////////////
// PROPERTY parser.
// This finds commands of the form <name> : <val>
// Such commands are used heavily at the top level of macros such as 
//    add slave bus_interface
// where they specify required properties of the added item.
// This parser makes no attempt to validate the name and value strings.
// The name string may contain spaces (I don't like this, but it's needed
// to support some legacy behaviours) but the value string may not. Also, 
// the name string may contain "-".

extend ifx_soc_macro_item_syntax_kind_t : [PROPERTY];
extend PROPERTY ifx_soc_macro_item_syntax_s {
   !name  : string;
   !val   : string;
   
   parse(source: string) is also {
      if not str_match(source, "/^\s*(\w+(\s*\-*\w+)*)\s*:(.*)$/") {
         //                          ($1             )       ($3)    // multi-word names but no punctuation
         outcome = NO_MATCH;
         error_text = appendf("Cannot interpret this statement:\n   %s", source);
         return;
      };
      name = $1;
      details = $3;
      if not str_match(details, "/^\s*(\w+)\s*$/") {
             //                       ($1 )
         error_text = appendf("%s : expected <value> but got \"%s\"", name, details);
         outcome = ERROR;
         return;
      };
      val = $1;
      outcome = OK;
   };
};

//////////////////////////////////////////////////////////////////////////////////
// PROPERTY_ANY_VAL parser.
// This finds commands of the form <name> : <anything>
// It is used for properties where the value is allowed to be a anything,
// for example: 
// hdl_path : append(BAR, "/foo")

extend ifx_soc_macro_item_syntax_kind_t : [PROPERTY_ANY_VAL];
extend PROPERTY_ANY_VAL ifx_soc_macro_item_syntax_s {
   !name  : string;
   !val   : string;
   
   parse(source: string) is also {
      if not str_match(source, "/^\s*(\w+)\s*:\s*(.*)\s*$/") {
         //                          ($1 )       ($2)
         outcome = NO_MATCH;
         error_text = appendf("Cannot interpret this statement:\n   %s", source);
         return;
      };
      name = $1;
      val  = $2;
      outcome = OK;
   };
};

//////////////////////////////////////////////////////////////////////////////////
// PROPERTY_LIST parser.
// This finds commands of the form <name> : <val1>, <val2>, ... ;
// The name string must not contain spaces, we are more restrictive here than in the PROPERTY syntax

extend ifx_soc_macro_item_syntax_kind_t : [PROPERTY_LIST];
extend PROPERTY_LIST ifx_soc_macro_item_syntax_s {
   !name  : string;
   !vals  : list of string;
   
   parse(source: string) is also {
      if not str_match(source, "/^\s*(\w+)\s*:(.*)$/") {
         //                          ($1 )    ($2) 
         outcome = NO_MATCH;
         error_text = appendf("Cannot interpret this statement:\n   %s", source);
         return;
      };
      name = $1;
      details = str_trim($2);
      if not str_match(details, "/^(\w+(\s*,\s*\w+)*)$/") {
         //                        ($1 )
         error_text = appendf("%s : expected <value>[,<value>*] but got \"%s\"", name, details);
         outcome = ERROR;
         return;
      };
      vals = str_split($1,"/\s*,\s*/");
      outcome = OK;
   };
};

//////////////////////////////////////////////////////////////////////////////////
// <blocktag> and </blocktag> begin/end markers

extend ifx_soc_macro_item_syntax_kind_t : [BLOCKTAG];
extend BLOCKTAG ifx_soc_macro_item_syntax_s {

   !tag   : ifx_soc_syntax_blocktag_t;
   !enter : bool;   // true if <tag>, false if </tag>

   parse(source: string) is also {
      if not str_match(source,"/^\s*<([^>]+)>\s*$/") {
         outcome = NO_MATCH; // no error, it's simply not a blocktag
         return;
      };
      details = $1;
      if not str_match(details, "/^(\/?)(\w+)$/") {
         error_text = appendf("Malformed blocktag <%s>", details);
         outcome = ERROR;
         return;
      };
      try {
         tag = $2.as_a(ifx_soc_syntax_blocktag_t);
         enter = ($1 == "");
         outcome = OK;
         return;
      } else {
         error_text = appendf("Unknown blocktag <%s>", details);
         outcome = ERROR;
         return;
      };
   };
     
};

//////////////////////////////////////////////////////////////////////////////////
// LIMITATION parser, handles the specific syntax used in the <limitations>
// blocks found in various bus interface macros.  The syntax is
//     add|set <name> : <value>
// but '=' is also tolerated in place of ':'  Note that this syntax hijacks
// the keywords "add" and "set" to some extent.
//
extend ifx_soc_macro_item_syntax_kind_t : [LIMITATION];
extend LIMITATION ifx_soc_macro_item_syntax_s {

   !keyword : string;
   !name    : string;
   !val     : string;
   
   parse(source: string) is also {
      if not str_match(source, "/^\s*(add|set|rm)\s+([^:=]*(:|=).*)$/") {
             //                      ($1     )   ($2           )
         outcome = NO_MATCH;
         return;
      };
      keyword = $1;
      if not str_match($2, "/^(\w+)\s*(=|:)\s*(\w+)\s*$/") {
             //               ($1 )   ($2 )   ($3 )
      error_text = appendf(
            "Bad syntax in limitation \"%s;\", should be \"add|set|rm name : value\"", source);
         outcome = ERROR;
         return;
      };
      name    = $1;
      val     = $3;
      outcome = OK;
   };

};

//////////////////////////////////////////////////////////////////////////////////
// ADDRESS_RANGE parser.  Handles the full address-range syntax found in many places.
// Some of the results may be inappropriate; it's the caller's job to filter such
// inappropriate results.  The syntax is:
//    [[add ]range] <start_addr>..<end_addr> [ using|:|with {<tag>,}<tag> [[not]for {<bus-interface>},<bus-interface>]] 
//
extend ifx_soc_macro_item_syntax_kind_t : [ADDRESS_RANGE];
extend ADDRESS_RANGE ifx_soc_macro_item_syntax_s {

   !min_adrs     : uint;
   !max_adrs     : uint;
   !tags         : list of string;
   !bifs         : list of string;
   !bifs_inverse : bool;
   
   // return strings used as parameters in macro to call add_slave_bus_interface_access_restrictions_ext()
   
   range_string() : string is {
      if outcome == OK {
         result = appendf("0x%04X_%04X, 0x%04X_%04X", 
                  min_adrs[31:16], min_adrs[15:0], max_adrs[31:16], max_adrs[15:0]);
      } else {
         result = "";
      };
   };
   
   tags_string() : string is {
      if outcome == OK {
         result = append("{", str_join(tags, ";"), "}");
      } else {
         result = "";
      };
   };
   
   bifs_string() : string is {
      if outcome == OK {
         result = append("{", str_join(bifs.apply(quote(it)), ";"), "}");
      } else {
         result = "{}";
      };
   };
   
   bifs_inverse() : bool is {
      if outcome == OK {
         result = bifs_inverse;
      };
   };
   
   parse(source: string) is also {
   
      var has_keyword: bool = FALSE;
      tags.clear();
      bifs.clear();
      
      if str_match(
            source, 
            "/^\s*(add(_|\s+))?range(\s+(.*))?$/") {
            // Relevant matches:        ($4)
         details = $4;
         has_keyword = TRUE;
      } else {
         details = source;
      };
      if not str_match(details, "/^\s*(\w+)\s*\.\.\s*(\w+)\s*(.*)$/") {
            // Relevant matches:      ($1 )          ($2 )   ($3)
            //                      start_addr     end_addr  attribute-list
         if has_keyword {
            error_text = "Expecting [[add ]range] <start_addr>..<end_addr> [using {<tag>,}<tag>] but got \"%s\"";
            outcome = ERROR;
         } else {
            outcome = NO_MATCH;
         };
         return;
      };
      // Process the mandatory address range
      try {
         min_adrs = $1.as_a(uint);
         max_adrs = $2.as_a(uint);
      } else {
         error_text = appendf("Non-numeric value in specified address range %s..%s", $1, $2);
         outcome = ERROR;
         return;
      };
      if min_adrs > max_adrs {
         error_text = appendf("Reversed address range %s..%s", $1, $2);
         outcome = ERROR;
         return;
      };
      // Process the optional attribute list
      var taglist: string = str_trim($3);
      if taglist == "" {
         outcome = OK;
         return;
      };
      if not str_match(taglist, "/^(with|:|using)\s+((\w+\s*,\s*)*\w+)\s*(.*)$/") {
         //                                         ($2              )   ($3)   
         error_text = appendf("Tag list expected [ with|:|using {<tag>,} <tag> ], but got \"%s\"", taglist);
         outcome = ERROR;
         return;
      };
      tags = str_split($2, ",").apply(str_trim(it));
      
      // using NO_ACCESS_NOC_RETURNS_ERROR for L2_DMA8C2_AHB_M
      
      // Process any optional bus-interface list
      var bif_list: string = str_trim($4);
      if bif_list == ""  {
         outcome = OK;
         return;
      };
      if not str_match(bif_list, "/^(for|notfor)\s+((\w+\s*,\s*)*\w+)$/") {
         //                         ($1        )   ($2              )
         error_text = appendf("Bus-interface list expected [ [not]for {<bus-interface>,} <bus-interface> ], but got \"%s\"", bif_list);
         outcome = ERROR;
         return;
      };
      bifs = str_split($2, ",").apply(str_trim(it));
      if bifs.sort(it).unique(it).size() != bifs.size() { 
         error_text = appendf("Bus-interface list contains identical items: %s", bif_list);
         outcome = ERROR;
         return;
      };
      
      // Is the list of bus-interfaces an inverse list ?
      bifs_inverse = FALSE;
      if $1 == "notfor" {
         bifs_inverse = TRUE;
      }; 
      
      outcome = OK;
      return;
   };
   
};


//////////////////////////////////////////////////////////////////////////////////
// PATTERN_LITERAL parser.
// Handles literal strings such as "/frufru*/" or "...abc..."
// The string must be a real string literal (enclosed in double-quotes).
// This parser then tries to use the string as a match pattern, to validate it.
// If the text is not a string in double-quotes, the outcome is NO_MATCH.
// If it's a valid string literal that causes an error in str_match(), 
// the outcome is ERROR.
//
extend ifx_soc_macro_item_syntax_kind_t : [PATTERN_LITERAL];
extend PATTERN_LITERAL ifx_soc_macro_item_syntax_s {

   !pattern_literal: string;

   parse(source: string) is also {
      pattern_literal = str_trim(source);
      if pattern_literal !~ "/^\"(.*)\"$/" {
         outcome = NO_MATCH;
         error_text = "Not a string literal";
         pattern_literal = "";
         return;
      };
      details = $1;
      try {
         compute str_match("", details);
         outcome = OK;
      } else {
         outcome = ERROR;
         error_text = appendf("Invalid string match pattern %s", pattern_literal);
      };
   };
};

//////////////////////////////////////////////////////////////////////////////////
// METHOD_CALL parser.  Handles lines of the form 
//   method_name ( arg, arg, arg )
// Note, no trailing semicolon - it must have been already stripped off.
// Some simple processing is done on the args to ensure that quotes 
// and parentheses get paired appropriately, so that (for example)
// commas appearing as part of a string literal will not be interpreted
// as argument separators.
// Mismatched string quotes are flagged as an error.
// Mismatched parentheses are flagged as an error.
// The processing is certainly not bulletproof and should probably 
// be done more thoroughly at some point in the future.
// Optional space is tolerated in all the obvious places.
// No attempt is made to interpret individual arguments. 
// An empty argument list is accepted, as are empty individual arguments.
//
extend ifx_soc_macro_item_syntax_kind_t : [METHOD_CALL];
extend METHOD_CALL ifx_soc_macro_item_syntax_s {

   // Results of parsing
   !method_name : string;
   !arguments   : list of string;
   
   parse(source: string) is also {
   
      arguments.clear();
      method_name = "";
      
      if str_match(str_trim(source), "/^([a-zA-Z]\w*)\s*\(\s*(.*)\s*\)$/") {
         method_name = $1;
         details = $2;
      } else {
         return;  // outcome = NO_MATCH
      };
      
      // find the individual arguments, respecting parentheses and quotes.
      // "nesting" is the set of things that determine where we are in the
      // syntax: for example, opening parens and quotes.  The total state
      // of this list is exactly the state of the parser.  Normally it's
      // only the innermost (.top) item that matters.
      var nesting: list of string;
      var arg_start: uint = 0;
      for i from 0 to str_len(details)-1 {
         var ch := str_sub(details, i, 1);
         if nesting is empty {
            // We are at the outermost level
            case ch {
               ")" : // Close-parens are illegal here
                  {
                     error_text = appendf("unexpected close-parenthesis in \"%s...\"", 
                                     str_trim(str_sub(details, arg_start, 1+i-arg_start)) );
                     outcome = ERROR;
                     return;
                  };
               "(" : // start nested parens
                  { nesting.add(ch); };
               "\"" : // start a string literal
                  { nesting.add(ch); };
               "," : // this argument finished
                  {
                     arguments.add(str_trim(str_sub(details, arg_start, i-arg_start)));
                     arg_start = i+1;
                  };
            };
         } else {
            case nesting.top() {
               "\"" : // We're in a string literal.  Nesting rules are rather different.
                  {
                     case ch {
                        "\"" : // end of string literal
                           { compute nesting.pop(); };
                        "\\" : // backslash-escape
                           { nesting.add(ch);       };
                     };
                  };
               "\\" : // Finish a backslash-escape - Nothing to do.
                  { compute nesting.pop(); };
               "(" : // we're inside a set of parens
                  {
                     case ch {
                        ")" :  // close off these parens
                           { compute nesting.pop(); }; 
                        "(" :  // deeper nesting
                           { nesting.add(ch);       };
                        "\"" : // entering a string literal
                           { nesting.add(ch);       };
                     };
                  };
            };
         };
      };
      // Reached end of string.  Check all is well...
      var tail := str_trim(str_sub(details, arg_start, str_len(details)-arg_start));
      if nesting is not empty {
         error_text = appendf("Mismatched parentheses or quotes in \"%s\"", tail);
         outcome = ERROR;
      } else {
         // Looking good...
         arguments.add(tail);
         outcome = OK;
         return;
      };
   };
};

'>

