{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.9/discrawl_0.11.9_darwin_arm64.tar.gz";
      hash = "sha256-iEX1tYvGDAdPdnWBk2aLTeUx83P2HA3uv6e73z0dhsY=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.9/discrawl_0.11.9_linux_amd64.tar.gz";
      hash = "sha256-6I7GZ9URTs+y+/xYwR5wg1tUYHGL0Vk/xBR+buT/JhU=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.9/discrawl_0.11.9_linux_arm64.tar.gz";
      hash = "sha256-MKX/0s3kcNt00XwNQ2hqChVaLYGKyGphQEYg1dvA3uY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.11.9";

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
