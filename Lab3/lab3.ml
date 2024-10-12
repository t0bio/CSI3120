(* CSI3120 lab 3 
Written by:
Oluwatobilba Ogunbi 300202843
Tara Denaud 300318926 
Sanika Sisodia 300283847 *)

(*location type*)
type location = {
  name : string;
  x: float;
  y: float;
  priority: int;
}

(*vehicle type*)
type vehicle = {
  id: int;
  capacity: int;
  mutable assigned_locations: location list;
}

(* user input helpers *)
let read_float prompt =
  print_string prompt;
  read_float ()

let read_int prompt =
  print_string prompt;
  read_int ()

let read_string prompt =
  print_string prompt;
  read_line ()

let get_location index =
  Printf.printf "Enter details for location %d\n" index;
  let name = read_string "Enter location name: " in
  let x = read_float "Enter X coordinate: " in
  let y = read_float "Enter Y coordinate: " in
  let priority = read_int "Priority: " in
  {name; x; y; priority}

(* reading multiple locations from user *)
let rec get_locations acc count index =
  if count = 0 then acc
  else begin
    let location = get_location index in
    get_locations (location :: acc) (count - 1) (index + 1)
  end

(* reading vehicle details from user *)
let get_vehicle id =
  let capacity = read_int (Printf.sprintf "Vehicle capacity %d: " id) in
  {id; capacity; assigned_locations = []}

let rec get_vehicles acc id count =
  if count = 0 then acc
  else
    let vehicle = get_vehicle id in
    get_vehicles (vehicle :: acc) (id + 1) (count - 1)

(* distance between two locations *)
let distance l1 l2 =
  sqrt ((l1.x -. l2.x) ** 2.0 +. (l1.y -. l2.y) ** 2.0)

(* sort locations by priority *)
let sort_by_priority locations =
  List.sort (fun l1 l2 -> compare l2.priority l1.priority) locations

(* distance of a route *)
let route_distance locations =
  let rec aux acc = function
    | [] | [_] -> acc
    | l1 :: (l2 :: _ as rest) -> aux (acc +. distance l1 l2) rest
  in aux 0.0 locations

(* assigning locations to vehicles *)
let assign_locations vehicles locations =
  let sorted_locations = sort_by_priority locations in
  let rec assign remaining_locations vehicles =
    match remaining_locations, vehicles with
    | [], _ -> () 
    | _, [] -> () 
    | loc :: remaining_locs, vehicle :: rest ->
        if List.length vehicle.assigned_locations < vehicle.capacity then begin
          vehicle.assigned_locations <- vehicle.assigned_locations @ [loc];
          assign remaining_locs (vehicle :: rest) 
        end else
          assign remaining_locs rest 
  in
  assign sorted_locations vehicles

(*optimizing routes*)
let optimize_route vehicle return_to_start =
  let route = sort_by_priority vehicle.assigned_locations in
  let total_distance = route_distance route in
  let total_distance = 
    if return_to_start && List.length route > 0 then
      total_distance +. distance (List.hd route) (List.hd (List.rev route))
    else
      total_distance
  in
  (route, total_distance)

(* optimize routes for all vehicles *)
let optimize_all_routes vehicles return_to_start =
  List.map (fun v -> (v.id, optimize_route v return_to_start)) vehicles

(*show routes*)
let display_routes optimized_routes =
  List.iter (fun (id, (route, distance)) ->
    Printf.printf "\nVehicle %d route: " id;
    List.iteri (fun i loc -> 
      if i = List.length route - 1 then Printf.printf "%s" loc.name
      else Printf.printf "%s -> " loc.name
    ) route;
    
    Printf.printf "\n";
    Printf.printf "Total distance: %.2f km\n" distance
  ) optimized_routes

  let main () =
    Printf.printf "Welcome to the Route Optimizer folks :D\n\n";
    
    (* gettin locations deets from user *)
    Printf.printf "Enter the number of delivery locations: ";
    let num_locations = read_int "" in
    let locations = get_locations [] num_locations 1 in
    Printf.printf "\n";
    
    (* gettin vehicle details from user *)
    Printf.printf "Enter the number of vehicles: ";
    let num_vehicles = read_int "" in
    let vehicles = get_vehicles [] 1 num_vehicles in
    
    (* check if vehicles shoudl return to start*)
    let return_to_start = match read_string "\nShould vehicles return to the starting location? (y/n): " with
      | "y" | "Y" -> true
      | _ -> false
    in
    
    (* assign locations to vehicles *)
    assign_locations vehicles locations;
    
    (*optimizing*)
    let optimized_routes = optimize_all_routes vehicles return_to_start in
    
    (*displaying results**)
    Printf.printf "\nOptimized Routes:\n";
    display_routes optimized_routes
  
  let () = main ()