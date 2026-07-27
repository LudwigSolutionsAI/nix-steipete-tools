{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.10/discrawl_0.11.10_darwin_arm64.tar.gz";
      hash = "sha256-yoyKHnHfR1W8umJaIzG6E+gFXzc8jcrnN2gJEavM7Qw=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.10/discrawl_0.11.10_linux_amd64.tar.gz";
      hash = "sha256-P7jx29JCSIUMMloqVLH6mvdL5jPBxuXg/vMLn9yiFa0=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.10/discrawl_0.11.10_linux_arm64.tar.gz";
      hash = "sha256-qwoTOUyLNqZ1eYe9o50YTtF4bEhHL8AW5ZEr0ofZzrE=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.11.10";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/discrawl"
    cp $(find . -type f -name discrawl | head -1) "$out/bin/discrawl"
    chmod 0755 "$out/bin/discrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/discrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/discrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mirror Discord into SQLite and search server history locally";
    homepage = "https://github.com/openclaw/discrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "discrawl";
  };
}
