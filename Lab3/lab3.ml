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

let get_location () =
  let name = read_string "Enter location name: " in
  let x = read_float "Enter X coordinate: " in
  let y = read_float "Enter Y coordinate: " in
  let priority = read_int "Enter priority: " in
  {name; x; y; priority}

(* reading multiple locations from user *)
let rec get_locations acc =
  let location = get_location () in
  let acc = location :: acc in
  match read_string "Add another location? (y/n): " with
  | "y" | "Y" -> get_locations acc
  | _ -> acc

(* reading vehicle details from user *)
let get_vehicle id =
  let capacity = read_int (Printf.sprintf "Enter capacity for vehicle %d: " id) in
  {id; capacity; assigned_locations = []}

let rec get_vehicles acc id =
  let vehicle = get_vehicle id in
  let acc = vehicle :: acc in
  match read_string "Add another vehicle? (y/n): " with
  | "y" | "Y" -> get_vehicles acc (id + 1)
  | _ -> acc

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
  let rec assign remaining_locations = function
    | [] -> ()
    | vehicle :: rest ->
        let capacity = vehicle.capacity - List.length vehicle.assigned_locations in
        let (assigned, remaining) = 
          List.partition 
            (fun _ -> List.length vehicle.assigned_locations < vehicle.capacity) 
            (List.filteri (fun i _ -> i < capacity) remaining_locations) 
        in
        vehicle.assigned_locations <- vehicle.assigned_locations @ assigned;
        if remaining = [] then ()
        else assign remaining (rest @ [vehicle])
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
    Printf.printf "\nVehicle %d Route:\n" id;
    List.iter (fun loc -> Printf.printf "  %s (Priority: %d)\n" loc.name loc.priority) route;
    Printf.printf "Total Distance: %.2f\n" distance
  ) optimized_routes

  let main () =
    Printf.printf "Welcome to the Route Optimizer folks :D\n\n";
    
    (* gettin locations deets from user *)
    Printf.printf "Enter the number of delivery locations:\n";
    let locations = get_locations [] in
    
    (* gettin vehicle details from user *)
    Printf.printf "\nEnter vehicle details:\n";
    let vehicles = get_vehicles [] 1 in
    
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