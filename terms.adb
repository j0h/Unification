with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
package body terms is
    
    -- Two Terms are equal iff they are ame typed, named and have equal
    -- parameters if applicable.
    function Equal ( l, r : TTerm_Access ) return Boolean is
    begin
        if l.all.Category /= r.all.Category then 
            return false;
        end if;
        
        if l.all.name /= r.all.name then 
            return false;
        end if;

        if l.all.Category = Fnct then
            if l.all.Fnct.all.parameters'Length /= 
                r.all.Fnct.all.parameters'Length 
            then
                return false;    
            end if;
            for i in 0 .. l.all.Fnct.all.arity -  1 loop
                if not Equal( l.all.Fnct.all.parameters(i),
                            r.all.Fnct.all.parameters(i) ) 
                then
                    return false;
                end if;
            end loop;
        end if; 
        return true;
    end Equal;

    function Equal (l, r : TEquation_Access) return Boolean is
    begin
        if not Equal( l.all.Term_One, r.all.Term_One ) then
            return false;
        end if;

        if not Equal( l.all.Term_Two, r.all.Term_Two ) then
            return false;
        end if;

        return true;
    end Equal;
    
    
    function To_String (equation : not null TEquation_Access) return Ada.Strings.Unbounded.Unbounded_String
    is
        package SU renames Ada.Strings.Unbounded;
        cummulate_string : SU.Unbounded_String;
    begin
        SU.Append(cummulate_string, To_String(equation.Term_One));
        SU.Append(cummulate_string, "=?");
        SU.Append(cummulate_string, To_String(equation.Term_Two));
        return cummulate_string;
    end To_String;

    function To_String (term : not null TTerm_Access ) return Ada.Strings.Unbounded.Unbounded_String
    is 
        package SU renames Ada.Strings.Unbounded;
        cummulate_string : SU.Unbounded_String;
    begin
        case term.all.Category is
            when Var => 
                SU.Append(cummulate_string, term.all.name);
            when Fnct =>
                -- this is more interesting:
                -- Print function symbol, then opening (
                -- print tostring of all parameters
                -- print closing bracket )

                SU.Append(cummulate_string, term.all.name);
                SU.Append(cummulate_string, '(');
                for i in term.all.Fnct.all.parameters'Range loop 
                    SU.Append(cummulate_string, 
                        To_String(term.all.Fnct.all.parameters(i)));
                    if i < term.all.Fnct.all.parameters'Length - 1 then
                        SU.Append(cummulate_string, ',');
                    end if;
                end loop;
                SU.Append(cummulate_string, ')');
            when Const =>
                SU.Append(cummulate_string, term.all.name);
        end case;
        return cummulate_string;
    end To_String;
    
    function Set_To_String ( term_set : OS.List ) return SU.Unbounded_String
    is
        cummulate_string : SU.Unbounded_String;

        procedure Iterator (Position : in OS.Cursor) is
            List_Element : terms.TEquation_Access;
        begin 
            List_Element := OS.Element(Position);
            SU.Append(cummulate_string, To_String(List_Element.all.Term_One));
            SU.Append(cummulate_string, "=?");
            SU.Append(cummulate_string, To_String(List_Element.all.Term_Two));
            SU.Append(cummulate_string, ",");
        end Iterator;
    begin
        SU.Append(cummulate_string, '{');
        OS.Iterate(Container => term_set, Process => Iterator'Access );
        SU.Append(cummulate_string, '}');
        return cummulate_string;
    end Set_To_String;
     
    procedure Substitute ( Substitution : in TEquation_Access; 
                            Term : in out TTerm_Access) 
    is

    begin
        if Substitution.Term_One.Category /= Var then
            raise Constraint_Error; -- not a valid substitution
        end if;
        if Term.Category = Fnct then 
            if Term.name = Substitution.Term_One.name then
            for i in 0 .. Term.Fnct.parameters'Length - 1 loop
                if Term.Fnct.parameters(i).Category = Var then
                    Term.Fnct.parameters(i) := new TTerm(P_Category => 
                        Substitution.Term_Two.Category);
                    Term.Fnct.parameters(i).name := 
                        Substitution.Term_Two.name;
                    if Substitution.Term_Two.Category = Fnct then
                        Term.Fnct.parameters(i).Fnct := 
                            Substitution.Term_Two.Fnct;
                    end if;
                else
                    Substitute( Substitution => Substitution,
                            Term => Term.Fnct.parameters(i));
                end if;
            end loop;
            end if;
        elsif Term.Category = Var then
            if Term.name = Substitution.Term_One.name then
            Term := new TTerm(P_Category => 
                Substitution.Term_Two.Category);
            Term.name := 
                Substitution.Term_Two.name;
            if Substitution.Term_Two.Category = Fnct then
                Term.Fnct := 
                    Substitution.Term_Two.Fnct;
            end if;
            end if;
        end if;

    end Substitute;


    function Var_Is_Subterm ( Var_Term : TTerm_Access; Term : TTerm_Access )
        return Boolean
     is
        Has_Subterm : Boolean := false;
     begin
        if Var_Term.Category /= Var then
            raise Not_A_Var_Error;
        end if;

        if Term.Category = Fnct then
            for i in 0 .. Term.Fnct.parameters'Length - 1 loop
                Has_Subterm := Has_Subterm or 
                    Var_Is_Subterm( Var_Term, Term.Fnct.parameters(i));
            end loop;
            return Has_Subterm;
        end if;

        if Term.Category = Var and then Term.name = Var_Term.name then
            return true;
        else 
            return false;
        end if;
    end Var_Is_Subterm;
end terms;
