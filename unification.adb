with terms, Ada.Strings.Unbounded;
use terms, Ada.Strings.Unbounded;
with Ada.Text_IO;
use Ada.Text_IO;

package body unification is

    procedure unify ( Term_Set : in out terms.OS.List ) is
        use type terms.OS.Cursor;
        procedure Detect_Occur_Failure( Term_Set : in terms.OS.List )
        is
            procedure Iterator ( Position : terms.OS.Cursor ) is
                Element : terms.TEquation_Access := 
                    terms.OS.Element(Position);
            begin
                if Element.Term_One.Category = terms.Var then
                    if terms.Var_Is_Subterm(Element.Term_One, Element.Term_Two)
                    then
                        Put_Line(To_String(To_String(Element.Term_One) 
                            & To_Unbounded_String(" is subterm of ")
                            & To_String(Element.Term_Two)));
                        raise Occur_Failure;
                    end if;
                end if;
            end Iterator;
        begin
            terms.OS.Iterate( Term_Set, Iterator'Access );
        end Detect_Occur_Failure;

        function Delete ( Term_Set : in out terms.OS.List ) return Boolean
        is
            List_Cursor : terms.OS.Cursor := Term_Set.First;
            Last_Cursor : terms.OS.Cursor := Term_Set.Last;
            List_Element : terms.TEquation_Access := 
                terms.OS.Element(List_Cursor);
            Next : terms.OS.Cursor;
            Exit_Next_Iteration, found : Boolean := false;
        begin
            loop
                exit when Exit_Next_Iteration;
                if List_Cursor = Last_Cursor then
                    Exit_Next_Iteration := true;
                end if;
                
                List_Element := terms.OS.Element(List_Cursor);
                if List_Element.Term_Two.all =  List_Element.Term_One.all
                then
                    Put("Delete ");
                    Put_Line(To_String(terms.To_String(List_Element)));
                    Next := terms.OS.Next(List_Cursor); 
                    terms.OS.Delete(Term_Set, List_Cursor); 
                    List_Cursor := Next; 
                    found := true;
                else
                    terms.OS.Next(List_Cursor);
                end if;

            end loop;
            return found;
        end Delete;

        function Reduce_Terms ( Term_Set : in out terms.OS.List ) return Boolean
        is
            List_Cursor : terms.OS.Cursor := Term_Set.First;
            Last_Cursor : terms.OS.Cursor := Term_Set.Last;
            List_Element : terms.TEquation_Access := 
                terms.OS.Element(List_Cursor);
            Next : terms.OS.Cursor;
            Exit_Next_Iteration, found : Boolean := false;
        begin
            loop
                exit when Exit_Next_Iteration; 
                --List_Cursor = terms.OS.No_Element;
                if List_Cursor = Last_Cursor then
                    Exit_Next_Iteration := true;
                end if;
                List_Element := terms.OS.Element(List_Cursor);
                if List_Element.Term_One.Category /= terms.Var and then 
                    List_Element.Term_Two.Category /= terms.Var and then 
                    (List_Element.Term_One.Category = terms.Fnct or
                        List_Element.Term_One.Category = terms.Const)
                then
                    if List_Element.Term_One.name /= 
                        List_element.Term_Two.name 
                    then
                        raise Clash_Failure;
                    end if;

                    -- there is some f(...) =? f(...)
                    -- add parameters as new Equations to Term_Set
                    if List_Element.Term_One.Category /= terms.Const then
                        for i in 0 .. List_Element.Term_One.Fnct.parameters'Length - 1 loop
                            declare
                                eq : terms.TEquation_Access;
                            begin
                                eq := new terms.TEquation;
                                eq.Term_One := 
                                    List_Element.Term_One.Fnct.parameters(i);
                                eq.Term_Two := 
                                    List_Element.Term_Two.Fnct.parameters(i);
                                Term_Set.Append(eq);
                                Put("Appending new set equation ");
                                Put_Line(To_String(
                                    To_String(eq.Term_One) &
                                    To_Unbounded_String("=?") &
                                    To_String(eq.Term_Two)
                                ));
                           end;
                        end loop;
                    end if;
                    Put("Deleting the old function ");
                    Put_Line(To_String(
                        To_String(List_Element.Term_One) &
                        To_Unbounded_String("=?") &
                        To_String(List_Element.Term_Two)
                    ));
                    Next := terms.OS.Next(List_Cursor); 
                    terms.OS.Delete(Term_Set, List_Cursor); 
                    List_Cursor := Next; 
                    found := true;
                else 
                    terms.OS.Next(List_Cursor);
                end if; 
            end loop;
            return found;
        end Reduce_Terms;

        function Exchange ( Term_Set : in out terms.OS.List ) return Boolean 
        is
            operated : Boolean := false;
            procedure Iterator ( Position : terms.OS.Cursor ) is
                List_Element : terms.TEquation_Access := 
                    terms.OS.Element( Position);
                temp : TTerm_Access;
            begin
                if  (List_Element.Term_One.Category = terms.Fnct or
                    List_Element.Term_One.Category = terms.Const) and then
                    List_Element.Term_Two.Category = terms.Var
                then
                    temp := List_Element.Term_One;
                    List_Element.Term_One := List_Element.Term_Two;
                    List_Element.Term_Two := temp;
                    operated := true;
                    Put("Exchange old equation ");
                    Put_Line(To_String(
                        To_String(List_Element.Term_Two) &
                        To_Unbounded_String("=?") &
                        To_String(List_Element.Term_One)
                    ));

                end if;
            end Iterator;
        begin
            terms.OS.Iterate( Term_Set, Iterator'Access );
            return operated;
        end Exchange;

        function Reduce_Var ( Term_Set : in out terms.OS.List ) return Boolean 
        is
            operated : Boolean := false;
            procedure Search_Iterator ( Position : terms.OS.Cursor ) is 
            -- if we have some variable which does not occur in t and there 
            -- is some variable to be substituted by t, do it.
            --
            -- for every pair of terms
            --   is it of the correct form and is Used_As_Replacement unset?
            --     then replace everywhere. 
            --   else do nothing
                SearchList_Element : terms.TEquation_Access := 
                    terms.OS.Element(Position); 
                procedure Replace_Iterator ( Position : terms.OS.Cursor ) is
                    List_Element : terms.TEquation_Access := 
                        terms.OS.Element(Position);
                begin
                    if List_Element /= SearchList_Element then
                    Put("Process Substiting in ");
                    Put_Line(To_String(
                        To_String(List_Element.Term_Two) &
                        To_Unbounded_String("=?") &
                        To_String(List_Element.Term_One)
                    ));
                    Put("With Substitution ");
                    Put_Line(To_String(
                        To_String(SearchList_Element.Term_One) &
                        To_Unbounded_String("=?") &
                        To_String(SearchList_Element.Term_Two)
                    ));

                    terms.Substitute( Term => List_Element.Term_One,
                                      Substitution => SearchList_Element);
                    terms.Substitute( Term => List_Element.Term_Two,
                                      Substitution => SearchList_Element);
                    Put("Result: ");
                    Put_Line(To_String(
                        To_String(List_Element.Term_Two) &
                        To_Unbounded_String(" =? ") &
                        To_String(List_Element.Term_One)
                    ));
                    end if;

                end Replace_Iterator;

            begin
                if SearchList_Element.Term_One.Category = terms.Var and then
                    not SearchList_Element.Used_As_Replacement
                then
                    terms.OS.Iterate(Term_Set, Replace_Iterator'Access);
                    SearchList_Element.Used_As_Replacement := true;
                    operated := true;
                end if;
            end Search_Iterator;

        begin
            terms.OS.Iterate( Term_Set, Search_Iterator'Access );
            return operated;
        end Reduce_Var;

        reducable, result : Boolean := true;
    begin
        Put_Line("BEGINNING WITH UNIFICATION");
        Put_Line(To_String(Set_To_String(Term_Set)));
        Put_Line("Every possible Operation is done as often as possible.");
        while reducable loop
            reducable := false;
            Put_Line ("Reduce Variable starting....");
            result := Reduce_Var ( Term_Set );
            if result then 
                Put_Line("-----------------------------------------");
                Put_Line("Result");
                Put_Line (To_String(Set_To_String(Term_Set)));
                Put_Line("-----------------------------------------");
            end if;
            reducable := reducable or result;
            Put_Line ("Exchange starting....");
            result := Exchange ( Term_Set );
            if result then 
                Put_Line("-----------------------------------------");
                Put_Line("Result");
                Put_Line (To_String(Set_To_String(Term_Set)));
                Put_Line("-----------------------------------------");
            end if;
            reducable := reducable or result;
            Put_Line ("Reduce Terms starting....");
            result := Reduce_Terms ( Term_Set );
            if result then 
                Put_Line("-----------------------------------------");
                Put_Line("Result");
                Put_Line (To_String(Set_To_String(Term_Set)));
                Put_Line("-----------------------------------------");
            end if;
            reducable := reducable or result;
            Put_Line ("Delete starting....");
            result := Delete ( Term_Set );
            if result then 
                Put_Line("-----------------------------------------");
                Put_Line("Result");
                Put_Line (To_String(Set_To_String(Term_Set)));
                Put_Line("-----------------------------------------");
            end if;
            reducable := reducable or result;
            Put_Line("");
            Put_Line("-----------------------------------------");
            Put_Line("Result before Check and next Iteration");
            Put_Line (To_String(Set_To_String(Term_Set)));
            Put_Line("-----------------------------------------");
            Put_Line("");
            Put_Line ("Detecting Occur Failures....");
            Detect_Occur_Failure(Term_Set);
        end loop;
        Put_Line("Final Result found!");
        Put("The mgu is ");
        Put_Line (To_String(Set_To_String(Term_Set)));
        Put_Line("##################################################");
        Put_Line("");
    end unify;
end unification;
