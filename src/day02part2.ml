open Format
open Day02common

let max' (r, g, b) (r', g', b') =
    (max r r', max g g', max b b')

let () =
    let rec aux acc =
        match input_line stdin with
        | exception End_of_file -> acc
        | line ->
                match String.split_on_char ':' line with
                | [n; info] ->
                        let power =
                            let (r, g, b) =
                                parse_game info
                                |> List.fold_left max' (0, 0, 0)
                            in
                            r * g * b
                        in
                        aux @@ acc + power

                | _ -> raise @@ Failure (sprintf "Invalid input: '%s'" line)
    in
    string_of_int (aux 0)
    |> print_endline
