{ pkgs }:

let
  inherit (pkgs) callPackage;
in
{
  highlight-js = callPackage ./highlight-js { };
}
