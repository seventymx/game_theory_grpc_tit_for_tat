# Go Strategy Service - `tit_for_tat`

```powershell
# Generate the Go gRPC client and server stubs
Update-GoGrpc -ProtosArray @("model", "strategy", "playing_field")

# Build the Go service
go build

# Run the Tit-for-Tat strategy service
# - The playing_field service has to be started first
./tit_for_tat
```

## Building the Project with Nix

To build the project using Nix, you can run the following command:

```sh
nix build --option sandbox false
```

### Note:

Disabling the sandbox is necessary for this build because the `go` command needs network access to download Go modules.
While this approach works for now, we are exploring more elegant solutions to handle dependencies in a sandboxed environment.
This includes pre-fetching dependencies or using local caches to ensure a secure and reproducible build process.
