open Format

let () =
    let network = Hashtbl.create 10 in

    let rec parse_network () =
        match input_line stdin with
        | exception End_of_file -> ()
        | line ->
                let src, dst =
                    let split =
                        String.split_on_char '=' line
                        |> List.map String.trim
                    in
                    match split with
                    | [src; dst] -> src, dst
                    | _ -> raise @@ Failure line
                in
                let dst =
                    let split =
                        String.sub dst 1 (String.length dst - 2)
                        |> String.split_on_char ','
                        |> List.map String.trim
                    in
                    match split with
                    | [l; r] -> l, r
                    | _ -> raise @@ Failure dst
                in
                Hashtbl.add network src dst;
                parse_network ()

    and next_node (sum, node) c =
        if node = "ZZZ" then
            sum, node
        else
            let next =
                Hashtbl.find network node
                |> if c = 'L' then fst else snd
            in
            sum + 1, next
    in

    let steps =
        input_line stdin
        |> String.trim
    in
    ignore @@ input_line stdin;
    parse_network ();

    let steps src dst =
        let rec aux' sum_node =
            let (sum, node) as sum_node = String.fold_left next_node sum_node steps in
            if node = dst then sum
            else aux' sum_node
        in
        aux' (0, src)
    in

    steps "AAA" "ZZZ"
    |> string_of_int
    |> print_endline
