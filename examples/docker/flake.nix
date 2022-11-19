{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
   in pkgs.dockerTools.buildImage {
     name = "hello-docker";
     config = {
       Cmd = [ "${pkgs.hello}/bin/hello" ];
     };
    };


  };
}
