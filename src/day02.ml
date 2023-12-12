open Format
open Day02common

let possible (r, g, b) =
    r <= 12 && g <= 13 && b <= 14

let () =
    let rec aux acc =
        match input_line stdin with
        | exception End_of_file -> acc
        | line ->
                match String.split_on_char ':' line with
                | [n; info] ->
                        let possible =
                            parse_game info
                            |> List.for_all possible
                        in
                        let id =
                            match String.split_on_char ' ' n with
                            | [_; id] -> int_of_string id
                            | _ -> raise @@ Failure (sprintf "Invalid input: '%s'" line)
                        in
                        aux @@ if possible then acc + id else acc

                | _ -> raise @@ Failure (sprintf "Invalid input: '%s'" line)
    in
    string_of_int (aux 0)
    |> print_endline
