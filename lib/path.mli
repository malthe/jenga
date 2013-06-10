
open Core.Std

type t with sexp, bin_io
include Hashable_binable with type t := t

(* check starts with a / - wont be exposed to user*)
val create_from_absolute : string -> t option

val relative : dir:t -> string -> t
val suffix : t -> string -> t
val equal : t -> t -> bool
val split : t -> t * string
val dirname : t -> t
val basename : t -> string
val compare : t -> t -> int

val to_absolute_string : t -> string
val to_rrr_string : t -> string (* "repo-root-relative" string *)

val the_root : t
val root_relative : string -> t

(* [dotdot ~dir path]
   compute relative ".."-based-path-string to reach [path] from [dir]
*)
val dotdot : dir:t -> t -> string

val db_basename : string
val sexp_db_basename : string
val log_basename : string
val dot_basename : string
val lock_basename : string
val server_basename : string

val is_special_jenga_path : t -> bool

type path = t
module LR : sig
  type t with sexp
  val local : path -> t
  val remote : string -> t
  val case : t -> [`local of path | `remote of string]
  val to_absolute_string : t -> string
  val to_rrr_string : t -> string (* rrr if possible *)
  val basename : t -> string
  val dirname : t -> t
end
