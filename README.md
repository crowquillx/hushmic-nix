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

The scheduled GitHub Actions updater checks daily for a new upstream release,
refreshes the source and Cargo hashes with `nix-update`, verifies the build, and
opens (or refreshes) an update pull request. It can also be started manually
from the Actions tab.
