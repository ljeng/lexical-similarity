open Str
open List

let kahn graph n =
  let inverse = Array.make n [] in
  for u = 0 to n - 1 do
    List.iter (fun v -> inverse.(v) <- u :: inverse.(v)) graph.(u);
  done;
  let stack = ref [] in
  for v = 0 to n - 1 do
    if inverse.(v) = [] then stack := v :: !stack;
  done;
  let order = ref [] in
  while !stack <> [] do
    let u = List.hd !stack in
    stack := List.tl !stack;
    order := u :: !order;
    List.iter (fun v ->
      inverse.(v) <- List.filter (fun x -> x <> u) inverse.(v);
      if inverse.(v) = [] then stack := v :: !stack
    ) graph.(u);
  done;
  if length !order <> n then
    "Cyclic graph"
  else
    rev !order

let () =
  let input_file = open_in "input.txt" in
  let output_file = open_out "output.txt" in
  let t = int_of_string (input_line input_file) in
  for _ = 1 to t do
    let n = int_of_string (input_line input_file) in
    let graph = Array.make n [] in
    try
      while true do
        let line = input_line input_file in
        let a, b = Scanf.sscanf line "%d %d" (fun a b -> a, b) in
        graph.(a) <- b :: graph.(a)
      done
    with End_of_file ->
      let result = kahn graph n in
      match result with
      | "Cyclic graph" -> Printf.fprintf output_file "Cyclic graph\n"
      | order -> Printf.fprintf output_file "%s\n" (String.concat " " (List.map string_of_int order))
  done;
  close_in input_file;
  close_out output_file