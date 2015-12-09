with unification, terms, Ada.Text_IO, Ada.Strings.Unbounded;
use unification, Ada.Text_IO, Ada.Strings.Unbounded, terms;

procedure task4 is
    T0,T1, T2, x1, x3, x4, x2, T7, T8, T9, T10 : terms.TTerm_Access;
    f1_Access, f2_Access, f3_Access, f4_Access, f5_A, f6_A, h_Access : terms.TFunction_Access;
    f1_parameters, f2_parameters, f3_parameters, f4_parameters, f5_p, f6_p :
            terms.TParameters( Natural range 0..1 );
    h_parameters : terms.TParameters( Natural range 0..0 );
    equation1_1, equation1_2 : terms.TEquation_Access;
    
    procedure a is
        Set_A : terms.OS.List;
    begin 
        h_Access := new terms.TFunction_Symbol(P_Arity => 0);
        f1_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f2_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f3_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f4_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f5_A := new terms.TFunction_Symbol(P_Arity => 1);
        f6_A := new terms.TFunction_Symbol(P_Arity => 1);

        T0 := new terms.TTerm( P_Category => terms.Fnct ); -- f(
        T1 := new terms.TTerm( P_Category => terms.Fnct ); -- h(
        T2 := new terms.TTerm( P_Category => terms.Fnct ); -- f(
        x1 := new terms.TTerm( P_Category => terms.Var ); -- x_1
        x3 := new terms.TTerm( P_Category => terms.Var ); -- x_3
        x4 := new terms.TTerm( P_Category => terms.Var ); -- x_4
        x2 := new terms.TTerm( P_Category => terms.Var ); -- x_2
        T7 := new terms.TTerm( P_Category => terms.Fnct ); --f(
        T8 := new terms.TTerm( P_Category => terms.Fnct ); --f(
        T9 := new terms.TTerm( P_Category => terms.Fnct ); --f(x1,T10)
        T10 := new terms.TTerm( P_Category => terms.Fnct ); --f(x2,x2)


        f1_parameters(0) := T1;
        f1_parameters(1) := T2;
        f2_parameters(0) := x3;
        f2_parameters(1) := x4;
        f3_parameters(0) := x2;
        f3_parameters(1) := T8;
        f4_parameters(0) := x4;
        f4_parameters(1) := x2;
        f5_p(0) := x3;  
        f5_p(1) := T10; -- f(x2,x2)
        f6_p(0) := x2;
        f6_p(1) := x2;
        h_parameters(0) := x1;

        f1_Access.all.parameters := f1_parameters;
        f2_Access.all.parameters := f2_parameters;
        f3_Access.all.parameters := f3_parameters;
        f4_Access.all.parameters := f4_parameters;
        f5_A.all.parameters := f5_p;
        f6_A.all.parameters := f6_p;
        h_Access.all.parameters := h_parameters;

        T0.all.name := To_Unbounded_String("f");
        T0.all.Fnct := f1_Access;

        T1.all.name := To_Unbounded_String("h");
        T1.all.Fnct := h_Access;

        T2.all.name := To_Unbounded_String("f");
        T2.all.Fnct := f2_Access;

        T7.all.name := To_Unbounded_String("f");
        T7.all.Fnct := f3_Access;

        T8.all.name := To_Unbounded_String("f");
        T8.all.Fnct := f4_Access;

        T9.all.name := To_Unbounded_String("f");
        T9.all.Fnct := f5_A;

        T10.all.name := To_Unbounded_String("f");
        T10.all.Fnct := f6_A;

        x1.all.name := To_Unbounded_String("x_1");
        x3.all.name := To_Unbounded_String("x_3");
        x4.all.name := To_Unbounded_String("x_4");
        x2.all.name := To_Unbounded_String("x_2");

        equation1_1 := new terms.TEquation;
        equation1_1.Term_One := T0;
        equation1_1.Term_Two := T7;

        equation1_2 := new terms.TEquation;
        equation1_2.Term_One := T0;
        equation1_2.Term_Two := T9;
        Set_A.Append(equation1_1);
        Set_A.Append(equation1_2);

        unify(Set_A);

    end a;

    procedure b is
        Set_A : terms.OS.List;
    begin
        h_Access := new terms.TFunction_Symbol(P_Arity => 0);
        f1_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f2_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f3_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f4_Access := new terms.TFunction_Symbol(P_Arity => 1);
        f5_A := new terms.TFunction_Symbol(P_Arity => 1);
        f6_A := new terms.TFunction_Symbol(P_Arity => 1);

        T0 := new terms.TTerm( P_Category => terms.Fnct ); -- f(
        T1 := new terms.TTerm( P_Category => terms.Fnct ); -- h(
        T2 := new terms.TTerm( P_Category => terms.Fnct ); -- f(
        x1 := new terms.TTerm( P_Category => terms.Var ); -- x_1
        x3 := new terms.TTerm( P_Category => terms.Var ); -- x_3
        x4 := new terms.TTerm( P_Category => terms.Var ); -- x_4
        x2 := new terms.TTerm( P_Category => terms.Var ); -- x_2
        T7 := new terms.TTerm( P_Category => terms.Fnct ); --f(
        T8 := new terms.TTerm( P_Category => terms.Fnct ); --f(
        T9 := new terms.TTerm( P_Category => terms.Fnct ); --f(x1,T10)
        T10 := new terms.TTerm( P_Category => terms.Fnct ); --f(x2,x2)


        f1_parameters(0) := T1;
        f1_parameters(1) := T2;
        f2_parameters(0) := x3;
        f2_parameters(1) := x4;
        f3_parameters(0) := x2;
        f3_parameters(1) := T8;
        f4_parameters(0) := x4;
        f4_parameters(1) := x2;
        f5_p(0) := x1;  -- x1
        f5_p(1) := T10; -- f(x2,x2)
        f6_p(0) := x2;
        f6_p(1) := x2;
        h_parameters(0) := x1;

        f1_Access.all.parameters := f1_parameters;
        f2_Access.all.parameters := f2_parameters;
        f3_Access.all.parameters := f3_parameters;
        f4_Access.all.parameters := f4_parameters;
        f5_A.all.parameters := f5_p;
        f6_A.all.parameters := f6_p;
        h_Access.all.parameters := h_parameters;

        T0.all.name := To_Unbounded_String("f");
        T0.all.Fnct := f1_Access;

        T1.all.name := To_Unbounded_String("h");
        T1.all.Fnct := h_Access;

        T2.all.name := To_Unbounded_String("f");
        T2.all.Fnct := f2_Access;

        T7.all.name := To_Unbounded_String("f");
        T7.all.Fnct := f3_Access;

        T8.all.name := To_Unbounded_String("f");
        T8.all.Fnct := f4_Access;

        T9.all.name := To_Unbounded_String("f");
        T9.all.Fnct := f5_A;

        T10.all.name := To_Unbounded_String("f");
        T10.all.Fnct := f6_A;

        x1.all.name := To_Unbounded_String("x_1");
        x3.all.name := To_Unbounded_String("x_3");
        x4.all.name := To_Unbounded_String("x_4");
        x2.all.name := To_Unbounded_String("x_2");

        equation1_1 := new terms.TEquation;
        equation1_1.Term_One := T0;
        equation1_1.Term_Two := T7;

        equation1_2 := new terms.TEquation;
        equation1_2.Term_One := T0;
        equation1_2.Term_Two := T9;
        Set_A.Append(equation1_1);
        Set_A.Append(equation1_2);

        unify(Set_A);
        null;
    end b;
    
    procedure c is
        x0, x1, x2, y0, y1, y2 : TTerm_Access := new TTerm(P_Category => Var);
        a : TTerm_Access := new TTerm(P_Category => Const);
        g1, g2 : TTerm_Access := new TTerm(P_Category => Fnct);
        g1_a, g2_a : TFunction_Access := new TFunction_Symbol(P_Arity => 4);
        f1, f2, f3, f4, f5 : TTerm_Access := new TTerm(P_Category => Fnct);
        f1_a, f2_a, f3_a, f4_a, f5_a : TFunction_Access := 
            new TFunction_Symbol(P_Arity => 1);

        eq1 : TEquation_Access := new TEquation;
        Set_C : terms.OS.List;
    begin
        x0.name := To_Unbounded_String("x_0");
        x1.name := To_Unbounded_String("x_1");
        x2.name := To_Unbounded_String("x_2");
        y0.name := To_Unbounded_String("y_0");
        y1.name := To_Unbounded_String("y_1");
        y2.name := To_Unbounded_String("y_2");

        g1_a.parameters(0) := x1;
        g1_a.parameters(1) := x2;
        g1_a.parameters(2) := f1;
        g1_a.parameters(3) := f2;
        g1_a.parameters(4) := f3;
        g1.name := To_Unbounded_String("g");
        g1.fnct := g1_a;

        g2_a.parameters(0) := f4;
        g2_a.parameters(1) := f5;
        g2_a.parameters(2) := y1;
        g2_a.parameters(3) := y2;
        g2_a.parameters(4) := x2;
        g2.name := To_Unbounded_String("g");
        g2.fnct := g2_a;

        f1_a.parameters(0) := y0;
        f1_a.parameters(1) := y0;
        f1.name := To_Unbounded_String("f");
        f1.fnct := f1_a;

        f2_a.parameters(0) := y1;
        f2_a.parameters(1) := y1;
        f2.name := To_Unbounded_String("f");
        f2.fnct := f2_a;

        f3_a.parameters(0) := y2;
        f3_a.parameters(1) := y2;
        f3.name := To_Unbounded_String("f");
        f3.fnct := f3_a;

        f4_a.parameters(0) := x0;
        f4_a.parameters(1) := x0;
        f4.name := To_Unbounded_String("f");
        f4.fnct := f4_a;

        f5_a.parameters(0) := x1;
        f5_a.parameters(1) := x1;
        f5.name := To_Unbounded_String("f");
        f5.fnct := f5_a;
        eq1.Term_One := g1;
        eq1.Term_Two := g2;
        Set_C.Append(eq1);
        unify(Set_C);
    end c;
    
    procedure d is
        x1, x2, x3, x4 : TTerm_Access := new TTerm(P_Category => Var);
        a : TTerm_Access := new TTerm(P_Category => Const);
        g1, g2, g3, g4 : TTerm_Access := new TTerm(P_Category => Fnct);
        g1_a, g2_a, g3_a, g4_a : TFunction_Access := new TFunction_Symbol(P_Arity => 4);
        f1, f2, f3, f4, f5, f6 : TTerm_Access := new TTerm(P_Category => Fnct);
        f1_a, f2_a, f3_a, f4_a, f5_a, f6_a : TFunction_Access := 
            new TFunction_Symbol(P_Arity => 1);

        eq1 : TEquation_Access := new TEquation;
        Set_C : terms.OS.List;
    begin
        x1.name := To_Unbounded_String("x_1");
        x2.name := To_Unbounded_String("x_2");
        x3.name := To_Unbounded_String("x_3");
        x4.name := To_Unbounded_String("y_4");
        a.name := To_Unbounded_String("a");

        g1_a.parameters(0) := g2;
        g1_a.parameters(1) := f2;
        g1_a.parameters(2) := x1;
        g1_a.parameters(3) := x2;
        g1_a.parameters(4) := f3;
        g1.name := To_Unbounded_String("g");
        g1.fnct := g1_a;

        g2_a.parameters(0) := x1;
        g2_a.parameters(1) := f1;
        g2_a.parameters(2) := x2;
        g2_a.parameters(3) := x2;
        g2_a.parameters(4) := x3;
        g2.name := To_Unbounded_String("g");
        g2.fnct := g2_a;

        g3_a.parameters(0) := g4;
        g3_a.parameters(1) := f5;
        g3_a.parameters(2) := x1;
        g3_a.parameters(3) := x2;
        g3_a.parameters(4) := f6;
        g3.name := To_Unbounded_String("g");
        g3.fnct := g3_a;

        g4_a.parameters(0) := x2;
        g4_a.parameters(1) := x4;
        g4_a.parameters(2) := x1;
        g4_a.parameters(3) := x2;
        g4_a.parameters(4) := f4;
        g4.name := To_Unbounded_String("g");
        g4.fnct := g4_a;

        f1_a.parameters(0) := x1;
        f1_a.parameters(1) := a;
        f1.name := To_Unbounded_String("f");
        f1.fnct := f1_a;

        f2_a.parameters(0) := a;
        f2_a.parameters(1) := x2;
        f2.name := To_Unbounded_String("f");
        f2.fnct := f2_a;

        f3_a.parameters(0) := x2;
        f3_a.parameters(1) := a;
        f3.name := To_Unbounded_String("f");
        f3.fnct := f3_a;

        f4_a.parameters(0) := x4;
        f4_a.parameters(1) := x1;
        f4.name := To_Unbounded_String("f");
        f4.fnct := f4_a;

        f5_a.parameters(0) := x1;
        f5_a.parameters(1) := a;
        f5.name := To_Unbounded_String("f");
        f5.fnct := f5_a;

        f6_a.parameters(0) := x1;
        f6_a.parameters(1) := a;
        f6.name := To_Unbounded_String("f");
        f6.fnct := f6_a;

        eq1.Term_One := g1;
        eq1.Term_Two := g3;
        Set_C.Append(eq1);
        unify(Set_C);
    end d;
    
    procedure e is
        x0, x1, x2, y0, y1, y2 : TTerm_Access := new TTerm(P_Category => Var);
        a : TTerm_Access := new TTerm(P_Category => Const);
        g1, g2 : TTerm_Access := new TTerm(P_Category => Fnct);
        g1_a, g2_a : TFunction_Access := new TFunction_Symbol(P_Arity => 4);
        f1, f2, f3, f4, f5 : TTerm_Access := new TTerm(P_Category => Fnct);
        f1_a, f2_a, f3_a, f4_a, f5_a : TFunction_Access := 
            new TFunction_Symbol(P_Arity => 1);

        eq1 : TEquation_Access := new TEquation;
        Set_C : terms.OS.List;
    begin
        x0.name := To_Unbounded_String("x_0");
        x1.name := To_Unbounded_String("x_1");
        x2.name := To_Unbounded_String("x_2");
        y0.name := To_Unbounded_String("y_3");
        y1.name := To_Unbounded_String("y_1");
        y2.name := To_Unbounded_String("y_2");
        a.name := To_Unbounded_String("a");

        g1_a.parameters(0) := x2;
        g1_a.parameters(1) := x1;
        g1_a.parameters(2) := f1;
        g1_a.parameters(3) := f2;
        g1_a.parameters(4) := f3;
        g1.name := To_Unbounded_String("g");
        g1.fnct := g1_a;

        g2_a.parameters(0) := f4;
        g2_a.parameters(1) := y1;
        g2_a.parameters(2) := f5;
        g2_a.parameters(3) := x2;
        g2_a.parameters(4) := y0;
        g2.name := To_Unbounded_String("g");
        g2.fnct := g2_a;

        f1_a.parameters(0) := a;
        f1_a.parameters(1) := y0;
        f1.name := To_Unbounded_String("f");
        f1.fnct := f1_a;

        f2_a.parameters(0) := y1;
        f2_a.parameters(1) := y1;
        f2.name := To_Unbounded_String("f");
        f2.fnct := f2_a;

        f3_a.parameters(0) := y2;
        f3_a.parameters(1) := y2;
        f3.name := To_Unbounded_String("f");
        f3.fnct := f3_a;

        f4_a.parameters(0) := x0;
        f4_a.parameters(1) := x0;
        f4.name := To_Unbounded_String("f");
        f4.fnct := f4_a;

        f5_a.parameters(0) := x1;
        f5_a.parameters(1) := x1;
        f5.name := To_Unbounded_String("f");
        f5.fnct := f5_a;
        eq1.Term_One := g1;
        eq1.Term_Two := g2;
        Set_C.Append(eq1);
        unify(Set_C);
    end e;

begin

    begin
        a;
    exception       
        when Occur_Failure => 
            Put_Line("There was an occur failure in a");
        when Clash_Failure =>
            Put_Line("There was an clash failure in a");
    end;
    begin
        b;
    exception
        when Occur_Failure => 
            Put_Line("There was an occur failure in b");
        when Clash_Failure =>
            Put_Line("There was an clash failure in b");
    end;
    begin
        c;
    exception
        when Occur_Failure => 
            Put_Line("There was an occur failure in c");
        when Clash_Failure =>
            Put_Line("There was an clash failure in c");
    end;
    begin
        d;
    exception
        when Occur_Failure => 
            Put_Line("There was an occur failure in d");
        when Clash_Failure =>
            Put_Line("There was an clash failure in d");
    end;
    begin
        e;
    exception
        when Occur_Failure => 
            Put_Line("There was an occur failure in e");
        when Clash_Failure =>
            Put_Line("There was an clash failure in e");
    end;
    -- wtf did i do? i created some monster!
end task4;
