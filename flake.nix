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
    { self, base_flake, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        unstable = import inputs.nixpkgs { inherit system; };

        pname = "tit_for_tat-service";
        version = "${base_flake.majorMinorVersion.${system}}.0";

        baseDevShell = base_flake.devShell.${system};

        buildDependencies = baseDevShell.buildInputs ++ [
          unstable.protobuf
          unstable.go
          unstable.protoc-gen-go # Go protoc plugin
          unstable.protoc-gen-go-grpc # Go gRPC plugin
        ];
      in
      {
        devShell = unstable.mkShell {
          buildInputs = buildDependencies ++ [
            unstable.delve # Go debugging
          ];
          shellHook = baseDevShell.shellHook;
        };

        packages.default = unstable.stdenv.mkDerivation {
          pname = pname;
          version = version;

          src = ./.;

          buildInputs = buildDependencies;

          buildPhase = ''
            # Set environment variables for compilation
            export PROTOBUF_PATH=${base_flake.protos.${system}}
            export GOCACHE=$(pwd)/.cache/go-build
            export GOMODCACHE=$(pwd)/.cache/go-mod

            export PSModulePath="${base_flake.powershell_modules.${system}}"

            # Create a subdirectory with the project name and move everything into it
            mkdir tit_for_tat

            # Enable extended pattern matching features in Bash
            shopt -s extglob

            mv !(tit_for_tat) tit_for_tat/
            cd tit_for_tat

            pwsh -Command "& {
              Import-Module GrpcGenerator

              # Generate the gRPC client and server code from the protos
              Update-GoGrpc -ProtosArray @('model', 'strategy', 'playing_field')
            }"

            # Build the project
            go build -o $out/tit_for_tat
          '';

          meta = with inputs.nixpkgs.lib; {
            description = "Tit-for-Tat strategy service that subscribes to playing_field and gets invoked during matchups.";
            license = licenses.mpl20;
            maintainers = with maintainers; [ steffen70 ];
          };
        };
      }
    );
}
