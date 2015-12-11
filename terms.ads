with Ada.Strings.Unbounded;
with Ada.Containers.Doubly_Linked_Lists;
package Terms is  
    package SU renames Ada.Strings.Unbounded;
    Not_A_Var_Error : exception;

    -- function symbol of arity and name
    type TFunction_Symbol;
    -- access type to a function
    type TFunction_Access is access all TFunction_Symbol;
    
    type TTerm;
    type TTerm_Access is access all TTerm;
    
    type TEquation is record
        Term_One : TTerm_Access;
        Term_Two : TTerm_Access;
        Used_As_Replacement : Boolean := false;
    end record;
    type TEquation_Access is access all TEquation; 
    
    function Equal ( l, r : TEquation_Access ) return Boolean;

    -- This set is the Unification Problem
    -- It contains quations t =^? s
    -- Equality is defined as the syntactic equality on these sets.
    -- Equality therefor checks whether for some u-problems s and d, s = t does hold
    package OS is new Ada.Containers.Doubly_Linked_Lists(
        Element_Type => TEquation_Access,
        "=" => Equal
    );   

    type TConstant;
    type TConstant_Access is access all TConstant; 
    subtype Variable_Number is Integer range 1 .. 10;
    subtype TVariable is SU.Unbounded_String;

    -- parameter definition.
    type TParameters is Array(Natural range <>) of TTerm_Access;
    type TTerm_Category is (Const, Fnct, Var);

    type TTerm ( P_Category : TTerm_Category ) 
    is record 
        Category : TTerm_Category := P_Category;
        name : SU.Unbounded_String;
        case P_Category is
            when Const =>
                Const : TConstant_Access;
            when Fnct =>
                Fnct : TFunction_Access;
            when Var =>
                var_name : TVariable;
        end case;
    end record;

    type TFunction_Symbol ( P_Arity : Natural ) is record 
        -- meta level information.
        arity : Integer := P_Arity;
        parameters : TParameters( 0 .. P_Arity );
        -- 
    end record;    
    
    type TConstant is new TFunction_Symbol( P_Arity => 0 );
    
    function To_String( term : not null TTerm_Access ) return Ada.Strings.Unbounded.Unbounded_String;
    function Set_To_String ( term_set : OS.List ) return SU.Unbounded_String; 
    function To_String (equation : not null TEquation_Access) 
        return Ada.Strings.Unbounded.Unbounded_String;
    procedure Substitute ( Substitution : in TEquation_Access; 
                            Term : in out TTerm_Access); 
    function Var_Is_Subterm ( Var_Term : TTerm_Access; Term : TTerm_Access )
        return Boolean;
    
end Terms;

