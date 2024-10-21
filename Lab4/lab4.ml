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

(* check if valid*)
let is_valid grid row col num =
  let n = Array.length grid in
  let size = int_of_float (sqrt (float_of_int n)) in
  let subrow = row / size * size in
  let subcol = col / size * size in
  let rec check i = 
    if i >= n then true
    else if grid.(row).(i) = num || grid.(i).(col) = num || grid.(subrow + i / size).(subcol + i mod size) = num then false
    else check (i + 1)
  in check 0

(* verify grid*)
let verify grid = 
  let n = Array.length grid in
  let rec verify_row row col = 
    if row >= n then true
    else if col >= n then verify_row (row + 1) 0
    else if grid.(row).(col) = 0 then false
    else if is_valid grid row col grid.(row).(col) then verify_row row (col + 1)
    else false
  in verify_row 0 0

(*implementing backtrack algo*)
