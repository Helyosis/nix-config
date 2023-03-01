{ config, pkgs, lib, ... }:
let
  fontPaths = [ ./ComicCodeLig ];
in
lib.mkMerge ((map
  ({ name, path }: { home.file.".local/share/fonts/${name}".source = "${path}/${name}"; })
  (builtins.concatMap
    (path: map
      (file: { name = file; path = path; })
      (builtins.attrNames (builtins.readDir path)))
    fontPaths)))
