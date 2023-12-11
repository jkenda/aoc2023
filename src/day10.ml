open Format

(* exception raised when input is not a pipe *)
exception Not_a_pipe of char

let up = (-1, 0)
and down = (1, 0)
and left = (0, -1)
and right = (0, 1)

(* which way to move in the pipe *)
let movement = function
    | '|' -> up, down
    | '-' -> left, right
    | 'L' -> up, right
    | 'J' -> up, left
    | '7' -> left, down
    | 'F' -> right, down
    | c   -> raise @@ Not_a_pipe c

let () =
    let tiles =
        let rec aux acc =
            match input_line stdin with
            | exception End_of_file ->
                    Array.of_list @@ List.rev acc
            | line ->
                    aux @@
                    (Array.of_seq @@ String.to_seq line) :: acc
        in
        aux []
    in

    (* position of the S tile *)
    let (start_y, start_x) as start =
        Array.fold_left
        (fun (y, acc) line ->
            y + 1,
            snd @@ Array.fold_left
                (fun (x, acc) c ->
                    x + 1,
                    if acc <> None then acc
                    else if c = 'S' then Some (y, x)
                    else None)
                (0, acc) line)
        (0, None) tiles
        |> snd
        |> Option.get
    in

    (* get neighboring pipes' locations *)
    let neigh ((y, x) as loc) =
        let add (dy, dx) (y, x) = (y + dy, x + dx) in
        let n1, n2 = movement tiles.(y).(x) in
        add n1 loc, add n2 loc
    in
    (* next pipe segment *)
    let next prev curr =
        let n1, n2 = neigh curr in
        if n1 <> prev && tiles.(fst n1).(snd n1) <> 'S' then n1
        else n2
    in
    (* find farthest distance by going in 2 different ends until they connect *)
    let rec farthest dist (prev1, prev2) (loc1, loc2) =
        if loc1 = loc2 || prev1 = loc2 || prev2 = loc1 then dist
        else farthest (dist + 1) (loc1, loc2) (next prev1 loc1, next prev2 loc2)
    in

    (* which pipes connect to the current pipe *)
    let connecting_to_start =
        let pipes = ref [] in
        for i = -1 to 1 do
            for j = -1 to 1 do
                if i = 0 && j = 0 then ()
                else
                    try
                        let this = start_y + i, start_x + j in
                        let (n1, n2) = neigh this in
                        if n1 = start || n2 = start then
                            pipes := this :: !pipes
                    with _ -> ()
            done
        done;
        match !pipes with
        | [fst; snd] -> fst, snd
        | _ -> raise @@ Failure (sprintf "Bad input: %d %d" start_y start_x)
    in

    print_endline @@
    string_of_int @@
    farthest 1 (start, start) connecting_to_start
