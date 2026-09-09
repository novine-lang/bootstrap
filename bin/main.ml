open Cmdliner
open Bootstrap

let validate_filename filename =
  let ext = Filename.extension filename in
  if ext = ".nv" then filename
  else failwith (Printf.sprintf
                   "File '%s' has invalid extension '%s'. Expected '.nv'."
                   filename ext)
let stage =
  let lex =
    let doc = "Stop after Lexing" in
    (Settings.Lex, Arg.info ["lex"] ~doc)
  in
  let parse =
    let doc = "Stop after Parsing" in
    (Settings.Parse, Arg.info ["parse"] ~doc)
  in
  let check =
    let doc = "Stop after Semantics" in
    (Settings.Check, Arg.info ["check"] ~doc)
  in
  let mir =
    let doc = "Stop after IR" in
    (Settings.MIR, Arg.info ["mir"] ~doc)
  in
  let exec =
    let doc = "Compile" in
    (Settings.Exec, Arg.info ["exec"] ~doc)
  in
  Arg.(
    value
    & vflag Settings.Inter
      [lex; parse; check; mir; exec]
  )

let src_file =
  let doc = "The path to Novine (.nv) file" in
  Arg.(required & pos 0 (some non_dir_file) None & info [] ~docv:"files" ~doc)

let driver stage filename =
  let ctx : Settings.context = {
    settings = Settings.default_settings;
    stage;
  } in
  let filename = validate_filename filename in
  Compile.compile ctx filename

let cmd =
  let doc = "The Novine Compiler" in
  let info = Cmd.info "novine" ~version:"A-1" ~doc in
  Cmd.v info Term.(
      const driver
      $ stage
      $ src_file
    )

let main () = exit (Cmd.eval cmd)
let () = main ()
