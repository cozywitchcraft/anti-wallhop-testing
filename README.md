# anti-wallhop-testing

Testing place for the [anti-wallhop](https://github.com/cozywitchcraft/anti-wallhop)

You can download the place [here](https://www.roblox.com/games/17884774403/Anti-Wallhop-Testing).

## Highlights

* [AntiWallhopLoader](src/StarterPlayer/StarterCharacterScripts/AntiWallhopLoader.client.luau) - Demonstrates how the anti-wallhop can be implemented for debugging purposes
* [AlignmentKeys](src/StarterPlayer/StarterPlayerScripts/AlignmentKeys.client.luau) - Reimplementation of the old alignment keys
* [MapFunctions](src/ServerScriptService/MapFunctions.luau) - Functions for loading and saving maps

## Setup

Install tools with [Aftman](https://github.com/LPGhatguy/aftman):

```
aftman install
```

Install packages with [Wally](https://github.com/UpliftGames/wally):

```
wally install
rojo sourcemap -o sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages/
```

Sync with [Rojo](https://github.com/rojo-rbx/rojo):

```
rojo serve
```
