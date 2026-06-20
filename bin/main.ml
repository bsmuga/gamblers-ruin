module G = Gamblers_ruin

(* Render a trajectory as a sparkline scaled to [0, n] using block glyphs. *)
let render_trajectory traj n =
  let blocks =
    [| " "
     ; "\xe2\x96\x81"
     ; "\xe2\x96\x82"
     ; "\xe2\x96\x83"
     ; "\xe2\x96\x84"
     ; "\xe2\x96\x85"
     ; "\xe2\x96\x86"
     ; "\xe2\x96\x87"
     ; "\xe2\x96\x88"
    |]
  in
  let top = Array.length blocks - 1 in
  let buf = Buffer.create (Array.length traj) in
  Array.iter
    (fun pos ->
      let idx =
        int_of_float
          (Float.round (float_of_int pos /. float_of_int n *. float_of_int top))
      in
      Buffer.add_string buf blocks.(idx))
    traj;
  print_endline (Buffer.contents buf)
;;

let () =
  let target = ref 0 in
  let start = ref 0 in
  let p = ref 0.5 in
  let simulate = ref false in
  let seed = ref 0 in
  let specs =
    [ "--target", Arg.Set_int target, "N  upper absorbing barrier"
    ; "--start", Arg.Set_int start, "I  initial fortune"
    ; "--p", Arg.Set_float p, "P  win probability per round"
    ; "--simulate", Arg.Set simulate, "   render one simulated trajectory"
    ; "--seed", Arg.Set_int seed, "S  PRNG seed for --simulate"
    ]
  in
  let usage = "gamblers-ruin --target N --start I --p P [--simulate --seed S]" in
  Arg.parse specs (fun _ -> ()) usage;
  if !target < 2
  then (
    prerr_endline usage;
    exit 1);
  let w = G.Walk.constant ~target:!target ~p:!p in
  let h = G.Engine.ruin_probabilities w in
  let k = G.Engine.expected_durations w in
  Printf.printf
    "ruin probability   %.6f (engine)  %.6f (analytic)\n"
    (Float.Array.get h !start)
    (G.Analytic.ruin_probability w ~start:!start);
  Printf.printf "expected duration  %.4f rounds\n" (Float.Array.get k !start);
  if !simulate
  then (
    let traj = G.Simulate.trajectory w ~start:!start ~seed:!seed in
    render_trajectory traj !target;
    let outcome =
      if traj.(Array.length traj - 1) <= 0 then "ruin" else "reached target"
    in
    Printf.printf "outcome: %s in %d rounds\n" outcome (Array.length traj - 1))
;;
