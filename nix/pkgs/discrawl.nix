{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.12.0/discrawl_0.12.0_darwin_arm64.tar.gz";
      hash = "sha256-gSLd34dT+yvlZWHjfdS5c3YpTnKA/G542BRqqkK6OtU=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.12.0/discrawl_0.12.0_linux_amd64.tar.gz";
      hash = "sha256-FmQWuYKBmyRIYbq17zE0kHOCDs2pLux4r1rS+Gp+wOA=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.12.0/discrawl_0.12.0_linux_arm64.tar.gz";
      hash = "sha256-3PTnFnXbVVREHL/rTKfXl0rUFO90uQ7KSC5/4MTZ96g=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.12.0";

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
