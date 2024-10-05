(* CSI3120 lab 2
Written by:
Oluwatobilba Ogunbi 300202843
Tara Denaud 300318926 
Sanika 300283847 *)

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

let schedule_jobs jobs = 
  let rec aux scheduled remaining =
    match remaining with
    | [] -> List.rev scheduled
    | job::rest ->
      let last_end_time = match scheduled with
        | [] -> 0
        | last_job::_ -> last_job.start_time + last_job.duration
      in
      if job.start_time >= last_end_time then
        aux (job::scheduled) rest
      else
        aux scheduled rest
  in
  aux [] (List.sort (fun j1 j2 -> j1.start_time - j2.start_time) jobs)

let schedule_jobs_max_priority jobs = 
  List.sort (fun j1 j2 -> if j1.priority = j2.priority then j1.start_time - j2.start_time else j2.priority - j1.priority) jobs

let schedule_jobs_min_idle jobs = 
  List.sort (fun j1 j2 -> if j1.start_time = j2.start_time then j1.duration - j2.duration else j1.start_time - j2.start_time) jobs

let print_job job = 
  Printf.printf "Start time: %d, Duration: %d, Priority: %d\n" job.start_time job.duration job.priority

let print_schedule jobs =
  List.iter print_job jobs

let main () = 
  let n = read_int "Enter the number of jobs: " in
  let jobs = read_jobs n in
  Printf.printf "Select scheduling strategy:\n1. No Overlap\n2. Max Priority\n3. Min Idle\n";
  let strategy = read_int "Enter choice (1/2/3): " in
  let scheduled_jobs = match strategy with
    | 1 -> schedule_jobs jobs
    | 2 -> schedule_jobs_max_priority jobs
    | 3 -> schedule_jobs_min_idle jobs
    | _ -> failwith "Invalid choice"
  in
  print_schedule scheduled_jobs

let () = main ()

