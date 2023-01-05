(*
    Compile:
        ocamlc -o main main.ml
    Use:
        ./main < input.txt
    Compiler version:
        ocamlc --version
        4.14.0
*)

(* See: https://stackoverflow.com/a/52392884 *)
module CharSet = Set.Make(Char);;

let lines = ref [];;

let rec sum l =
    match l with
    | [] -> 0
    | head::tail -> head + sum (tail);;

let charset_of_list li = List.fold_right CharSet.add li CharSet.empty;;

let explode s = List.init (String.length s) (String.get s);;

let add_nonempty_line line =
    lines := match line with
        | "" -> !lines
        | _ -> line :: !lines
    in

let read_lines () =
  try
    while true do
      add_nonempty_line (input_line stdin)
    done
  with End_of_file -> ()
    in
read_lines ();

let split_compartments rucksack =
    let half = (String.length rucksack) / 2 in

    let first = String.sub rucksack 0 half in
    let second = String.sub rucksack half half in
    let first_set = charset_of_list (explode first) in
    let second_set = charset_of_list (explode second) in
    (first_set, second_set)
    in

let intersect elements =
    let (first, second) = elements in
    (CharSet.inter first second)
    in

let get_char_value c =
    if (Char.lowercase_ascii c) == c then
        (Char.code c) - (Char.code 'a') + 1
    else
        (Char.code c) - (Char.code 'A') + 1 + 26
    in

let part1_solution =
    let compartments = List.map split_compartments !lines in
    let intersections = List.map intersect compartments in
    let common_items = List.map CharSet.choose intersections in
    sum (List.map get_char_value common_items)
    in
print_endline (Printf.sprintf "Sum of priorities of same items in multiple compartment; Part 1: %d" part1_solution);

let rec chunk_list l =
    match l with
    | [] -> []
    | a::[] -> []
    | a::b::[] -> []
    | a::b::c::tail -> (a, b, c) :: (chunk_list (tail))
    in

let part2_solution =
    let get_badge_from_chunk (first, second, third) =
        let (first, second, third) = (
            charset_of_list (explode first),
            charset_of_list (explode second),
            charset_of_list (explode third)
        ) in
        let item_intersections = CharSet.inter (CharSet.inter first second) third in
        let common_item = CharSet.choose item_intersections in
        get_char_value common_item
    in
    let grouped_elves = chunk_list !lines in
    sum (List.map get_badge_from_chunk grouped_elves)
    in

print_endline (Printf.sprintf "Sum of badge priorities in elf groups; Part 2: %d" part2_solution);
