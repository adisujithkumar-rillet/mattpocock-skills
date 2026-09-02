#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$repo_root/config/skill-set.yaml"
codex_skills="${CODEX_HOME:-$HOME/.codex}/skills"
snapshot_root="$repo_root/.local/skill-link-snapshots"
mode="${1:---check}"

mapfile_compat() {
  local line
  while IFS= read -r line; do
    skill_paths+=("$line")
  done
}

skill_paths=()
mapfile_compat < <(awk '
  /^installed:/ { in_installed=1; next }
  /^[a-zA-Z_-]+:/ && in_installed { exit }
  in_installed && /^  - / { sub(/^  - /, ""); print }
' "$manifest")

snapshot() {
  mkdir -p "$snapshot_root"
  local output="$snapshot_root/$(date -u +%Y%m%dT%H%M%SZ).tsv"
  : > "$output"
  local path name target
  for path in "${skill_paths[@]}"; do
    name="${path##*/}"
    target="$codex_skills/$name"
    if [[ -L "$target" ]]; then
      printf '%s\tsymlink\t%s\n' "$name" "$(readlink "$target")" >> "$output"
    elif [[ -e "$target" ]]; then
      printf '%s\texisting\t%s\n' "$name" "$target" >> "$output"
    else
      printf '%s\tmissing\t-\n' "$name" >> "$output"
    fi
  done
  printf '%s\n' "$output"
}

case "$mode" in
  --check)
    status=0
    for path in "${skill_paths[@]}"; do
      name="${path##*/}"
      source="$repo_root/$path"
      target="$codex_skills/$name"
      if [[ ! -f "$source/SKILL.md" ]]; then
        printf 'missing source: %s\n' "$source" >&2
        status=1
      elif [[ ! -L "$target" ]] || [[ "$(readlink "$target" 2>/dev/null || true)" != "$source" ]]; then
        printf 'not linked: %s -> %s\n' "$target" "$source"
        status=1
      fi
    done
    exit "$status"
    ;;
  --apply)
    mkdir -p "$codex_skills"
    snapshot_file="$(snapshot)"
    for path in "${skill_paths[@]}"; do
      name="${path##*/}"
      source="$repo_root/$path"
      target="$codex_skills/$name"
      [[ -f "$source/SKILL.md" ]] || { printf 'missing source: %s\n' "$source" >&2; exit 1; }
      if [[ -e "$target" && ! -L "$target" ]]; then
        printf 'refusing to replace non-symlink: %s\n' "$target" >&2
        exit 1
      fi
      ln -sfn "$source" "$target"
    done
    printf 'snapshot=%s\n' "$snapshot_file"
    ;;
  --rollback)
    snapshot_file="${2:?usage: $0 --rollback SNAPSHOT.tsv}"
    [[ -f "$snapshot_file" ]] || { printf 'snapshot not found: %s\n' "$snapshot_file" >&2; exit 1; }
    while IFS=$'\t' read -r name kind value; do
      target="$codex_skills/$name"
      case "$kind" in
        symlink) ln -sfn "$value" "$target" ;;
        missing) [[ ! -L "$target" ]] || unlink "$target" ;;
        existing) printf 'left existing non-symlink unchanged: %s\n' "$target" ;;
      esac
    done < "$snapshot_file"
    ;;
  *)
    printf 'usage: %s [--check|--apply|--rollback SNAPSHOT.tsv]\n' "$0" >&2
    exit 2
    ;;
esac
