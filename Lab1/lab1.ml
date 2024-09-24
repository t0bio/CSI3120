(*Lab 1*)
(*All work done by:*) 
(*Oluwatobiloba Ogunbi 300202843*)
(*Tara Denaud*)
let rec map2 f l1 l2 = 
  match l1, l2 with
  | [], _ | _, [] -> []
  | h1::t1, h2::t2 -> (f h1 h2)::(map2 f t1 t2)

let filter_even l = 
  List.filter (fun x -> x mod 2 = 0) l

let compose_functions f g = 
  fun x -> f (g x)

let rec reduce f acc l = 
  match l with
  | [] -> acc
  | h::t -> reduce f (f acc h) t



