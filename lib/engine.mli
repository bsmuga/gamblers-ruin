(** Numerical engine.

    Solves the absorbing Markov chain by reducing first-step analysis to a
    tridiagonal linear system and solving it with the Thomas algorithm. The
    system is diagonally dominant, so this is numerically stable and avoids the
    [(q/p)^N] overflow of the naive closed form. Works for any {!Walk.t},
    including state-dependent win probabilities.

    Each function returns the answer for {e every} start state in one solve. *)

(** [ruin_probabilities w] returns [h], where [h.(i)] is the probability of
    being absorbed at [0] before [w.target] starting from state [i], for every
    [i] in [0 .. w.target]. *)
val ruin_probabilities : Walk.t -> floatarray

(** [expected_durations w] returns [k], where [k.(i)] is the expected number of
    rounds until absorption starting from state [i], for every [i] in
    [0 .. w.target]. *)
val expected_durations : Walk.t -> floatarray
