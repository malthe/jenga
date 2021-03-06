open Core.Std

(* jenga -- Swahili 'to build' *)

let main ?(argv=Array.to_list Sys.argv) ~run () =

  let toplevel_group =
    [ "build"         , Cmd_build.command ~toplevel:false ~run ()
    ; "cat-api"       , Cmd_cat_api.command
    ; "db"            , Cmd_db.command
    ; "diagnostics"   , Cmd_diagnostics.command
    ; "env"           , Cmd_env.command
    ; "monitor"       , Cmd_monitor.command
    ; "stop"          , Cmd_stop.command
    ; "errors"        , Cmd_watch.watch_errors
    ]
  in

  let toplevel_group_names =
    "help" :: "version" :: List.map toplevel_group ~f:fst
  in

  match argv with
  | _ :: s :: _ when List.mem toplevel_group_names s ->
    Command.run (Command.group ~summary:"Generic build system" toplevel_group)
      ~argv
  | _ ->
    (* When completing the first argument we would like to ask for the completion of
       both the group names and the flags/arguments of the command below. Unfortunately,
       Command wants to exit instead of returning even when completing. So we create the
       completion ourselves, which is easy enough, even though it's a bit ugly. *)
    begin match argv with
    | _ :: s :: _ when Sys.getenv "COMP_CWORD" = Some "1" ->
      List.iter toplevel_group_names ~f:(fun group_name ->
        if String.is_prefix ~prefix:s group_name then print_endline group_name)
    | _ -> ()
    end;
    Command.run (Cmd_build.command ~toplevel:true ~run ()) ~argv
;;
