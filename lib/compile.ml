let compile ctx src_file =
  let source = In_channel.with_open_text src_file In_channel.input_all in
  source |> ignore
