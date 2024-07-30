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
