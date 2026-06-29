# Quant (ℚ) — Changelog

All notable changes to the Quant companion standard are recorded here.
Versioning follows the same pre-ratification policy as DUCP: `0.MINOR.PATCH` during
the open RFC phase, with **1.0.0** reserved for a normative-stable standard backed
by reference conformance and broad adoption.

The Quant version line is **independent** of the DUCP white-paper version.

The format is loosely based on the [Keep a Changelog](https://keepachangelog.com/) convention.

## [0.1.0] — 2026-06 — First public release (RFC)

First public release of the Quant standard, published as a **Request for Comments &
Collaboration**.

### Highlights

- Defines the **Quant (ℚ)** — a substrate-independent unit of computational energy
  efficiency: useful information resolved per joule, normalized to a reference
  machine and operating temperature, benchmarked against the Landauer limit.
- Operational (classical) definition usable on present hardware; bounded thermodynamic
  efficiency ratio η ∈ (0,1]; temperature and arithmetic-precision scaling laws;
  measurement protocol and bound-don't-measure attestation path.
- Describes coupling to DUCP as **reward-neutral** observable (DUCP is the first
  reference adopter; see DUCP spec v0.2.0 and DP-0001).
- Stands alone for vendors, Green500 entrants, sustainability-bound buyers, and
  hardware labs — independent of whether they adopt DUCP.

### Notes

- Public history begins at **0.1.0**. Prior internal design iterations (through
  internal draft v0.4) are documented in [`CHANGELOG.md`](CHANGELOG.md); prior companion
  proposal v0.3 remains in the author-local [`archive/`](../archive/) (not published).
- GitHub release tag: **`quant-v0.1.0`** on the [spec repository](https://github.com/ducp-protocol/spec).
