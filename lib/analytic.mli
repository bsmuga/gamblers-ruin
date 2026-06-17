(** Closed-form formulas for the classic process with a constant win
    probability [p] (and [q = 1 - p]).

    With [r = q / p] and target [N]:
    - ruin probability from [i]:
      [(r^N - r^i) / (r^N - 1)] when [p <> q], else [(N - i) / N];
    - expected duration from [i]:
      [i / (q - p) - N / (q - p) * (1 - r^i) / (1 - r^N)] when [p <> q],
      else [i * (N - i)].

    These serve as the analytic oracle that the {!Engine} and {!Simulate}
    routes are checked against, over the range where [r^N] is numerically safe. *)

(** Probability of reaching [0] before [target] from [start].

    @raise Invalid_argument if [w] does not have a constant win probability. *)
val ruin_probability : Walk.t -> start:int -> float

(** Expected number of rounds until absorption from [start].

    @raise Invalid_argument if [w] does not have a constant win probability. *)
val expected_duration : Walk.t -> start:int -> float
