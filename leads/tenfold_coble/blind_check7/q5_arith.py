# Q5: lattice arithmetic.  basis h5, P1, P2 ; Gram
import itertools, sympy as sp
Gm = sp.Matrix([[3,1,1],[1,-21,3],[1,3,-21]])
a,r,s = sp.symbols('a r s')
v = sp.Matrix([a,r,s])
hv = (sp.Matrix([1,0,0]).T*Gm*v)[0]; vv = (v.T*Gm*v)[0]
disc = sp.expand(3*vv - hv**2)
print("disc<h^5, a h^5 + r P1 + s P2> =", disc, " ; equals -8(8r^2-2rs+8s^2):", sp.expand(disc + 8*(8*r**2-2*r*s+8*s**2)) == 0)
print("det Gram =", Gm.det())
vals = {}
for rr in range(-40,41):
    for ss in range(-40,41):
        vals.setdefault(8*rr*rr-2*rr*ss+8*ss*ss, []).append((rr,ss))
for t in (14,16,18):
    print(f"8r^2-2rs+8s^2 = {t}: solutions with |r|,|s|<=40:", vals.get(t, []), "(form >= 7(r^2+s^2), so the search box is exhaustive)")
print("small values represented:", sorted(k for k in vals if k <= 60))
print("3*SS - m^2 mod 3 over all residues:", sorted({(3*S - m*m) % 3 for S in range(3) for m in range(3)}), "; -8*16 mod 3 =", (-128) % 3, "; -8*14 mod 3 =", (-112) % 3, "; -8*18 mod 3 =", (-144) % 3)
# which (m, SS) give disc -112, -144 ; and self-intersections of P1+P2, P1-P2
for (rr,ss) in ((1,1),(1,-1)):
    w = sp.Matrix([0,rr,ss]); print(f"class {rr}P1+{ss}P2: degree m = {(sp.Matrix([1,0,0]).T*Gm*w)[0]}, self-intersection = {(w.T*Gm*w)[0]}, disc = {3*(w.T*Gm*w)[0]-((sp.Matrix([1,0,0]).T*Gm*w)[0])**2}")
# degrees 18 - 2 chi
for nm,chi in (("K3",2),("Enriques",1),("abelian",0),("bielliptic",0)): print(nm, "degree", 18-2*chi, " -8*deg =", -8*(18-2*chi), " 4*deg (nodes) =", 4*(18-2*chi))
# P^5's meeting in a P^j inside a cubic tenfold: excess intersection number c_j( (1+h)^(5-j+... ) )
h = sp.symbols('h')
for j in range(0,5):
    # excess bundle E = N_{P1/X}|_{P^j} / N_{P^j/P2},  c(E) = (1+h)^6/(1+3h) / (1+h)^(5-j)
    ser = sp.series((1+h)**(j+1)/(1+3*h), h, 0, j+1).removeO()
    print(f"two P^5 meeting along a P^{j}: P1.P2 = ", sp.Poly(ser,h).coeff_monomial(h**j))
