with Ada.Strings.Fixed, Ada.Text_IO, terms;
use Ada.Strings.Fixed, Ada.Text_IO, terms;
package body term_parser is

    function Parse_Term ( Input : String ) return TTerm_Access
    is
        output : TTerm_Access;
        name : Unbounded_String;
        function Get_Arity ( Input : String ) return Integer
        is
            bracket_counter, arity : Integer := -1;
        begin
            for i in Input'Range loop
                case Input(i) is
                    when '(' => bracket_counter := bracket_counter + 1;
                    when ')' => bracket_counter := bracket_counter - 1;
                    when ',' =>
                        if bracket_counter = 0 then
                            arity := arity + 1;
                        end if;
                    when others => null;
                end case;
            end loop;
            return arity + 1;
        end Get_Arity;
        
    begin
        -- find first (
        -- if there is none, return a variable
        -- else determine arity, split by ',' and set for every parameter := parse_term
        outer:
        for i in Input'Range loop
            if Input (i) /= ' ' then
                if Input (i) /= '(' then
                    Append (name, Input(i));
                else
                    -- function, take previous name
                    declare
                        arity : Integer := Get_Arity(Input);
                        new_i : Integer := i;
                        count : Integer := 1;
                    begin
                        output := new TTerm(P_Category => terms.Fnct);
                        output.name := name;
                        output.Fnct := new TFunction_Symbol(P_Arity => arity);
                        for j in 0 .. arity loop
                            term:
                            for k in new_i + 1 .. Input'Length loop
                                declare
                                    to_parse : String := Input(new_i+1 .. k-1);
                                begin
                                    case Input (k) is
                                    when ',' => 
                                        if count = 1 then
                                            output.Fnct.parameters(j) := 
                                                Parse_Term(to_parse);
                                            new_i := k; -- take next arity
                                            exit term;
                                        end if;
                                    when '(' => 
                                        count := count + 1;
                                    when ')' => 
                                        count := count - 1;
                                        -- edge case : f(x,y,z) z will not be recconed without
                                        if count = 0 then
                                            output.Fnct.parameters(j) :=
                                                Parse_Term(to_parse);
                                            new_i := k;
                                            exit term; -- take next arity
                                        end if;
                                    when others => null;
                                    end case;
                                end;
                            end loop term;
                        end loop;
                        return output;
                    end;
                end if;
            end if;
        end loop outer;
        if output = null then
            output := new TTerm(P_Category => terms.Var);
            output.name := name;
        end if;
        <<ret>>
        return output;
    end Parse_Term;
    
    function Parse_Equation ( Input : String ) return TEquation_Access 
    is
        type termstate is (one, two);
        state : termstate := one;
        term_two, term_one : Unbounded_String;
        equation : TEquation_Access := new TEquation;
    begin
        for i in 1 .. Input'Length loop
            case Input (i) is
                when ' ' => null;
                when '=' => state := two;
                when others => 
                    if state = one then
                        Append(term_one, Input(i));
                    else 
                        Append(term_two, Input(i));
                    end if;
            end case;
        end loop;
        equation.Term_One := Parse_Term(To_String(term_one));
        equation.Term_Two := Parse_Term(To_String(term_two));
        return equation;
    end Parse_Equation;
end term_parser;
