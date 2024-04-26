{
  _3mfmerge,
  openscad-unstable,
  stdenv,
  lib,
  makeWrapper
}:
stdenv.mkDerivation {
  pname = "colorscad";
  inherit (_3mfmerge) src version;

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm755 colorscad.sh $out/bin/colorscad

    # Wrap the script to add the openscad-unstable binary to the PATH
    wrapProgram $out/bin/colorscad \
      --prefix PATH ':' ${lib.makeBinPath [ openscad-unstable ]}

    # Ugly hack to get 3mfmerge in the (by the script) expected location
    ln -s ${_3mfmerge} $out/bin/3mfmerge
  '';

  meta = _3mfmerge.meta // {
    description = "Colorize OpenSCAD models";
    mainProgram = "colorscad";
  };
}
