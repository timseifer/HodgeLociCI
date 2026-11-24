-- cloud-job-2 (PK2): ONE degree type of T6c's jump scan (same lines as t6_unsolved/c/run_jump.m2 for that type).
-- usage (working directory jobs/cloud-job-2/m2scan): M2 --script run_one.m2 d k idx seed maxroots
--   idx = 0-based index among the 'TYPE d k ' lines of enum_types.out; MOD 32003; checker at lambda = 2.
load "jump.m2";
args = drop(commandLine, position(commandLine, a -> match("run_one.m2", a)) + 1);
dD = value args#0; kK = value args#1; iX = value args#2; sD = value args#3; mR = value args#4;
L = select(lines get "enum_types.out", l -> match("^TYPE " | toString dD | " " | toString kK | " ", l));
l = L#iX;
F = value replace(".*F=(\\{[^}]*\\}).*", "\\1", l);
H = value replace(".*H=(\\{[^}]*\\}).*", "\\1", l);
P = value replace(".*P=(\\{[^}]*\\}).*", "\\1", l);
t0 = cpuTime();
pre = "JUMP " | toString dD | " " | toString kK | " F=" | toString F | " H=" | toString H | " P=" | toString P;
r = try jumpPoints(dD, F, H, P, Seed => sD, MaxRoots => mR) else {"ERROR", {}};
print(pre | " info=" | r#0 | " t=" | toString(cpuTime()-t0));
for D in r#1 do (
  if not instance(D, CyclePair) then (print(pre | " point=" | toString D); continue);
  out := try (
    e := excessFromData D; a := secondOrderObstruction(D, 2);
    "E'=" | toString(e#"dimAnnDetM") | " S=" | toString(e#"conditionS") | " dimK=" | toString(a#"dimK") | " verdict=" | a#"verdict" | " rankQ=" | toString(a#"rankOfQuadrics")
  ) else "CHECK ERROR";
  print(pre | " point " | out | " t=" | toString(cpuTime()-t0));
);
