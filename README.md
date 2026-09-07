# hushmic-nix

A Nix flake for [HushMic](https://github.com/Fovty/hushmic), a real-time
microphone noise suppressor for PipeWire.

```console
nix run github:crowquillx/hushmic-nix
```

CI pushes build results to the
[hushmic-nix](https://hushmic-nix.cachix.org) Cachix cache. The flake advertises
that substituter via `nixConfig`, so Nix will prompt to enable it on first use.
To pin it yourself:

```nix
nix.settings.substituters = [ "https://hushmic-nix.cachix.org" ];
nix.settings.trusted-public-keys = [
  "hushmic-nix.cachix.org-1:29j1XWTAAnb869spxlZ937ITJI9MCU1Wre+z7+1HJUM="
];
```

Or add the flake as an input and use `inputs.hushmic-nix.packages.${system}.default`.
HushMic requires a running PipeWire/WirePlumber session and currently supports
only x86_64 Linux, matching upstream.

The GitHub Actions updater runs daily on `master` (or can be started manually
from the Actions tab), checks for a new upstream release, refreshes the source
and Cargo hashes with `nix-update`, and verifies the build. When an update is
found, it opens or refreshes an update pull request, checks the exact pull
request commit with `nix flake check`, and squash-merges it automatically when
that check passes. Runs with no update leave `master` unchanged.
