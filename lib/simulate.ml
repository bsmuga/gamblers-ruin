(* [+1] with probability [win pos], else [-1]. *)
let step (w : Walk.t) state pos =
  if Random.State.float state 1.0 < w.Walk.win pos then pos + 1 else pos - 1
;;

let trajectory (w : Walk.t) ~start ~seed =
  let n = w.Walk.target in
  let state = Random.State.make [| seed |] in
  let rec walk pos acc =
    let acc = pos :: acc in
    if pos <= 0 || pos >= n then List.rev acc else walk (step w state pos) acc
  in
  Array.of_list (walk start [])
;;

let monte_carlo (w : Walk.t) ~start ~trials ~seed =
  let n = w.Walk.target in
  let state = Random.State.make [| seed |] in
  let ruined = ref 0 in
  let total_steps = ref 0 in
  for _ = 1 to trials do
    let pos = ref start in
    let steps = ref 0 in
    while !pos > 0 && !pos < n do
      pos := step w state !pos;
      incr steps
    done;
    total_steps := !total_steps + !steps;
    if !pos <= 0 then incr ruined
  done;
  let trials_f = float_of_int trials in
  float_of_int !ruined /. trials_f, float_of_int !total_steps /. trials_f
;;
