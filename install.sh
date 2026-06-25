#!/usr/bin/env bash
# Install cc-tools by symlinking bin/* into your PATH.
#   ./install.sh                 # links into ~/.local/bin
#   PREFIX=/usr/local/bin ./install.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${PREFIX:-$HOME/.local/bin}"

mkdir -p "$TARGET"
linked=()
for src in "$REPO_DIR"/bin/*; do
  name="$(basename "$src")"
  chmod +x "$src"
  ln -sf "$src" "$TARGET/$name"
  linked+=("$name")
done

echo "Linked into $TARGET: ${linked[*]}"

case ":$PATH:" in
  *":$TARGET:"*) ;;
  *) echo
     echo "⚠️  $TARGET is not on your PATH. Add this to your shell rc:"
     echo "      export PATH=\"$TARGET:\$PATH\"" ;;
esac

echo "Done. Try: cc-session --help   |   ccron --help"
