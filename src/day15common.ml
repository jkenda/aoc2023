let read_whole_channel ch =
    really_input_string ch (in_channel_length ch)

let hash =
    let aux acc c =
        (* Ignore newline characters *) 
        if c = '\n' then acc
        else
            (* Determine the ASCII code for the current character of the string. *)
            let ascii = int_of_char c in
            (* Increase the current value by the ASCII code you just determined. *)
            let acc = acc + ascii in
            (* Set the current value to itself multiplied by 17. *)
            let acc = acc * 17 in
            (* Set the current value to the remainder of dividing itself by 256. *)
            acc mod 256
    in
    String.fold_left aux 0

