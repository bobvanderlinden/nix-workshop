{
  description = "Nix-workshop";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages.x86_64-linux.default = pkgs.writeScriptBin "nix-workshop" ''
      ${pkgs.darkhttpd}/bin/darkhttpd ${./presentation}
    '';
    packages.x86_64-linux.dockerImage = pkgs.dockerTools.buildImage {
      name = "nix-workshop";
      config = {
        Cmd = ["${pkgs.darkhttpd}/bin/darkhttpd" "${./presentation}"];
        ExposedPorts = {
          "8080/tcp" = {};
        };
      };
    };
    devShell.default.x86_64-linux = pkgs.mkShell {
      buildInputs = with pkgs; [ darkhttpd ];
    };
  };
}
