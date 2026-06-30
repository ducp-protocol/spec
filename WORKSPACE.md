# DUCP local workspace

The DUCP project spans **three GitHub repositories** under [`ducp-protocol`](https://github.com/ducp-protocol). Clone them as **siblings** under one parent folder on your machine — not nested inside `ducp-spec`.

## Recommended layout

```
DUCP/                          ← workspace root (open this folder in your editor)
├── ducp-spec/                 ← ducp-protocol/ducp-spec (white paper, Quant, DUCP-SPEC, proposals)
├── ducp-node-rs/              ← ducp-protocol/ducp-node-rs (reference implementation)
└── org-profile/               ← ducp-protocol/.github (GitHub org landing page)
```

| Local path | GitHub remote | Role |
|---|---|---|
| `ducp-spec/` | `git@github.com:ducp-protocol/ducp-spec.git` | Normative specification, white paper, Quant, governance docs |
| `ducp-node-rs/` | `git@github.com:ducp-protocol/ducp-node-rs.git` | Rust reference node |
| `org-profile/` | `git@github.com:ducp-protocol/.github.git` | Org profile README and assets |

## First-time setup

From the directory that will become your workspace parent (e.g. `~/Projects`):

```bash
mkdir -p DUCP && cd DUCP
git clone git@github.com:ducp-protocol/ducp-spec.git ducp-spec
git clone git@github.com:ducp-protocol/ducp-node-rs.git
git clone git@github.com:ducp-protocol/.github.git org-profile
```

## Day-to-day workflow

- **Spec / paper / Quant changes** → commit in `ducp-spec/`
- **Reference node / conformance vectors** → commit in `ducp-node-rs/`
- **Org landing badges and repo table** → commit in `org-profile/` (pushes to `.github`)

Cross-repo links in documentation use GitHub URLs, not relative paths between siblings.

## Private local material

The `archive/` directory (gitignored) in `ducp-spec/` is for author-local draft history only. It is never published.

## Migrating from older layouts

**Nested clones** — if `ducp-node-rs/` or `org-profile/` lived inside the spec checkout, move them to the workspace root:

```bash
cd /path/to/DUCP
mv ducp-spec/ducp-node-rs .    # if present
mv ducp-spec/org-profile .     # if present
```

**Renamed repo (`spec` → `ducp-spec`)** — rename the local folder and update the remote:

```bash
cd /path/to/DUCP
mv spec ducp-spec    # if your folder is still named spec
git -C ducp-spec remote set-url origin git@github.com:ducp-protocol/ducp-spec.git
```

GitHub redirects `ducp-protocol/spec` URLs to `ducp-protocol/ducp-spec` after the rename; update bookmarks and badges to the new name when convenient.
