# Free Pascal + Lazarus setup (macOS, Apple Silicon)

Set up on 2026-10-31. macOS 27.2, Xcode 27.2 (`ld-27106.1`), arm64.

## What is installed

| Component | Version | Location |
|-----------|---------|----------|
| Lazarus IDE (prebuilt, portable) | 4.8 | `lazarus/` (this folder) |
| Free Pascal Compiler | 3.2.4rc1 | `/usr/local/bin/fpc`, `/usr/local/lib/fpc/3.2.4/` |
| FPC sources (for CodeTools) | 3.2.4 | `lazarus/fpc/3.2.4/sources/` |

## FPC must be 3.2.4, not 3.2.2

The Lazarus build in `lazarus/` was compiled with FPC 3.2.4, so its LCL `.ppu`
files only work with 3.2.4. With FPC 3.2.2 (e.g. `brew install fpc`) every
LCL project fails with:

```
Fatal: Can't find unit Interfaces used by <project>
```

There is no final FPC 3.2.4 macOS release. The installer comes with the Lazarus
4.8 release on SourceForge:

- <https://sourceforge.net/projects/lazarus/files/Lazarus%20macOS%20aarch64/Lazarus%204.8/>
- File: `fpc-3.2.4rc1a.intelarm64-macosx.dmg`
  (SHA1 `f0885b5c557168aab8b176cff448ceded5ea937f`)

The `.pkg` inside is unsigned. Install it with Installer.app, or with
`sudo installer -pkg ... -target /` in Terminal.app. Claude Code's `!` prefix
can't prompt for a sudo password.

## Linker workaround (Xcode 26+): `~/.fpc.cfg`

Since Xcode 26, Apple's `ld` fails when linking LCL Cocoa apps:

```
ld: malformed method list atom 'ltmp5' (.../cocoawsextctrls.o), fixups found beyond the number of method entries
```

`ld` tries to convert FPC's Objective-C method lists to relative method lists
and fails. Turn that off with a linker flag in `~/.fpc.cfg`:

```
# User FPC config: load the system config, then add local overrides.
#INCLUDE /etc/fpc.cfg

#ifdef darwin
-k-no_objc_relative_method_lists
#endif
```

Things that don't fix it:

- `-ld_classic`: Xcode 27's `ld` ignores it ("no longer supported").
- The Xcode 16.4 `ld` (ld-1167.5): it segfaults in
  `ld::pass::convertMethodListToRelative` on the same objects. It also can't
  read the macOS 27 SDK `.tbd` files.

FPC reads `~/.fpc.cfg` instead of `/etc/fpc.cfg`, so the `#INCLUDE` line is
required. Don't remove it.

## Lazarus configuration

Lazarus runs in portable mode. `lazarus/lazarus.cfg` sets `--pcp=config`, so the
settings live in `lazarus/config/`. Two values in
`lazarus/config/environmentoptions.xml` were changed:

| Setting | Value |
|---------|-------|
| `CompilerFilename` | `/usr/local/bin/fpc` |
| `FPCSourceDirectory` | `$(LazarusDir)/fpc/3.2.4/sources/` |

The original file is saved as `lazarus/config/environmentoptions.xml.bak`.

## Everyday commands

```sh
# Open the IDE
open lazarus/lazarus.app

# Build a project from the command line
cd lazarus && ./lazbuild --pcp=config --lazarusdir=. --ws=cocoa ../HelloWorld/HelloWorld.lpi

# Compile a console program
fpc hello.pas && ./hello
```

These two `ld` warnings appear on every link and are harmless:
`-macosx_version_min has been renamed` and `ignoring duplicate libraries: '-lc'`.

## Projects

- `HelloWorld/`: minimal LCL app with a label and a "Say Hello" button.
  Open `HelloWorld.lpi` in the IDE and press F9.
- `HelloConsole/`: console program (no LCL). It prints `Hello, <name>!`, using
  the first argument as the name or `World` if there is none. Run it with
  `./HelloConsole` or `./HelloConsole Alice`.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Can't find unit Interfaces` | Wrong FPC version. `fpc -iV` must print `3.2.4`. |
| `malformed method list atom` | `~/.fpc.cfg` is missing, or the flag isn't in it. If only the IDE fails, add `-k-no_objc_relative_method_lists` under Project Options → Compiler Options → Custom Options. |
| `codesign` refuses `lazarus.app` | Expected. `Contents/MacOS/lazarus` is a symlink to `lazarus/lazarus`. It wasn't needed: the app opens without re-signing. |
| `open lazarus.app` shows nothing | Happened once, cause unknown, and didn't happen again. Fallback: `cd lazarus && ./lazarus --pcp=config --lazarusdir=. &` |
