# Nix

<img class="logo" src="https://upload.wikimedia.org/wikipedia/commons/2/28/Nix_snowflake.svg" alt="Nix Logo">

---

## Preface

I'm biased <!-- .element: class="fragment" -->

You know this already 🤷 <!-- .element: class="fragment" -->

---

![](2022-11-18-09-50-50.png)

---

## Nix Ecosystem <!-- .slide: class="fragmented-lists" -->

* Nix language <!-- .element: data-fragment-index="4" -->
* Nix build system <!-- .element: data-fragment-index="3" -->
* Nix as a package manager <!-- .element: data-fragment-index="2" -->
* Nix for development environments <!-- .element: data-fragment-index="1" -->
* ~~Nix as Docker image builder~~
* ~~Nix for home directories~~
* ~~NixOS~~
* ~~NixOS clusters~~
* ~~Nix for Infrastructure as Code~~
* ~~Nix for software / system / cluster tests~~

---

## Why

<p class="fragment">Reproducibility<span class="fragment">?</span></p>

<img src="2022-11-16-12-51-02.png" class="fragment" >

---

## Reproduciblity <!-- .slide: class="fragmented-lists" -->

Today

```console
# apt-get install ruby
# ruby --version
2.7.0
```

Tomorrow

```console
# apt-get install ruby
# ruby --version
3.0.0
```

🤷 <!-- .element: class="fragment" -->

---

## Reproduciblity

Today

```console
$ npm install
$ jq .version node_modules/axios/package.json
"1.0.0"
```

Tomorrow

```console
$ npm install
$ jq .version node_modules/axios/package.json
"1.0.0"
```

Lock files! 🎉 <!-- .element: class="fragment" -->

---

## Reproducibility

👩‍💻 Alice

```console
$ npm install
```

👨‍💻 Bob

```console
$ npm install
npm WARN EBADENGINE Unsupported engine
npm WARN EBADENGINE   required: { node: '>= 19.0.0' },
npm WARN EBADENGINE   current: { node: 'v18.12.1' }
...
```

Lock files? 🤷 <!-- .element: class="fragment" -->

---

## Reproducibility

Ruby has `rbenv`! <span class="fragment">Meh.</span>

```console
$ bundle
...
ld: cannot find -lz: No such file or directory
...
An error occurred while installing mysql2 (0.5.4), and Bundler cannot continue.
```
<!-- .element: class="fragment" -->

'Native' dependencies are 'special' 🤷 <!-- .element: class="fragment" -->

---

## Solution <!-- .slide: class="fragmented-lists" -->

Docker! <span class="fragment">Right?</span>

* Containers
* Composability
* Big binary blobs
* VM on OSX

---

## Let's dive into Nix

* `nix run`
* `nix shell`
* `nix develop`
* (`nix profile install`)

---

## Install

https://nix.dev/tutorials/install-nix

* Docker

  ```sh
  docker run -it nixos/nix
  ```

* ArchLinux

  ```sh
  sudo pacman -S nix
  sudo usermod --append --groups nix-users $USER
  ```

* Debian

  ```sh
  sh <(curl -L https://nixos.org/nix/install) --daemon
  ```

* MacOS

  ```sh
  sh <(curl -L https://nixos.org/nix/install)
  ```

---

## Experimental features <!-- .slide: class="fragmented-lists" -->

* Major improvements to CLI (`nix-command`)
* Structured Nix files (`flakes`)
* Why?
  * Essential
  * Experimental for ~4 years
  * Usage from > 40% of community
* Biggest downside of Nix atm (IMO)

---

## Configure experimental features

Add to `~/.config/nix/nix.conf` and `/etc/nix/nix.conf`:

```text
experimental-features = nix-command flakes
```

Commands:

```console
$ mkdir -p ~/.config/nix
$ echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
$ echo "experimental-features = nix-command flakes" | tee -a /etc/nix/nix.conf
```

On Debian and Archlinux:

```console
$ systemctl restart nix-daemon
```

---

## Nix run

```console [1-2|3-11]
$ cowsay
bash: cowsay: command not found
$ nix run nixpkgs#cowsay hello
 _______ 
< hello >
 ------- 
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
<!-- .element: class="fragment" -->

---

## Nix run

It is a full blown package manager...

```console
$ nix run nixpkgs#gimp
```

---

## Nix run

It does not clutter your `/usr/bin`...

```console
$ nix run nixpkgs#gimp
$ gimp
bash: gimp: command not found
```

<div class="fragment">

It does clutter your `/nix/store`...

```console
/nix/store/6290pbazx8hfj0d6wihlpg71lzgybwkd-gimp-2.10.32/bin/gimp
```

</div>

---

## Nix shell

```console [1|2-3|4]
$ nix shell nixpkgs#nodejs
$ node --version
v18.12.1
$ exit
```
<!-- .element: class="fragment" -->

---

## Nix shell

```console [|1-2|3|4-5|6-7]
$ jq
bash: jq: command not found
$ nix shell nixpkgs#jq
$ jq
$ exit
$ jq
bash: jq: command not found
```

---

## References

```console
$ nix shell nixpkgs#nodejs
$ node --version
v18.12.1
```
<!-- .element: class="fragment" -->

```console
$ nix shell github:nixos/nixpkgs/nixos-unstable#nodejs
$ node --version
v18.12.1
```
<!-- .element: class="fragment" -->

```console
$ nix shell github:nixos/nixpkgs/nixos-20.03#nodejs
$ node --version
v10.19.0
```
<!-- .element: class="fragment" -->

```console
$ nix shell github:nixos/nixpkgs/1db42b7fe3878f3f5f7a4f2dc210772fd080e205#nodejs
$ node --version
v10.19.0
```
<!-- .element: class="fragment" -->

---

## Composition

```console
$ nix shell nixpkgs#{nodejs,ruby}
$ ruby --version
ruby 2.7.6p219 (2022-04-12 revision c9c2245c0a) [x86_64-linux]
$ node --version
v18.12.1
```
<!-- .element: class="fragment" -->

```console
$ nix shell \
    nixpkgs#ruby \
    github:nixos/nixpkgs/nixos-20.03#nodejs
$ ruby --version
ruby 2.7.6p219 (2022-04-12 revision c9c2245c0a) [x86_64-linux]
$ node --version
v10.19.0
```
<!-- .element: class="fragment" -->

---

## Nix develop

<p class="fragment">A stable shell <span class="fragment">with a lock file 🥳</span></p>

---

## Nix develop

```console
$ git init ~/projects/myproject
$ cd $_
$ nix flake init --template github:bobvanderlinden/templates#devShell
```

---

## `flake.nix`

```nix [3|13-17|15]
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  outputs = { self, nixpkgs }: {
    devShell = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            ruby
          ];
        };
      }
    );
}
```

---

## `flake.lock`

* Sits next to `flake.nix`
* Holds Git revisions of inputs
* `nix flake update`

---

## Nix develop

```console [|2-4]
$ nix develop
$ node --version
v16.17.1
$ exit
$ node --version
node: command not found
```

---

## Nix develop

You can use globally installed tools...

```console
$ nix develop
$ code .
$ idea .
$ git pull origin master
```

---

## The magic

* VM? <!-- .element: class="fragment" -->
* Containers? <!-- .element: class="fragment" -->
* Environment variables! <!-- .element: class="fragment" -->

```consoles
$ nix develop
$ echo $PATH
...:/nix/store/akfdiq8w936a8ah16k39scpi8094czb1-nodejs-16.17.1/bin:...:/usr/bin
```
<!-- .element: class="fragment" -->

---

## Flake in practice (Ruby)

```nix [|3|4|5|6-10|11|14-16]
mkShell {
  nativeBuildInputs = with pkgs; [
    ruby_3_1
    sqlite
    mariadb.client
    libmysqlclient
    automake
    pkg-config
    augeas
    libxml2
    github-changelog-generator
  ];

  shellHook = ''
    echo Welcome to my project!
    export BUNDLE_PATH="$PWD/.data/gems"
  '';
}
```

---

## Ruby flake in practice

```console [1|2|3-4|5|6-7]
$ nix develop
Welcome to my project!
$ bundle
# Installing gems
# Compiling native gems
$ bundle exec rails server
# Navigate to http://localhost:3000/
```

---

## Nix as package manager <!-- .slide: class="fragmented-lists" -->

```console [1|2|3-4|5-6|7|8|9-14]
$ nix profile install nixpkgs#gimp
$ gimp
$ ls ~/.nix-profile/bin
gimp
$ nix profile list
0 ... /nix/store/6290pbazx8hfj0d6wihlpg71lzgybwkd-gimp-2.10.32
$ nix profile remove '.*gimp'
$ nix profile rollback
$ nix profile history
Version 1 (2022-11-21):
  flake:nixpkgs#...gimp: ∅ -> 2.10.32

Version 2 (2022-11-21) <- 1:
  flake:nixpkgs#...gimp: 2.10.32 -> ∅
```
<!-- .element: class="fragment" -->

* No root! ✨
* Per-user profile 🎉
* Rollbacks 👍
* 'Globals' 👎

---

## Package availability

https://repology.org/

![](2022-11-16-14-05-36.png) <!-- .element: class="fragment" -->

---

## Finding packages

https://search.nixos.org/packages

---

## The workflow

```console [1|2|4|5|6|7|]
$ cd projecta
$ nix develop
$ # Do my thing
$ exit
$ cd ..
$ cd projectb
$ nix develop
...
```

<figure class="meme fragment">
  <figcaption>That's a lotta work!</figcaption>
  <img src="2022-11-18-17-46-06.png" >
</figure>

---
## direnv

A shell extension for<br>
automatically loading<br>
project environment variables

```console [1-3|4-5|6-7|8-10]
$ cd myproject
direnv: loading .envrc                                     
direnv: export +DATABASE_HOST +DATABASE_PASSWORD +DATABASE_PORT +DATABASE_USER
$ echo $DATABASE_HOST
localhost
$ cd ..
direnv: unloading
$ echo $DATABASE_HOST

$
```
<!-- .element: class="fragment" -->

---

## `.envrc`

`direnv` project confguration file

```bash
export DATABASE_HOST=localhost
export DATABASE_PORT=1234
export DATABASE_USER=admin
export DATABASE_PASSWORD=secret
```
<!-- .element: class="fragment" -->

---

## nix-direnv

A plugin for `direnv`

```console [1-5|6-7|8-9|10-11]
$ cd myproject
direnv: loading .envrc                                 
direnv: using flake
direnv: nix-direnv: renewed cache
direnv: export ... ~PATH ...
$ node --version
v16.17.1
$ cd ..
direnv: unloading
$ node --version
bash: node: command not found
```
<!-- .element: class="fragment" -->

---

## `.envrc`

```bash
use flake
```

---

## Install direnv

```console
$ nix profile install nixpkgs#direnv
```

Add to `~/.bashrc`:

```bash
eval "$(direnv hook bash)"
```

Add to `~/.zshrc`:

```bash
eval "$(direnv hook zsh)"
```

Add to `~/.config/fish/config.fish`:

```bash
>direnv hook fish | source
```

---

## Install nix-direnv

```console
$ nix profile install nixpkgs#nix-direnv
```

Add to `~/.direnvrc`:

```bash
source $HOME/.nix-profile/share/nix-direnv/direnvrc
```

---

## Recap

* `nix run` runs package ad-hoc
* `nix shell` opens ad-hoc shell
* `nix develop` opens `devShell` defined in `flake.nix`
* `flake.nix` has a lock file
* `direnv` automatically loads environment variables upon entering directory
* `nix-direnv` loads environment variables from `nix develop`

---

## Caveats <!-- .slide: class="fragmented-lists" -->

* Flakes are experimental
* CLI is experimental
* Documentation covers non-experimental
* Documentation varies in quality
* Nix language is purely functional
* Steep learning curve
* Creating project setup can be fiddly, like Dockerfile
* Usage should be easy

---

## Community work

* devshell (https://github.com/numtide/devshell)
* devenv (https://devenv.sh/)
* flox (https://floxdev.com/)

---

## Slides

https://bobvanderlinden.github.io/nix-workshop/

<qrcode href="https://bobvanderlinden.github.io/nix-workshop/" />

---

## Host slides locally

```console
$ nix run github:bobvanderlinden/nix-workshop
```

---

## Host slides using Docker 🤭

```console
$ nix build github:bobvanderlinden/nix-workshop#dockerImage
$ docker load < result
$ docker run -it nix-workshop:XXX
```

---

## The end<span class="fragment">?</span>

---

## Packages

[https://github.com/NixOS/nixpkgs pkgs/tools/audio/volumeicon/default.nix](https://github.com/NixOS/nixpkgs/blob/3c5cc34fac30437567fb71882c19112fbde27bee/pkgs/tools/audio/volumeicon/default.nix)

```nix [1-4|6|7-8|10-15|17-26|28-34]
{ fetchFromGitHub, lib, stdenv
, autoreconfHook, intltool, pkg-config
, gtk3, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "volumeicon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Maato";
    repo = "volumeicon";
    rev = version;
    hash = "sha256-zYKC7rOoLf08rV4B43TrGNBcXfSBFxWZCe9bQD9JzaA";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
    alsa-lib
  ];

  meta = with lib; {
    description = "A lightweight volume control that sits in your systray";
    homepage = "http://nullwise.com/volumeicon.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden ];
    license = licenses.gpl3;
  };
}
```

---

## Archaic software <!-- .slide: class="fragmented-lists" -->

<ul>
<li class="fragment">MySQL 5.7.29</li>
<li class="fragment">

[No repository has this package](https://repology.org/project/mysql/versions)

</li>
</ul>

<figure class="meme fragment">
  <figcaption>Bail!</figcaption>
  <img src="2022-11-19-15-19-46.png" height="300em">
</figure>

* ☝️ [Source code is available](https://github.com/mysql/mysql-server/tree/mysql-5.7.29)
* 🥳 Nix is a programming language!

---

## Package overrides

```nix [2|3|4-9|12]
let
  mysql-5_7 = pkgs.mysql57.overrideAttrs (oldAttrs: rec {
    version = "5.7.29";
    src = pkgs.fetchFromGitHub {
      owner = "mysql";
      repo = "mysql-server";
      rev = "mysql-${version}";
      hash = "sha256-uGjyDWX+Hhg582DvZDuS+iPTPyVA5Hz6dl1no7TNFac=";
    };
  });
in mkShell {
  buildInputs = [ mysql-5_7 ];
}
```

---

## The end<span class="fragment">?</span>

---

## Nix language <!-- .slide: class="fragmented-lists" -->

* Strings
  
  ```nix
  "this is a string"
  ```

* Multi-line strings
  
  ```nix
  ''
  This is
  a multiline
  string
  ''
  ```

---

## Nix language <!-- .slide: class="fragmented-lists" -->

* Lists

  ```nix
  [ 1 2 3 ]
  ```

* Attribute sets (attrs)

  ```nix
  {
    keyA = 3;
    keyB = 4;
  }
  ```

* Variable declaration
  
  ```nix
  let
    variableA = 3;
    variableB = 4;
  in
    variableA + variableB
  ```

---

## Nix language <!-- .slide: class="fragmented-lists" -->

* Functions
  
  ```nix
  let
    funA = arg: arg + 2;
  in
    funA 3
  ```

* Multiple arguments (currying)

  ```nix
  let
    funB = argA: argB: argA + argB;
  in
    funB 1 2
  ```

* Argument destructuring

  ```nix
  { paramA, paramB }: paramA + paramB
  ```

---

## Nix language <!-- .slide: class="fragmented-lists" -->

* Deep attribute sets
  
  ```nix
  {
    this.is.deep = 3;
    this.is.too = 4;
  }
  ```

  equals

  ```nix
  {
    this = {
      is = {
        deep = 3;
        too = 4;
      };
    };
  }
  ```

---

## Nix language <!-- .slide: class="fragmented-lists" -->

* Recursive attribute sets

  ```nix
  rec {
    valueA = 3;
    valueB = valueA + 1;
  }
  ```

* Inherit
  
  ```nix
  {
    inherit valueA valueB valueC;
  }
  ```

  equals

  ```nix
  {
    valueA = valueA;
    valueB = valueB;
    valueC = valueC;
  }
  ```

---

## The end
