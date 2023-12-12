open Format

let add_color (r, g, b) l =
    match l with
    | [n; "red"]   -> r + int_of_string n, g, b
    | [n; "green"] -> r, g + int_of_string n, b
    | [n; "blue"]  -> r, g, b + int_of_string n
    | [n; c] -> raise @@ Failure (sprintf "Invalid input: '%s' '%s'" n c)
    | _ -> raise @@ Failure "Invalid input"

let parse_set set =
    String.split_on_char ',' set
    |> List.map String.trim
    |> List.map (String.split_on_char ' ')
    |> List.fold_left add_color (0, 0, 0)

let parse_game input =
    String.split_on_char ';' input
    |> List.map String.trim
    |> List.map parse_set
