# RavenSlide

RavenSlide gives Hyprland a fullscreen panel workflow: each app can live on its own workspace panel, and you switch context by sliding between occupied panels. It also includes a true carousel mode that lays panel windows out as floating cards so you can rotate and select one.

## Features

- Dedicated panel workspace range (default `21-40`)
- Move active window to a fresh panel and fullscreen it
- Launch apps directly into fresh panels
- Cycle next/previous across occupied panels only
- Runtime carousel mode with multiple cards visible at once
- Carousel-like workspace motion preset (non-carousel mode)
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
make carousel CMD='start'
make carousel CMD='next'
make carousel CMD='open'
```

Manual path:

1. Install the scripts:

```bash
mkdir -p ~/.config/hypr/scripts
cp scripts/ravenslide ~/.config/hypr/scripts/ravenslide
cp scripts/ravenslide-apply-carousel ~/.config/hypr/scripts/ravenslide-apply-carousel
cp scripts/raven-carousel ~/.config/hypr/scripts/raven-carousel
chmod +x ~/.config/hypr/scripts/ravenslide ~/.config/hypr/scripts/ravenslide-apply-carousel ~/.config/hypr/scripts/raven-carousel
```

2. Install the Hyprland snippet:

```bash
cp hypr/ravenslide.conf ~/.config/hypr/ravenslide.conf
```

3. Include it from your main config (`~/.config/hypr/hyprland.conf`):

```ini
source = ~/.config/hypr/ravenslide.conf
```

## Test Without Reload

Use this first if `hyprctl reload` has been unstable for you.

1. If not already installed, install both scripts:

```bash
mkdir -p ~/.config/hypr/scripts
cp scripts/ravenslide ~/.config/hypr/scripts/ravenslide
cp scripts/ravenslide-apply-carousel ~/.config/hypr/scripts/ravenslide-apply-carousel
cp scripts/raven-carousel ~/.config/hypr/scripts/raven-carousel
chmod +x ~/.config/hypr/scripts/ravenslide ~/.config/hypr/scripts/ravenslide-apply-carousel ~/.config/hypr/scripts/raven-carousel
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
```

4. Move an existing focused window into a panel:

```bash
$RS adopt
```

5. Add temporary keybinds at runtime (not persisted):

```bash
hyprctl keyword bind "SUPER, bracketright, exec, ~/.config/hypr/scripts/ravenslide next"
hyprctl keyword bind "SUPER, bracketleft, exec, ~/.config/hypr/scripts/ravenslide prev"
```

## True Carousel Mode

Carousel mode temporarily moves panel windows into one workspace and arranges them as floating cards with a centered selection.

1. Start carousel:

```bash
~/.config/hypr/scripts/raven-carousel start
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

4. Optional temporary runtime binds:

```bash
hyprctl keyword bind "SUPER CTRL, TAB, exec, ~/.config/hypr/scripts/raven-carousel start"
hyprctl keyword bind "SUPER CTRL, right, exec, ~/.config/hypr/scripts/raven-carousel next"
hyprctl keyword bind "SUPER CTRL, left, exec, ~/.config/hypr/scripts/raven-carousel prev"
hyprctl keyword bind "SUPER CTRL, return, exec, ~/.config/hypr/scripts/raven-carousel open"
hyprctl keyword bind "SUPER CTRL, escape, exec, ~/.config/hypr/scripts/raven-carousel cancel"
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

- `SUPER + ]` -> next panel
- `SUPER + [` -> previous panel
- `SUPER + SHIFT + RETURN` -> go to next empty panel
- `SUPER + SHIFT + SPACE` -> move active window to next empty panel and fullscreen it
- `SUPER + ALT + RETURN` -> launch `kitty` in a fresh panel
- `SUPER + ALT + B` -> launch `firefox` in a fresh panel
- `SUPER + CTRL + TAB` -> start carousel mode
- `SUPER + CTRL + right` -> carousel next
- `SUPER + CTRL + left` -> carousel previous
- `SUPER + CTRL + RETURN` -> open selected carousel card
- `SUPER + CTRL + ESCAPE` -> cancel carousel mode

## CLI

```bash
ravenslide new
ravenslide adopt
ravenslide launch <cmd...>
ravenslide next
ravenslide prev
ravenslide list
ravenslide help
```

```bash
raven-carousel start
raven-carousel next
raven-carousel prev
raven-carousel open
raven-carousel cancel
raven-carousel status
raven-carousel help
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
make help
make install
make update
make ensure-source
make validate
make apply-carousel
make panel CMD='next'
make panel CMD='launch kitty'
make carousel CMD='start'
make carousel CMD='next'
make carousel CMD='prev'
make carousel CMD='open'
make carousel CMD='cancel'
make runtime-binds
make reload-config
```
