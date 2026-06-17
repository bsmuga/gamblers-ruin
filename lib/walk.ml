type t =
  { target : int
  ; win : int -> float
  }

let create ~target ~win =
  if target < 2 then invalid_arg "Walk.create: target must be >= 2";
  { target; win }
;;

let constant ~target ~p =
  if not (0. <= p && p <= 1.) then invalid_arg "Walk.constant: p must be in [0, 1]";
  create ~target ~win:(fun _ -> p)
;;
