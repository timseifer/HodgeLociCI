-- CS2-T6: AHTV T in special coordinates (B = x0..x2 coordinates of P_h-points, A = x3..x5 of P_f-points), with explicit ruling points.
-- expects S = kk[x_0..x_11], kk. Defines Ns, IT, IV (= J(Pi,T), Pi = x6..x8), rulingPoint() -> (a, b) in kk^3 x kk^3 with b^T N_k a = 0.
fB = {x_0,x_1,x_2}; hA = {x_3,x_4,x_5};
Ns = apply(3, k -> random(kk^3, kk^3));
qs = apply(Ns, Nk -> sum flatten apply(3, i -> apply(3, j -> Nk_(i,j) * fB#i * hA#j)));
IT = trim saturate(ideal qs : intersect(ideal fB, ideal hA));
IV = trim(IT + ideal(x_9, x_10, x_11));
Rl = kk[lam];
rulingPoint = () -> (
   found := null;
   while found === null do (
      u := random(kk^3, kk^1); v := random(kk^3, kk^1);
      av := sub(u, Rl) + lam * sub(v, Rl);
      D := det(fold((X, Y) -> X | Y, apply(Ns, Nk -> sub(Nk, Rl) * av)));
      fs := select(apply(toList factor D, fc -> fc#0), g -> first degree g == 1);
      if #fs > 0 then (
         r := - (coefficient(1_Rl, fs#0)) / (coefficient(lam, fs#0));
         a := u + r * v;
         Mb := transpose fold((X, Y) -> X | Y, apply(Ns, Nk -> Nk * a));   -- rows (N_k a)^T
         kb := gens ker Mb;
         if numColumns kb == 1 then found = (a, kb)));
   found);
-- point of P^11 from (B-part, A-part, Pi-part, C-part)
pt = (bB, aA, pP, cC) -> flatten entries bB | flatten entries aA | flatten entries pP | flatten entries cC;
linIdeal = vecs -> (Mv := transpose matrix apply(vecs, v -> apply(v, c -> sub(c, kk))); ideal((vars S) * gens ker transpose Mv));
