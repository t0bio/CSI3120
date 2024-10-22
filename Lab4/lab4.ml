(* CSI3120 lab 4 
Written by:
Oluwatobilba Ogunbi 300202843
Tara Denaud 300318926 
Sanika Sisodia 300283847 *)

(*grid*)
let sudoku = [|
  [|1; 0; 0; 4|];
  [|0; 0; 3; 0|];
  [|3; 0; 0; 1|];
  [|0; 2; 0; 0|]
|]

let grid2 =[|
  [|0; 2; 0; 4|];
  [|0; 0; 1; 0|];
  [|0; 1; 0; 0|];
  [|4; 0; 0; 0|]
|]

(* check if grid is valid*)
  let is_valid grid row col num =
    let n = Array.length grid in
    let subgrid_size = int_of_float (sqrt (float_of_int n)) in
    let subgrid_row = row - row mod subgrid_size in
    let subgrid_col = col - col mod subgrid_size in
    let valid = ref true in
    (*checking the row*)
    for j = 0 to n - 1 do
      if grid.(row).(j) = num && j <> col then
        valid := false
    done;
    (*checking the column*)
    for i = 0 to n - 1 do
      if grid.(i).(col) = num && i <> row then
        valid := false
    done;
    (*checking the subgrid*)
    for i = 0 to subgrid_size - 1 do
      for j = 0 to subgrid_size - 1 do
        if grid.(subgrid_row + i).(subgrid_col + j) = num &&
           (subgrid_row + i <> row || subgrid_col + j <> col) then
          valid := false
      done
    done;
    !valid

(* verify grid*)
let verify grid = 
  let n = Array.length grid in
  let rec verify_row row col = 
    if row >= n then true
    else if col >= n then verify_row (row + 1) 0
    else if grid.(row).(col) <> 0 && not (is_valid grid row col grid.(row).(col)) then false
    else verify_row row (col + 1)
  in verify_row 0 0

(*implementing backtrack algo*)
let rec solve grid = 
  let n = Array.length grid in
  let rec find_empty i j = 
    if i = n then None
    else if j = n then find_empty (i + 1) 0
    else if grid.(i).(j) = 0 then Some (i, j)
    else find_empty i (j + 1) in
  match find_empty 0 0 with
  | None -> true
  | Some (row, col) ->
  (*trying numbers 1 to n*)
  let rec try_num num =  
    if num > n then false
    else if is_valid grid row col num then
      (grid.(row).(col) <- num;
      if solve grid then true
      else (
        grid.(row).(col) <- 0;
        try_num (num + 1)
      )
    ) else try_num (num + 1)
  in try_num 1

(*printing solved grid*)
let print_grid grid = 
  Array.iter (fun row -> Array.iter (Printf.printf "%d ") row;
  print_newline ()) grid

let main () =
  if not (verify grid2) then
    Printf.printf "Invalid initial grid\n"
  else if solve grid2 then
    print_grid grid2
  else
    Printf.printf "No solution exists\n"

let () = main ()