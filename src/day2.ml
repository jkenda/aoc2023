open Format

let () =
    let add_color (r, g, b) l =
        match l with
        | [n; "red"]   -> r + int_of_string n, g, b
        | [n; "green"] -> r, g + int_of_string n, b
        | [n; "blue"]  -> r, g, b + int_of_string n
        | [n; c] -> raise @@ Failure (sprintf "Invalid input: '%s' '%s'" n c)
        | _ -> raise @@ Failure "Invalid input"
    in
    let parse_set set =
        String.split_on_char ',' set
        |> List.map String.trim
        |> List.map (String.split_on_char ' ')
        |> List.fold_left add_color (0, 0, 0)
    in
    let parse_game input =
        String.split_on_char ';' input
        |> List.map String.trim
        |> List.map parse_set
    and possible (r, g, b) =
        r <= 12 && g <= 13 && b <= 14
    in

    let rec aux acc =
        match input_line stdin with
        | exception End_of_file -> acc
        | line ->
                match String.split_on_char ':' line with
                | [n; info] ->
                        let possible =
                            List.for_all possible
                            @@ parse_game info
                        in
                        let id =
                            match String.split_on_char ' ' n with
                            | [_; id] -> int_of_string id
                            | _ -> raise @@ Failure (sprintf "Invalid input: '%s'" line)
                        in
                        aux @@ if possible then acc + id else acc

                | _ -> raise @@ Failure (sprintf "Invalid input: '%s'" line)
    in
    print_endline @@ string_of_int (aux 0)

