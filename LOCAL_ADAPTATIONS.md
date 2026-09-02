# Rillet Codex profile

This branch keeps Matt Pocock's workflow mechanics while adapting selection, writing, and mutation boundaries for the local Codex and Rillet environment.

## Policy

- `config/skill-set.yaml` is the installed set and records the upstream baseline.
- `dense-technical-writing` supplies concise, information-dense prose and purposeful visuals.
- Repository instructions, ADRs, and Rillet-specific skills outrank generic design guidance.
- Repository edits and external mutations require authorization from the user's request.
- Debugging, TDD, implementation, and review skills with stronger local equivalents stay excluded.

## Updating

1. Fetch `upstream` and fast-forward the fork's `main` to `upstream/main`.
2. Tag the current `rillet-codex` head before rebasing it onto `main`.
3. Review changes against `config/skill-set.yaml`, validate every installed skill, and run `scripts/sync-codex-links.sh --check`.
4. Push the updated branch and rollback tag only after verification.

Existing Git commits and tags preserve skill content. Link snapshots under `.local/skill-link-snapshots/` preserve which skill paths were active before each sync.
