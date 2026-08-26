#!/usr/bin/env bash
# Installs the Vaporwave theme plus its two companion pieces: the animated
# background plugin and the Rain lock-screen design. Safe to re-run.
set -euo pipefail

THEME_URL="https://github.com/xadacka/omarchy-vaporwave-theme.git"
BACKGROUND_PLUGIN_URL="https://github.com/xadacka/omarchy-vaporwave-background.git"
LOCK_EXPLORER_URL="https://github.com/SirJul1337/omarchy-lock-explorer.git"

echo "==> Installing theme"
omarchy theme install "$THEME_URL"   # also applies it (calls omarchy theme set)

echo "==> Installing animated background plugin"
if omarchy plugin list --json 2>/dev/null | grep -q '"io.github.xadacka.vaporwave-background"'; then
  echo "    already installed, updating"
  omarchy plugin update io.github.xadacka.vaporwave-background --yes
else
  omarchy plugin add "$BACKGROUND_PLUGIN_URL" --enable --yes
fi

echo "==> Checking for the lock screen explorer plugin (adds the Rain design)"
if omarchy plugin list --json 2>/dev/null | grep -q '"io.github.sirjul1337.lock-explorer"'; then
  echo "    already installed"
else
  omarchy plugin add "$LOCK_EXPLORER_URL" --enable --yes
fi
omarchy-shell lock setDesign rain >/dev/null 2>&1 || true

echo "==> Restarting the shell to pick everything up"
omarchy restart shell

cat <<'EOF'

Done. Vaporwave is applied, with the animated background plugin and the Rain
lock screen enabled.

Optional: this look also uses a bit of Hyprland "flair" (opacity, rounding,
a couple of quick animations) that lives outside the theme system. See
extras/hyprland-flair.lua.sample in this repo (or the README) if you want to
match it exactly -- it's not applied automatically since it isn't theme-scoped
and may conflict with your own Hyprland config.

Toggle the digital rain on the background anytime with:
  omarchy-shell background setMatrix false   # or true
EOF
