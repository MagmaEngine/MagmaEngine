# MagmaEngine
Game Engine

# Compiling for debugging on Linux

meson setup build --native-file linux_x11_native.ini
meson configure build --buildtype=debug -Ddebug_memory=true -Ddebug_vulkan=true -Db_sanitize=address -Db_lundef=false
meson compile -C build
build/MagmaEngine.sh
meson install -C build

TODO:
 - Unit tests
 - Performance framework
 - Renderer
 - Capture input
 - GUI widgets

## Platinum (Platform Abstraction Layer)

TODO:
 - X11 Window creation framework

Support for
 - linux
 - steamdeck
 - windows (maybe?)
 - musl?

## Obsidian (GUI Framework)

## Abyss (Renderer)

## ChaosMatrix (Physics Engine)

## Enigma (Utilities)

Names
MagmaEngine
ChaosMatrix
ShadowBlade
EclipseRender

Whole thing written in C/vulkan?
Meson compiled with clang

Game struct
    Engine
        gui framework
        renderer
        controls
    Game
        gameplay
        controls
        Game loop
        level(s)
        player(s)
        interface

Handle media assets
Save project

Goals
    very compatible with blender
    All written in C and vulkan


### Coding standards:
"l" stands for library

variable:   l_underscore_lowercase_variable_names
function:   l_thing_verb()
struct:     LStructsAreUpperCamelCase
enum:       LEnumTypesAreUpperCamelCase
defines:    _PRIVATE_DEFINES
            L_PUBLIC_DEFINES
