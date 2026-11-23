-- -*- coding: utf-8 -*-
-- HodgeLociCI: Hodge loci of combinations of complete-intersection cycles in hypersurfaces.
--
-- STATUS. Code produced by AI agents under the direction of Timothy Seifert; not yet reviewed by a human.
-- The mathematics implemented here comes from AI-written manuscripts that no human has refereed.
-- Nothing in this package is, or bears on, a proof or disproof of the Hodge conjecture.
--
-- Licence: MIT (see the file LICENSE at the root of the repository).
--
-- Layout:
--   HodgeLociCI.m2                      this file: newPackage, loads, top documentation node
--   HodgeLociCI/Excess.m2               item 1: excess calculator, first-order tools, residues   (code + export)
--   HodgeLociCI/ExcessDoc.m2            its documentation nodes
--   HodgeLociCI/ExcessTests.m2          its TEST blocks
--   HodgeLociCI/SecondOrder.m2          item 2: second-order checker                             (code + export)
--   HodgeLociCI/SecondOrderDoc.m2, SecondOrderTests.m2
--   HodgeLociCI/Fermat.m2               item 3: Fermat-point higher-order expansion              (code + export)
--   HodgeLociCI/FermatDoc.m2, FermatTests.m2
--   HodgeLociCI/ValidationTests.m2      item 4: validation tests with stated sources (TEST blocks only)
-- Every code file starts with its own `export { ... }`; documentation and tests are loaded after
-- beginDocumentation().

newPackage(
    "HodgeLociCI",
    Version => "0.1.1",
    Date => "2026-11-23",
    Authors => {{Name => "Timothy Seifert"}},
    Headline => "Hodge loci of combinations of complete-intersection cycles in hypersurfaces",
    Keywords => {"Algebraic Geometry"},
    DebuggingMode => false,
    AuxiliaryFiles => true
    )

-- code (each file exports its own symbols)
load "./HodgeLociCI/Excess.m2"
load "./HodgeLociCI/SecondOrder.m2"
load "./HodgeLociCI/Fermat.m2"

beginDocumentation()

doc ///
  Key
    HodgeLociCI
  Headline
    Hodge loci of combinations of complete-intersection cycles in hypersurfaces
  Description
    Text
      {\bf Status.} This package was written by AI agents under the direction of Timothy Seifert and has
      not yet been reviewed by a human. The statements it implements come from AI-written manuscripts
      that no human has refereed. Nothing here is, or bears on, a proof or disproof of the Hodge
      conjecture.
    Text
      Labels used in every documentation node and test:
      {\bf EXACT} (computed in exact arithmetic over the rational numbers or a cyclotomic field),
      {\bf MOD p} (computed modulo a prime at one instance: evidence, not proof),
      {\bf PROVED} (proved in an AI-written, unreviewed manuscript; the theorem is cited),
      {\bf COMPUTED ONLY} (observed in computations, no proof claimed).
    Text
      {\bf Contents.} For two complete intersections $Y_1 = V(f,p)$, $Y_2 = V(h,p)$ of dimension $k$ on a smooth
      hypersurface $X$ of degree $d$ and dimension $2k$ (see @TO "the setting of paper 3"@), the package computes
      the first-order excess of the Hodge locus of $[Y_1] + \lambda [Y_2]$ over the locus where both cycles deform,
      from the degrees alone (@TO excessFromDegrees@, @TO linearSubspaceCase@) or at a given point
      (@TO excessFromData@, @TO tangentExcess@, @TO verifyExcess@), and the second-order obstruction on the excess
      directions (@TO secondOrderObstruction@, @TO secondOrderQuadrics@). Utilities: Grothendieck residues
      (@TO grothendieckResidue@), period polynomials (@TO periodPolynomial@), the tangent codimension of the Hodge
      locus of an arbitrary half-dimensional subvariety (@TO hodgeLocusTangentCodim@), Hodge numbers and the Hodge
      level of a hypersurface (@TO hodgeLevel@). Higher-order expansions at Fermat points are in the functions
      whose names begin with fermat.
    Example
      r = excessFromDegrees(4, {1}, {1}, {1,1});
      (r#"tau", r#"lambda0", r#"inRange", r#"excessAtLambda0", r#"excessElsewhere")
      D = randomCyclePair(4, {1}, {1}, {1,1}, Seed => 26);
      e = excessFromData D;
      (e#"excessAtLambda0", e#"excessElsewhere")
      (verifyExcess D)#"agrees"
      o = secondOrderObstruction(D, 2);
      (o#"verdict", o#"arithmetic")
  Subnodes
    "the setting of paper 3"
    :The excess calculator (first order)
    excessFromDegrees
    linearSubspaceCase
    CyclePair
    cyclePair
    randomCyclePair
    reduceModPrime
    excessFromData
    tangentExcess
    verifyExcess
    :The second-order checker
    secondOrderObstruction
    secondOrderQuadrics
    secondOrderFunctional
    :The Fermat higher-order expansion
    "Fermat higher-order expansion"
    :Utilities
    grothendieckResidue
    residueFunctional
    periodPolynomial
    hodgeLocusTangentCodim
    isSmoothHypersurface
    hodgeLevel
    primitiveHodgeNumbers
    ciHilbertFunction
    NotDetermined
    Seed
    CheckSmooth
///

load "./HodgeLociCI/ExcessDoc.m2"
load "./HodgeLociCI/SecondOrderDoc.m2"
load "./HodgeLociCI/FermatDoc.m2"

-- tests
load "./HodgeLociCI/ExcessTests.m2"
load "./HodgeLociCI/SecondOrderTests.m2"
load "./HodgeLociCI/FermatTests.m2"
load "./HodgeLociCI/ValidationTests.m2"

end--
