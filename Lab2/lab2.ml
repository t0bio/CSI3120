(* CSI3120 lab 2
Written by:
Oluwatobilba Ogunbi 300202843
Tara Denaud 
Sanika  *)

type job = {start_time: int; duration: int; priority: int}

(*hours and minutes to minutes from midnight*)
let time_to_minutes hours minutes = hours * 60 + minutes

(*helper*)
let read_int n = 
  Printf.printf "%s" n;
  read_int ()

let read_jobs n =
  let rec read_jobs' n acc = 
    if n = 0 then acc
    else
      let hours = read_int "Start Time (hours): " in
      let minutes = read_int "Start Time (minutes): " in
      let duration = read_int "Duration (minutes): " in
      let priority = read_int "Priority: " in
      let start_time = time_to_minutes hours minutes in
      let job = {start_time; duration; priority} in
      read_jobs' (n-1) (job::acc)
    in
  read_jobs' n []

