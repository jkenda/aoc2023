open Day15common

let () =
    read_whole_channel stdin
    |> String.split_on_char ','
    |> List.map hash
    |> List.fold_left (+) 0
    |> Format.printf "%d\n"
