module Walk = Gamblers_ruin.Walk
module Engine = Gamblers_ruin.Engine
module Analytic = Gamblers_ruin.Analytic
module Simulate = Gamblers_ruin.Simulate

(* --- the model -------------------------------------------------------------- *)

let test_constant_win () =
  let w = Walk.constant ~target:10 ~p:0.5 in
  Alcotest.(check int) "target preserved" 10 w.Walk.target;
  Alcotest.(check (float 1e-12)) "constant win prob" 0.5 (w.Walk.win 3)
;;

let test_general_win () =
  let w = Walk.create ~target:5 ~win:(fun i -> float_of_int i /. 10.) in
  Alcotest.(check (float 1e-12)) "state-dependent win" 0.3 (w.Walk.win 3)
;;

let test_rejects_bad_p () =
  Alcotest.check_raises
    "p out of range"
    (Invalid_argument "Walk.constant: p must be in [0, 1]")
    (fun () -> ignore (Walk.constant ~target:10 ~p:1.5))
;;

let test_rejects_small_target () =
  Alcotest.check_raises
    "target too small"
    (Invalid_argument "Walk.create: target must be >= 2")
    (fun () -> ignore (Walk.create ~target:1 ~win:(fun _ -> 0.5)))
;;

(* --- engine: special cases -------------------------------------------------- *)

let test_fair_special () =
  let n = 10 in
  let w = Walk.constant ~target:n ~p:0.5 in
  let h = Engine.ruin_probabilities w in
  let k = Engine.expected_durations w in
  for i = 0 to n do
    Alcotest.(check (float 1e-9))
      (Printf.sprintf "h_%d" i)
      (float_of_int (n - i) /. float_of_int n)
      (Float.Array.get h i);
    Alcotest.(check (float 1e-9))
      (Printf.sprintf "k_%d" i)
      (float_of_int (i * (n - i)))
      (Float.Array.get k i)
  done
;;

let test_unfair_example () =
  let n = 5 in
  let w = Walk.constant ~target:n ~p:0.4 in
  let h = Engine.ruin_probabilities w in
  (* Known answer for r = q/p = 1.5, N = 5: h_i = (r^N - r^i) / (r^N - 1). *)
  let expected =
    [| 1.0
     ; 0.9241706161137441
     ; 0.8104265402843602
     ; 0.6398104265402843
     ; 0.3838862559241706
     ; 0.0
    |]
  in
  for i = 0 to n do
    Alcotest.(check (float 1e-9))
      (Printf.sprintf "h_%d" i)
      expected.(i)
      (Float.Array.get h i)
  done
;;

(* --- analytic --------------------------------------------------------------- *)

let test_analytic_rejects_nonconstant () =
  let w = Walk.create ~target:6 ~win:(fun i -> if i < 3 then 0.4 else 0.6) in
  Alcotest.check_raises
    "non-constant"
    (Invalid_argument "Analytic: walk does not have a constant win probability")
    (fun () -> ignore (Analytic.ruin_probability w ~start:2))
;;

(* --- simulation ------------------------------------------------------------- *)

let test_reproducible () =
  let w = Walk.constant ~target:12 ~p:0.45 in
  let a = Simulate.monte_carlo w ~start:5 ~trials:1000 ~seed:7 in
  let b = Simulate.monte_carlo w ~start:5 ~trials:1000 ~seed:7 in
  Alcotest.(check (pair (float 1e-12) (float 1e-12))) "same seed yields same result" a b
;;

let test_trajectory_endpoints () =
  let n = 8 in
  let w = Walk.constant ~target:n ~p:0.5 in
  let t = Simulate.trajectory w ~start:3 ~seed:123 in
  Alcotest.(check int) "starts at start" 3 t.(0);
  let last = t.(Array.length t - 1) in
  Alcotest.(check bool) "ends absorbed" true (last = 0 || last = n);
  let interior_ok = ref true in
  for i = 1 to Array.length t - 2 do
    if t.(i) <= 0 || t.(i) >= n then interior_ok := false
  done;
  Alcotest.(check bool) "interior strictly inside" true !interior_ok
;;

let test_sim_matches_analytic () =
  let w = Walk.constant ~target:10 ~p:0.5 in
  let ruin_freq, _ = Simulate.monte_carlo w ~start:4 ~trials:20000 ~seed:42 in
  let analytic = Analytic.ruin_probability w ~start:4 in
  (* Loose by design: ruin prob 0.6, so SE ~ 0.0035 over 20000 trials; 0.03 is ~8 sigma
     and never flakes on the fixed seed. *)
  Alcotest.(check bool)
    (Printf.sprintf "sim %.4f near analytic %.4f" ruin_freq analytic)
    true
    (Float.abs (ruin_freq -. analytic) < 0.03)
;;

(* --- property-based invariants & agreement ---------------------------------- *)

let gen_walk = QCheck.(pair (int_range 2 30) (int_range 1 19))

let prop_engine_invariants =
  QCheck.Test.make ~count:200 ~name:"engine invariants" gen_walk (fun (n, pn) ->
    let p = float_of_int pn /. 20. in
    let w = Walk.constant ~target:n ~p in
    let h = Engine.ruin_probabilities w in
    let k = Engine.expected_durations w in
    let ok = ref true in
    let near a b = Float.abs (a -. b) <= 1e-9 in
    if not (near (Float.Array.get h 0) 1.0) then ok := false;
    if not (near (Float.Array.get h n) 0.0) then ok := false;
    if not (near (Float.Array.get k 0) 0.0) then ok := false;
    if not (near (Float.Array.get k n) 0.0) then ok := false;
    for i = 0 to n do
      let hi = Float.Array.get h i in
      if hi < -1e-9 || hi > 1.0 +. 1e-9 then ok := false;
      if Float.Array.get k i < -1e-9 then ok := false
    done;
    for i = 0 to n - 1 do
      if Float.Array.get h (i + 1) > Float.Array.get h i +. 1e-9 then ok := false
    done;
    !ok)
;;

let prop_engine_matches_analytic =
  QCheck.Test.make ~count:200 ~name:"engine matches analytic" gen_walk (fun (n, pn) ->
    let p = float_of_int pn /. 20. in
    let w = Walk.constant ~target:n ~p in
    let h = Engine.ruin_probabilities w in
    let ok = ref true in
    for i = 1 to n - 1 do
      let a = Analytic.ruin_probability w ~start:i in
      if Float.abs (Float.Array.get h i -. a) > 1e-6 then ok := false
    done;
    !ok)
;;

let prop_engine_matches_analytic_durations =
  QCheck.Test.make
    ~count:200
    ~name:"engine matches analytic durations"
    gen_walk
    (fun (n, pn) ->
       let p = float_of_int pn /. 20. in
       let w = Walk.constant ~target:n ~p in
       let k = Engine.expected_durations w in
       let ok = ref true in
       for i = 1 to n - 1 do
         let a = Analytic.expected_duration w ~start:i in
         if Float.abs (Float.Array.get k i -. a) > 1e-6 *. (1. +. Float.abs a)
         then ok := false
       done;
       !ok)
;;

let () =
  Alcotest.run
    "gamblers_ruin"
    [ ( "walk"
      , [ Alcotest.test_case "constant win" `Quick test_constant_win
        ; Alcotest.test_case "general win" `Quick test_general_win
        ; Alcotest.test_case "rejects bad p" `Quick test_rejects_bad_p
        ; Alcotest.test_case "rejects small target" `Quick test_rejects_small_target
        ] )
    ; ( "engine"
      , [ Alcotest.test_case "fair special case" `Quick test_fair_special
        ; Alcotest.test_case "unfair example" `Quick test_unfair_example
        ] )
    ; ( "analytic"
      , [ Alcotest.test_case
            "rejects non-constant walk"
            `Quick
            test_analytic_rejects_nonconstant
        ] )
    ; ( "simulate"
      , [ Alcotest.test_case "reproducible" `Quick test_reproducible
        ; Alcotest.test_case "trajectory endpoints" `Quick test_trajectory_endpoints
        ; Alcotest.test_case "matches analytic" `Slow test_sim_matches_analytic
        ] )
    ; ( "properties"
      , [ QCheck_alcotest.to_alcotest prop_engine_invariants
        ; QCheck_alcotest.to_alcotest prop_engine_matches_analytic
        ; QCheck_alcotest.to_alcotest prop_engine_matches_analytic_durations
        ] )
    ]
;;
