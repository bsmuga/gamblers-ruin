(** Seeded Monte-Carlo simulation.

    Pure: randomness enters only through [seed], so runs are reproducible, and no
    I/O is performed — rendering a trajectory belongs in [bin/]. *)

(** [trajectory w ~start ~seed] returns the sequence of fortunes visited, from
    [start] until absorption at [0] or [w.target] (inclusive). *)
val trajectory : Walk.t -> start:int -> seed:int -> int array

(** [monte_carlo w ~start ~trials ~seed] returns [(ruin_frequency, mean_steps)]
    estimated over [trials] independent runs. *)
val monte_carlo : Walk.t -> start:int -> trials:int -> seed:int -> float * float
