let bad_usage msg = failwith ("bad_usage: "^msg)

let remove_o =
  let fn = ref "objmerged.obj" in
  let rec loop acc = function
    | [] -> List.rev acc
    | ["-o"] -> bad_usage "specify a file name with the '-o' option"
    | "-o"::name::tl -> fn:=name; loop acc tl
    | h::tl -> loop (h::acc) tl
  in
  fun l -> !fn,(loop [] l)

let shift oc l s =
  Scanf.sscanf l "f %i %i %i"
    (fun a b c -> Format.fprintf oc "f %i %i %i\n" (a+s) (b+s) (c+s))

let copy fmt fn s =
  let in_c = open_in fn in
  let rec loop acc =
    match input_line in_c with
    | l ->
       if String.length l > 0 then
         (match l.[0] with
          | 'v' -> Format.fprintf fmt "%s\n" l; loop (acc+1)
          | 'f' -> shift fmt l s; loop acc
          | _ -> Format.fprintf fmt "%s\n" l; loop acc)
       else loop acc
    | exception End_of_file ->
       Format.printf  "end of file%s\n%!" fn;
       Format.fprintf fmt "#end of file%s\n%!" fn; acc
  in
  loop 0

let process files fmt =
  List.fold_left (fun shift fn ->
      let s = copy fmt fn shift in
      shift + s
    ) 0 files

let main =
  let args = Sys.argv |> Array.to_list |> List.tl in
  let output,files = remove_o args in
  if List.length files >= 2 then begin
    Format.printf "Merging %a into %s\n%!"
      (Format.pp_print_list
         ~pp_sep:(fun fmt () -> Format.fprintf fmt ", ")
         (fun fmt -> Format.fprintf fmt "%s")) files output;
    let oc = open_out output in
    let fmt_oc = Format.formatter_of_out_channel oc in
    process files fmt_oc
    end
  else
    bad_usage "objmerger file1 file2 ... fileN"
