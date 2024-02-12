let
  alamgu-path = import ./dep/alamgu/thunk.nix;
  pkgsSrc = import (alamgu-path + "/dep/nixpkgs/thunk.nix");
  lib = import (pkgsSrc + "/lib");

  perSystem = lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system: import ./. {
     localSystem = { inherit system; };
  });
in {
  inherit (perSystem.x86_64-linux) pocket-core;
  generic-cli = perSystem.x86_64-linux.alamgu.generic-cli;
  #build-docker-recompressed = perSystem.x86_64-linux.alamgu.build-docker-recompressed;
  inherit (perSystem) x86_64-linux x86_64-darwin;
}
  # Hack until CI will traverse contents
  // lib.mapAttrs' (n: lib.nameValuePair ("linux--" + n)) perSystem.x86_64-linux
  // lib.mapAttrs' (n: lib.nameValuePair ("linux--nanos--" + n)) (builtins.removeAttrs perSystem.x86_64-linux.nanos ["test-with-logging"])
  // lib.mapAttrs' (n: lib.nameValuePair ("linux--nanox--" + n)) (builtins.removeAttrs perSystem.x86_64-linux.nanox [])
  // lib.mapAttrs' (n: lib.nameValuePair ("linux--nanosplus--" + n)) (builtins.removeAttrs perSystem.x86_64-linux.nanosplus [])
  // lib.mapAttrs' (n: lib.nameValuePair ("macos--" + n)) perSystem.x86_64-darwin
  // lib.mapAttrs' (n: lib.nameValuePair ("macos--nanos--" + n)) (builtins.removeAttrs perSystem.x86_64-darwin.nanos ["stack-check" "stack-check-with-logging" "test" "test-with-logging" "rustShell"])
  // lib.mapAttrs' (n: lib.nameValuePair ("macos--nanox--" + n)) (builtins.removeAttrs perSystem.x86_64-darwin.nanox ["stack-check" "stack-check-with-logging" "test" "test-with-logging" "rustShell"])
  // lib.mapAttrs' (n: lib.nameValuePair ("macos--nanosplus--" + n)) (builtins.removeAttrs perSystem.x86_64-darwin.nanosplus ["stack-check" "stack-check-with-logging" "test" "test-with-logging" "rustShell"])
