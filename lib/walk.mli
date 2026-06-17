(** The model: a gambler's-ruin process on the integer states
    [{0, 1, ..., target}].

    States [0] and [target] are absorbing. For an interior state
    [0 < i < target], [win i] is the probability of moving from [i] to [i + 1]
    (winning one round); the gambler moves to [i - 1] otherwise. A constant
    [win] is the classic problem; a general [win] is a birth–death chain. *)
type t =
  { target : int (** upper absorbing barrier, [target >= 2] *)
  ; win : int -> float (** [win i] in [0, 1]: probability of a [+1] step at [i] *)
  }

(** [create ~target ~win] is the general birth–death process.

    @raise Invalid_argument if [target < 2]. *)
val create : target:int -> win:(int -> float) -> t

(** [constant ~target ~p] is the classic process with a fixed win probability
    [p] at every interior state.

    @raise Invalid_argument if [target < 2] or [p] is outside [0, 1]. *)
val constant : target:int -> p:float -> t
