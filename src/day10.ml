open Format

let up = (-1, 0)
and down = (1, 0)
and left = (0, -1)
and right = (0, 1)

let movement = function
    | '|' -> up, down
    | '-' -> left, right
    | 'L' -> up, right
    | 'J' -> up, left
    | '7' -> left, down
    | 'F' -> right, down
    | c   -> raise @@ Failure (sprintf "%c is not a pipe" c)

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

    let start =
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

    let neigh ((y, x) as loc) =
        let add (dy, dx) (y, x) = (y + dy, x + dx) in
        let n1, n2 = movement tiles.(y).(x) in
        add n1 loc, add n2 loc
    in
    let connecting_to ((y, x) as from) =
        let pipes = ref [] in
        for i = -1 to 1 do
            for j = -1 to 1 do
                if i = 0 && j = 0 then ()
                else
                    try
                        let this = y + i, x + j in
                        let (n1, n2) = neigh this in
                        if n1 = from || n2 = from then
                            pipes := this :: !pipes
                    with _ -> ()
            done
        done;
        match !pipes with
        | [fst; snd] -> fst, snd
        | _ -> raise @@ Failure (sprintf "Bad input: %d %d" y x)
    in
    let next prev curr =
        let n1, n2 = neigh curr in
        if n1 <> prev && tiles.(fst n1).(snd n1) <> 'S' then n1
        else n2
    in
    let rec farthest dist (prev1, prev2) (loc1, loc2) =
        if loc1 = loc2 || prev1 = loc2 || prev2 = loc1 then dist
        else farthest (dist + 1) (loc1, loc2) (next prev1 loc1, next prev2 loc2)
    in

    print_endline @@
    string_of_int @@
    farthest 1 (start, start) (connecting_to start)
