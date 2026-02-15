# RavenSlide

RavenSlide gives Hyprland a fullscreen panel workflow: each app can live on its own workspace panel, and you switch context by sliding between occupied panels. It also includes a true carousel mode that lays panel windows out as floating cards so you can rotate and select one.

## Features

- Dedicated panel workspace range (default `21-40`)
- Move active window to a fresh panel and fullscreen it
- Launch apps directly into fresh panels (auto-fullscreens)
- Cycle next/previous across occupied panels only
- Close current panel and auto-slide to nearest occupied panel
- Jump directly to any panel by workspace ID
- Swap panel windows between adjacent panels
- Runtime carousel mode with multiple cards visible at once
- Opacity dimming for carousel depth effect
- Batched IPC for smooth carousel transitions
- Signal handling for safe carousel cleanup
- Carousel-like workspace motion preset (non-carousel mode)
- Shared function library to reduce duplication
- Clear runtime errors if run outside a Hyprland session

## Requirements

- Hyprland running
- `hyprctl`
- `jq`

## Install

Quick path with `make`:

```bash
make install
make ensure-source
```

Then test without reload:

```bash
make apply-carousel
make panel CMD='launch kitty'
make panel CMD='launch firefox'
make carousel CMD='toggle'
make carousel CMD='next'
make carousel CMD='open'
```

Manual path:

1. Install the scripts:

```bash
mkdir -p ~/.config/hypr/scripts
cp scripts/ravenslide-lib ~/.config/hypr/scripts/ravenslide-lib
cp scripts/ravenslide ~/.config/hypr/scripts/ravenslide
cp scripts/ravenslide-apply-carousel ~/.config/hypr/scripts/ravenslide-apply-carousel
cp scripts/raven-carousel ~/.config/hypr/scripts/raven-carousel
chmod +x ~/.config/hypr/scripts/ravenslide-lib ~/.config/hypr/scripts/ravenslide ~/.config/hypr/scripts/ravenslide-apply-carousel ~/.config/hypr/scripts/raven-carousel
```

2. Install the Hyprland snippet:

```bash
cp hypr/ravenslide.conf ~/.config/hypr/ravenslide.conf
```

3. Include it from your main config (`~/.config/hypr/hyprland.conf`):

```ini
source = ~/.config/hypr/ravenslide.conf
```

## Uninstall

```bash
make uninstall
```

This removes installed scripts, config, and the source line from `hyprland.conf`.

## Test Without Reload

Use this first if `hyprctl reload` has been unstable for you.

1. If not already installed, install scripts:

```bash
make install
```

2. Apply the runtime animation preset (non-persistent):

```bash
~/.config/hypr/scripts/ravenslide-apply-carousel
```

3. Run direct panel commands:

```bash
RS=~/.config/hypr/scripts/ravenslide
$RS help
$RS launch kitty
$RS launch firefox
$RS next
$RS prev
$RS list
$RS close
$RS goto 22
$RS swap next
```

4. Move an existing focused window into a panel:

```bash
$RS adopt
```

5. Add temporary keybinds at runtime (not persisted):

```bash
make runtime-binds
```

## True Carousel Mode

Carousel mode temporarily moves panel windows into one workspace and arranges them as floating cards with a centered selection. Cards further from the selection are smaller and dimmed for depth.

| Distance | Size   | Opacity |
|----------|--------|---------|
| 0 (selected) | 72% | 1.0 |
| 1        | 50%    | 0.85    |
| 2        | 36%    | 0.65    |
| 3+       | 30%    | 0.50    |

1. Toggle carousel (starts or opens selected):

```bash
~/.config/hypr/scripts/raven-carousel toggle
```

2. Rotate:

```bash
~/.config/hypr/scripts/raven-carousel next
~/.config/hypr/scripts/raven-carousel prev
```

3. Confirm or cancel:

```bash
~/.config/hypr/scripts/raven-carousel open
~/.config/hypr/scripts/raven-carousel cancel
```

## Persisting Config (Optional)

After runtime testing passes:

```bash
hyprctl configerrors
hyprctl reload config-only
hyprctl configerrors
```

If something breaks after reload, `hyprctl configerrors` will show the exact bad file and line.

## Animation Notes

- `ravenslide-apply-carousel` tunes normal workspace switching animation.
- `raven-carousel` is the actual multi-card carousel mode.

## Default Keybinds (`hypr/ravenslide.conf`)

| Keybind | Action |
|---------|--------|
| `SUPER + ]` | Next panel |
| `SUPER + [` | Previous panel |
| `SUPER + SHIFT + RETURN` | New empty panel |
| `SUPER + SHIFT + SPACE` | Adopt window into panel |
| `SUPER + SHIFT + Q` | Close current panel |
| `SUPER + SHIFT + ]` | Swap with next panel |
| `SUPER + SHIFT + [` | Swap with previous panel |
| `SUPER + 1-5` | Go to panel 21-25 |
| `SUPER + ALT + RETURN` | Launch `kitty` in fresh panel |
| `SUPER + ALT + B` | Launch `firefox` in fresh panel |
| `SUPER + CTRL + TAB` | Toggle carousel mode |
| `SUPER + CTRL + RIGHT` | Carousel next |
| `SUPER + CTRL + LEFT` | Carousel previous |
| `SUPER + CTRL + RETURN` | Open selected carousel card |
| `SUPER + CTRL + ESCAPE` | Cancel carousel mode |

## CLI

```bash
ravenslide new              # Switch to next empty panel
ravenslide adopt            # Move active window to panel + fullscreen
ravenslide launch <cmd...>  # Launch command in fresh panel (auto-fullscreens)
ravenslide next             # Slide to next occupied panel
ravenslide prev             # Slide to previous occupied panel
ravenslide close            # Close current panel, slide to nearest
ravenslide goto <id>        # Jump to panel by workspace ID
ravenslide swap next|prev   # Swap window with adjacent panel
ravenslide list             # List occupied panels (column-aligned)
ravenslide help             # Show help
```

```bash
raven-carousel start    # Enter carousel mode
raven-carousel next     # Move selection right
raven-carousel prev     # Move selection left
raven-carousel open     # Open selected panel and exit
raven-carousel cancel   # Exit and return to previous workspace
raven-carousel toggle   # Start or open selected
raven-carousel status   # Show carousel state
raven-carousel help     # Show help
```

## Environment Variables

- `RAVEN_SLIDE_START` (default `21`)
- `RAVEN_SLIDE_END` (default `40`)
- `RAVEN_SLIDE_FULLSCREEN_MODE` (default `1`)
- `RAVEN_CAROUSEL_WORKSPACE` (default `90`)
- `HYPRCTL_BIN` (default `hyprctl`)

Set these with `env = ...` in Hyprland if you want a different panel range.

## Make Targets

```bash
make help              # Show all targets
make install           # Copy scripts + config
make update            # Same as install
make ensure-source     # Add source line to hyprland.conf
make uninstall         # Remove scripts, config, source line
make validate          # Syntax-check all scripts
make apply-carousel    # Apply runtime animation preset
make panel CMD='next'  # Run any ravenslide command
make carousel CMD='toggle'  # Run any raven-carousel command
make panel-next        # Shortcut: next panel
make panel-prev        # Shortcut: prev panel
make panel-close       # Shortcut: close panel
make panel-goto ID=23  # Shortcut: goto panel
make carousel-toggle   # Shortcut: toggle carousel
make carousel-start    # Shortcut: start carousel
make carousel-next     # Shortcut: carousel next
make carousel-prev     # Shortcut: carousel prev
make carousel-open     # Shortcut: carousel open
make carousel-cancel   # Shortcut: carousel cancel
make status            # Show status of both tools
make runtime-binds     # Add temporary runtime keybinds
make reload-config     # Reload config with error checking
```
