# Altar
A [TempleOS](https://templeos.org/) configuration based off of the [Shrine](https://github.com/minexew/Shrine) distribution.
# Software and Modifications
## Angle
The Angle browser (pronouced Angel) is the first browser for TempleOS. Press F4 to open the address bar and navigate to a website. HTTP only.
## Ed Vi Bindings Mods
The default text editor, Ed, has been modified to support basic Vi bindings. Currently only normal and insert mode are implemented.
ESC in normal mode to save and quit. Shift+ESC any mode to quit.

Supported motions:
- hjkl/arrows
- 0, $
- g, G (g replaces gg/go)
- i, a
- I, A, o
- del
- d (replaces dd)
- p
- u
- /
- n
- {number}{motion}
## Modifications to the Network Stack
The HTTP handler has been extended to work with dynamic length requests.
Couple other small modifications.
# State of the Project
Shrine was made read-only in 2024, or else I would likely submit many of my changes in a PR. If Altar grows distinct enough from Shrine to consider it it's own distro, I'll likely fully fork Shrine and reorganize this repo. For now this is just a small collection of my projects.
