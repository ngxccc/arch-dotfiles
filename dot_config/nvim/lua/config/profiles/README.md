# Profile Composition

Each file in this folder should own one responsibility only.

## Layout

- `tools/` returns a list of Mason package names.
- `formatters/` returns a `formatters_by_ft` map for conform.
- `linters/` returns a `linters_by_ft` map for nvim-lint.
- `servers/` returns an `lspconfig` server table keyed by server name.

## Rules

- Keep one concern per file.
- Prefer small reusable modules over language bundles.
- Let plugin files compose profiles with `merge_list()` and `merge_maps()`.
- If a language needs new support, add a new atomic file instead of expanding an existing mixed file.
