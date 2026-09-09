type stage =
  | Lex
  | Parse
  | Check
  | Inter
  | MIR
  | Exec

type mode =
  | Interpret
  | Compile

type settings = {
  mode : mode;
}

type context = {
  settings : settings;
  stage : stage;
}

let default_settings = {
  mode = Interpret;
}
