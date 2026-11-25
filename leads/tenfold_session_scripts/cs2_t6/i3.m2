-- CS2-T6 type I3: HF(3) of random projections to P^11 of rational normal 5-fold scrolls S(a), and of elliptic 5-fold scrolls (via Segre embedding check)
-- HF_Z(3) = rank of the 364 cubic monomials in the 12 projected coordinate functions (Cox ring of P(O(a_1)+...+O(a_5)) over P^1). usage: M2 --script i3.m2 seed p
pr = s -> (stderr << s << endl << flush);
sd = value scriptCommandLine#1; p = value scriptCommandLine#2; kk = ZZ/p; setRandomSeed(sd);
hfScroll = a -> (
   R := kk[t_0, t_1, u_0..u_4];
   crd := flatten apply(5, i -> apply(a#i + 1, j -> u_i * t_0^j * t_1^(a#i - j)));
   n := #crd; A := random(kk^12, kk^n);
   pf := apply(12, k -> sum(n, j -> A_(k,j) * crd#j));
   S12 := kk[y_0..y_11]; m3 := flatten entries basis(3, S12);
   ev := apply(m3, mm -> (e := first exponents mm; product(12, k -> (pf#k)^(e#k))));
   -- group by multidegree: rank of coefficient matrix
   Mt := matrix{ev}; (mons, cf) := coefficients Mt; r := rank mutableMatrix lift(cf, kk);
   h3 := sum(flatten entries basis(3, kk[w_0..w_4]), mm -> (e := first exponents mm; sum(5, i -> e#i * a#i) + 1));
   pr("scroll S" | toString a | " degree " | toString sum a | " in P^" | toString(n-1) | " projected to P^11: HF_Z(3) = " | toString r | " (h^0(O(3)) = " | toString h3 | ")");
   r);
hfScroll({2,2,2,2,1}); hfScroll({3,2,2,1,1}); hfScroll({3,3,2,2,2}); hfScroll({1,1,1,1,2});
