# DUCP local workspace

The DUCP project spans **three GitHub repositories** under [`ducp-protocol`](https://github.com/ducp-protocol). Clone them as **siblings** under one parent folder on your machine — not nested inside the spec repo.

## Recommended layout

```
DUCP/                          ← workspace root (open this folder in your editor)
├── spec/                      ← ducp-protocol/spec (white paper, Quant, DUCP-SPEC, proposals)
├── ducp-node-rs/              ← ducp-protocol/ducp-node-rs (reference implementation)
└── org-profile/               ← ducp-protocol/.github (GitHub org landing page)
```

| Local path | GitHub remote | Role |
|---|---|---|
| `spec/` | `git@github.com:ducp-protocol/spec.git` | Normative specification, white paper, Quant, governance docs |
| `ducp-node-rs/` | `git@github.com:ducp-protocol/ducp-node-rs.git` | Rust reference node |
| `org-profile/` | `git@github.com:ducp-protocol/.github.git` | Org profile README and assets |

> **Note:** The GitHub repo `spec` will be renamed to `ducp-spec` in a follow-up step. After that, use `ducp-spec/` as the local folder name and update your remote URL (GitHub redirects the old name).

## First-time setup

From the directory that will become your workspace parent (e.g. `~/Projects`):

```bash
mkdir -p DUCP && cd DUCP
git clone git@github.com:ducp-protocol/spec.git spec
git clone git@github.com:ducp-protocol/ducp-node-rs.git
git clone git@github.com:ducp-protocol/.github.git org-profile
```

Or run the helper script from a fresh `spec/` clone:

```bash
./scripts/setup-workspace.sh            # creates ../ducp-node-rs and ../org-profile
./scripts/setup-workspace.sh ~/Projects/DUCP   # explicit workspace root
```

## Day-to-day workflow

- **Spec / paper / Quant changes** → commit in `spec/`
- **Reference node / conformance vectors** → commit in `ducp-node-rs/`
- **Org landing badges and repo table** → commit in `org-profile/` (pushes to `.github`)

Cross-repo links in documentation use GitHub URLs, not relative paths between siblings.

## Private local material

The spec repo's `archive/` directory (gitignored) is for author-local draft history only. Keep it inside `spec/` if you use it; it is never published.

## Migrating from a nested layout

If you previously cloned `ducp-node-rs/` or `org-profile/` **inside** the spec repo, move them out to the workspace root:

```bash
cd /path/to/DUCP
mv spec/ducp-node-rs .    # if present
mv spec/org-profile .     # if present
```

Their git history is unchanged; only the path on disk moves.
