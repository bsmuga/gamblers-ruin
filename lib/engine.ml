(* First-step analysis on states [0 .. n] gives, for interior [i],

     q_i x_{i-1} - x_i + p_i x_{i+1} = b

   with [p_i = win i], [q_i = 1 - p_i]. Ruin probabilities use [b = 0] with
   boundaries [h_0 = 1], [h_n = 0]; expected durations use [b = -1] with
   [k_0 = k_n = 0]. The matrix is the same (diagonally dominant), so one Thomas
   solve per right-hand side suffices. *)

let solve_tridiagonal ~sub ~diag ~sup ~rhs =
  let m = Array.length diag in
  let cp = Array.make m 0.0 in
  let dp = Array.make m 0.0 in
  let pivot d =
    if Float.abs d < 1e-12
    then invalid_arg "Engine: singular system (degenerate win probabilities)";
    d
  in
  let d0 = pivot diag.(0) in
  cp.(0) <- sup.(0) /. d0;
  dp.(0) <- rhs.(0) /. d0;
  for j = 1 to m - 1 do
    let denom = pivot (diag.(j) -. (sub.(j) *. cp.(j - 1))) in
    cp.(j) <- sup.(j) /. denom;
    dp.(j) <- (rhs.(j) -. (sub.(j) *. dp.(j - 1))) /. denom
  done;
  let x = Array.make m 0.0 in
  x.(m - 1) <- dp.(m - 1);
  for j = m - 2 downto 0 do
    x.(j) <- dp.(j) -. (cp.(j) *. x.(j + 1))
  done;
  x
;;

(* Solve the interior system for the shared matrix with a constant right-hand
   side [b] and absorbing values [lo] (at state 0) and [hi] (at state n). *)
let solve (w : Walk.t) ~b ~lo ~hi =
  let { Walk.target = n; win } = w in
  let m = n - 1 in
  let p = Array.init m (fun j -> win (j + 1)) in
  let q = Array.map (fun pi -> 1.0 -. pi) p in
  let sub = Array.copy q in
  let diag = Array.make m (-1.0) in
  let sup = Array.copy p in
  let rhs = Array.make m b in
  (* fold the known boundary values into the right-hand side *)
  rhs.(0) <- rhs.(0) -. (q.(0) *. lo);
  rhs.(m - 1) <- rhs.(m - 1) -. (p.(m - 1) *. hi);
  let interior = solve_tridiagonal ~sub ~diag ~sup ~rhs in
  let out = Float.Array.make (n + 1) 0.0 in
  Float.Array.set out 0 lo;
  Float.Array.set out n hi;
  for j = 0 to m - 1 do
    Float.Array.set out (j + 1) interior.(j)
  done;
  out
;;

let ruin_probabilities w = solve w ~b:0.0 ~lo:1.0 ~hi:0.0
let expected_durations w = solve w ~b:(-1.0) ~lo:0.0 ~hi:0.0
