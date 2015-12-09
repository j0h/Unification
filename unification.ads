with Terms;

package unification is
    Occur_Failure, Clash_Failure : exception;
    procedure unify ( Term_Set: in out Terms.OS.List );
end unification;
