# RavenSlide

RavenSlide gives Hyprland a fullscreen panel workflow: each app can live on its own workspace panel, and you switch context by sliding between occupied panels.

## Features

- Dedicated panel workspace range (default `21-40`)
- Move active window to a fresh panel and fullscreen it
- Launch apps directly into fresh panels
- Cycle next/previous across occupied panels only
- Clear runtime errors if run outside a Hyprland session

## Requirements

- Hyprland running
- `hyprctl`
- `jq`

## Install

1. Install the script:

```bash
mkdir -p ~/.config/hypr/scripts
cp scripts/ravenslide ~/.config/hypr/scripts/ravenslide
chmod +x ~/.config/hypr/scripts/ravenslide
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

1. Run direct commands:

```bash
RS=~/.config/hypr/scripts/ravenslide
$RS help
$RS launch kitty
$RS launch firefox
$RS next
$RS prev
$RS list
```

2. Move an existing focused window into a panel:

```bash
$RS adopt
```

3. Add temporary keybinds at runtime (not persisted):

```bash
hyprctl keyword bind "SUPER, bracketright, exec, ~/.config/hypr/scripts/ravenslide next"
hyprctl keyword bind "SUPER, bracketleft, exec, ~/.config/hypr/scripts/ravenslide prev"
```

## Persisting Config (Optional)

After runtime testing passes:

```bash
hyprctl configerrors
hyprctl reload config-only
hyprctl configerrors
```

If something breaks after reload, `hyprctl configerrors` will show the exact bad file and line.

## Default Keybinds (`hypr/ravenslide.conf`)

- `SUPER + ]` -> next panel
- `SUPER + [` -> previous panel
- `SUPER + SHIFT + RETURN` -> go to next empty panel
- `SUPER + SHIFT + SPACE` -> move active window to next empty panel and fullscreen it
- `SUPER + ALT + RETURN` -> launch `kitty` in a fresh panel
- `SUPER + ALT + B` -> launch `firefox` in a fresh panel

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

## Environment Variables

- `RAVEN_SLIDE_START` (default `21`)
- `RAVEN_SLIDE_END` (default `40`)
- `RAVEN_SLIDE_FULLSCREEN_MODE` (default `1`)
- `HYPRCTL_BIN` (default `hyprctl`)

Set these with `env = ...` in Hyprland if you want a different panel range.
