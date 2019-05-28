let mkPackage =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.12.3-20190315/src/mkPackage.dhall sha256:0b197efa1d397ace6eb46b243ff2d73a3da5638d8d0ac8473e8e4a8fc528cf57

let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.12.3-20190315/src/packages.dhall sha256:08714bc666b16834f0f4cf86d408745ce005c43e3343821e4c3864ef28709177

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
