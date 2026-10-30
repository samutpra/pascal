# pascal

Free Pascal and Lazarus workspace on macOS (Apple Silicon). It holds a portable
Lazarus 4.8 IDE and two small sample projects.

## Requirements

- FPC 3.2.4 (`fpc -iV` must print `3.2.4`). FPC 3.2.2 won't work with this Lazarus build.
- `~/.fpc.cfg` with the `-k-no_objc_relative_method_lists` linker flag (needed with Xcode 26+).

[SETUP.md](SETUP.md) covers installation, the linker workaround and troubleshooting.

## Layout

| Path | Contents |
|------|----------|
| `lazarus/` | Lazarus 4.8 IDE, portable mode (settings in `lazarus/config/`) |
| `HelloWorld/` | LCL GUI app: a label and a "Say Hello" button |
| `HelloConsole/` | Console program that prints `Hello, <name>!` |
| `SETUP.md` | Setup notes |

## Quick start

```sh
# Open the IDE, then open a .lpi file and press F9
open lazarus/lazarus.app

# Build from the command line
cd lazarus
./lazbuild --pcp=config --lazarusdir=. --ws=cocoa ../HelloWorld/HelloWorld.lpi
./lazbuild --pcp=config --lazarusdir=. ../HelloConsole/HelloConsole.lpi

# Run
open ../HelloWorld/HelloWorld.app
../HelloConsole/HelloConsole Alice
```
