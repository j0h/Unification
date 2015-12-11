with terms, Ada.Strings.Unbounded;
use terms, Ada.Strings.Unbounded;
package term_parser is

    function Parse_Equation ( Input : String )
        return TEquation_Access;
    
end term_parser;
