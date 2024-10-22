(* Define the Sudoku grid *)
let grid = [|
  [| 1; 0; 0; 0 |];
  [| 0; 0; 3; 0 |];
  [| 0; 2; 0; 0 |];
  [| 0; 0; 0; 4 |]
|]

(* Check if placing num at grid[row][col] is valid *)
let is_valid grid row col num =
  let n = Array.length grid in
  let sqrt_n = int_of_float (sqrt (float_of_int n)) in
  let box_row_start = row - row mod sqrt_n in
  let box_col_start = col - col mod sqrt_n in
  let valid = ref true in

  (* Check row *)
  for j = 0 to n - 1 do
    if grid.(row).(j) = num && j <> col then
      valid := false
  done;

  (* Check column *)
  for i = 0 to n - 1 do
    if grid.(i).(col) = num && i <> row then
      valid := false
  done;

  (* Check subgrid *)
  for i = 0 to sqrt_n - 1 do
    for j = 0 to sqrt_n - 1 do
      if grid.(box_row_start + i).(box_col_start + j) = num &&
         (box_row_start + i <> row || box_col_start + j <> col) then
        valid := false
    done
  done;

  !valid

(* Verify if the initial grid is valid *)
let verify grid =
  let n = Array.length grid in
  let rec check_all_cells row col =
    if row = n then true
    else if col = n then check_all_cells (row + 1) 0
    else if grid.(row).(col) <> 0 && not (is_valid grid row col grid.(row).(col))
    then false
    else check_all_cells row (col + 1)
  in
  check_all_cells 0 0

(* Solve the Sudoku puzzle using backtracking *)
let rec solve_sudoku grid =
  let n = Array.length grid in
  let rec find_empty_cell i j =
    if i = n then None
    else if j = n then find_empty_cell (i + 1) 0
    else if grid.(i).(j) = 0 then Some (i, j)
    else find_empty_cell i (j + 1)
  in
  match find_empty_cell 0 0 with
  | None -> true
  | Some (row, col) ->
    let rec try_num num =
      if num > n then false
      else if is_valid grid row col num then
        (grid.(row).(col) <- num;
         if solve_sudoku grid then true
         else (grid.(row).(col) <- 0; try_num (num + 1)))
      else try_num (num + 1)
    in
    try_num 1

(* Main function to input the grid and solve it *)
let () =
  if verify grid then
    if solve_sudoku grid then
      Array.iter (fun row ->
        Array.iter (fun num -> Printf.printf "%d " num) row;
        print_newline ()
      ) grid
    else
      Printf.printf "No solution exists\n"
  else
    Printf.printf "Invalid initial grid\n"