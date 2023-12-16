open Day15common
open Format

let boxes = Array.make 256 []

let next_operation op =
    match String.split_on_char '=' op with
    | [label; focal_length] ->
            let hash = hash label in
            let box = boxes.(hash)
            and replace = function
                | (l, _) when l = label -> (label, int_of_string focal_length)
                | box -> box
            in
            boxes.(hash) <-
                (match List.find_opt (fun (l, _) -> l = label) box with
                | Some _ -> List.map replace box
                | None -> (label, int_of_string focal_length) :: box)
    | [_] ->
            (match String.split_on_char '-' op with
            | [label; ""] ->
                    let hash = hash label in
                    let box = boxes.(hash) in
                    boxes.(hash) <- List.filter (fun (l, _) -> l <> label) box
            | _ -> failwith ("Invalid input: " ^ op))
    | _ -> failwith ("Invalid input" ^ op)

let () =
    read_whole_channel stdin
    |> String.trim
    |> String.split_on_char ','
    |> List.iter next_operation;

    Array.iteri (fun i box -> boxes.(i) <- List.rev box) boxes;

    let sum =
        boxes
        |> Array.mapi (fun i box ->
            box
            |> List.mapi (fun slot (_, focal_length) ->
                    focal_length * (slot + 1))
            |> List.fold_left (+) 0
            |> (fun sum -> sum * (i + 1)))
        |> Array.fold_left (+) 0
    in
    printf "%d\n" sum
