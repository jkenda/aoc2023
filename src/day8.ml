open Format
open Scanf

let () =
    let network = Hashtbl.create 1000 in

    let rec parse_network () =
        match input_line stdin with
        | exception End_of_file -> ()
        | line ->
                let src, dst =
                    sscanf line "%s = (%s@, %s@)" (fun src l r -> src, (l, r))
                in
                Hashtbl.add network src dst;
                parse_network ()

    and next (sum, node) c =
        let next' node =
            Hashtbl.find network node
            |> if c = 'L' then fst else snd
        in
        if node = "ZZZ" then
            sum, node
        else
            sum + 1, next' node
    in

    let steps =
        input_line stdin
        |> String.trim
    in
    ignore @@ input_line stdin;
    parse_network ();

    let steps src =
        let rec aux' (sum, node) =
            let (sum, node) = String.fold_left next (sum, node) steps in
            if node = "ZZZ" then sum
            else aux' (sum, node)
        in
        aux' (0, src)
    in

    steps "AAA"
    |> string_of_int
    |> print_endline
