{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/Peekaboo/releases/download/v3.9.9/peekaboo-macos-universal.tar.gz";
      hash = "sha256-NPEyJkyHlVBdY4FBFL/pQiZhyj23rILbQMeeuEpg//k=";
    };
  };
in
stdenv.mkDerivation {
  pname = "peekaboo";
  version = "3.9.9";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp $(find . -type f -name peekaboo | head -1) "$out/bin/peekaboo"
    chmod 0755 "$out/bin/peekaboo"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightning-fast macOS screenshots & AI vision analysis";
    homepage = "https://github.com/openclaw/Peekaboo";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "peekaboo";
  };
}
