(* The closed forms are only valid for a constant win probability, so we first
   confirm [win] is constant across the interior states and recover [p]. *)
let constant_p (w : Walk.t) =
  let { Walk.target = n; win } = w in
  let p0 = win 1 in
  for i = 2 to n - 1 do
    if not (Float.equal (win i) p0)
    then invalid_arg "Analytic: walk does not have a constant win probability"
  done;
  p0
;;

let ruin_probability w ~start =
  let p = constant_p w in
  let n = w.Walk.target in
  if start <= 0
  then 1.0
  else if start >= n
  then 0.0
  else (
    let q = 1.0 -. p in
    if Float.equal p q
    then float_of_int (n - start) /. float_of_int n
    else (
      let r = q /. p in
      let rn = r ** float_of_int n in
      let ri = r ** float_of_int start in
      (rn -. ri) /. (rn -. 1.0)))
;;

let expected_duration w ~start =
  let p = constant_p w in
  let n = w.Walk.target in
  if start <= 0 || start >= n
  then 0.0
  else (
    let q = 1.0 -. p in
    let i = float_of_int start in
    let nn = float_of_int n in
    if Float.equal p q
    then i *. (nn -. i)
    else (
      let r = q /. p in
      let ri = r ** i in
      let rn = r ** nn in
      (i /. (q -. p)) -. (nn /. (q -. p) *. ((1.0 -. ri) /. (1.0 -. rn)))))
;;
