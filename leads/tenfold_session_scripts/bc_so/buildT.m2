-- BC-SO: own construction of an elliptic sextic scroll T in P^5 (join of E in plane A and E in plane B via |3O| and |2O+P0|)
buildT = (p, sd) -> (
    setRandomSeed sd;
    kk := ZZ/p;
    -- random Weierstrass curve with a point P0
    R0 := kk[X,Y,Z];
    local a; local b; local x0; local y0; local Ecurve;
    while true do (
        a = random kk; x0 = random kk; y0 = random kk;
        -- choose b so that P0=(x0,y0) on E: y0^2 = x0^3 + a x0 + b
        b = y0^2 - x0^3 - a*x0;
        if y0 != 0 and 4*a^3 + 27*b^2 != 0 then break;
        );
    Ecurve = Y^2*Z - X^3 - a*X*Z^2 - b*Z^3;
    A := kk[X,Y,Z,lam,mu, Degrees=>{{1,0},{1,0},{1,0},{0,1},{0,1}}];
    EA := sub(Ecurve, A);
    l := sub(X - x0*Z, A);
    phi1 := {sub(X,A), sub(Y,A), sub(Z,A)};
    phi2 := {sub(Z*(X - x0*Z),A), sub(X*(X - x0*Z),A), sub(Z*(Y + y0*Z),A)};
    W := kk[w_0..w_5];
    f := map(A/ideal(EA), W, apply(phi1, u -> lam*u*l) | apply(phi2, u -> mu*u));
    IT := ker f;
    (IT, a, b, x0, y0)
    );
end
