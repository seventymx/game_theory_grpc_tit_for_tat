/*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  Author: Steffen70 <steffen@seventy.mx>
  Creation Date: 2024-07-25

  Contributors:
  - Contributor Name <contributor@example.com>
*/

{
  description = "A development environment for working with Golang and gRPC.";

  inputs = {
    base_flake.url = "github:seventymx/game_theory_grpc_base_flake";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        unstable = import inputs.nixpkgs { inherit system; };

        baseDevShell = inputs.base_flake.outputs.devShell.${system};
      in
      {
        devShell = unstable.mkShell {
          buildInputs = baseDevShell.buildInputs ++ [
            unstable.protobuf
            unstable.go
            unstable.delve # Go debugging
            unstable.protoc-gen-go # Go protoc plugin
            unstable.protoc-gen-go-grpc # Go gRPC plugin
          ];

          shellHook = baseDevShell.shellHook;
        };
      }
    );
}
