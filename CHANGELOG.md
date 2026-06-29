# Changelog

All notable changes to the DUCP specification and white paper are recorded here.
Versioning follows the policy in the white paper ("Status of This Document"):
`0.MINOR.PATCH` during the pre-implementation phase, with `1.0.0` reserved for a
specification frozen against a working reference implementation and a public
testnet.

The format is loosely based on the "Keep a Changelog" convention.

## [Quant 0.1.0] — 2026-06 — First public Quant RFC

First public release of the **Quant (ℚ)** companion standard as a Request for
Comments & Collaboration. See [`quant/CHANGELOG.md`](quant/CHANGELOG.md).

### Added
- **Quant v0.1.0** public release (tag `quant-v0.1.0`): RFC banner, collaboration
  section, independent changelog, and archived internal draft provenance.
- Root README: Quant RFC call-for-comments with `quant` issue label.

### Changed
- Renamed canonical document from internal draft v0.4 to public **v0.1.0**
  (`Quant_Standard_v0.1.0.md` / `.pdf`); cross-links in `spec/09` and DP-0001
  updated.

## [0.2.0] — 2026-06 — ℚ woven into the protocol

Brings the Quant (ℚ) into the protocol as a **reward-neutral genesis observable**
(proposal [DP-0001](proposals/0001-record-q-as-genesis-observable.md), Accepted).

### Added
- **DP-0001** (Accepted): record ℚ as a reward-neutral observable — the **(𝕌, ℚ)**
  record pair; an optional **Power Seal** energy attestation on the Compute Proof; the
  on-chain **ℚ-ledger**; **seal grades** S0/S1/S2 + comparability; three gated
  **Verifier checks**; and the **reward-neutral invariant** (binding from genesis as a
  steward commitment; formal constitutional lock at v1.0).
- **`spec/09-efficiency-observable.md`** (Draft): the normative spec resolving the
  recording side of the energy-attestation open items (`00`/`03`/`05`), with `I-Q-*`
  invariants and a conformance vector.

### Changed
- **White paper → v0.2.0**: folds ℚ in without renumbering — a new **§6.5 "The Second
  Axis: Quality (ℚ)"** and an expanded **§8.1** naming ℚ, the Power Seal, and the
  ℚ-ledger; front matter, status, and citation bumped to 0.2.0.
- Governance reconciled for the pre-1.0 phase: nothing is constitutionally locked yet;
  the steward may revise any part, including identity; the locked core begins at v1.0
  (`GOVERNANCE.md`, `CONTRIBUTING.md`).

## [0.1.1] — 2026-06 — Quant companion

### Added
- **Companion standard: the Quant (ℚ)** — a substrate-independent, Landauer-normalized
  unit of computational energy efficiency, published under [`quant/`](quant/) as Quant
  Standard **v0.1.0** (first public release; substantive content from internal draft v0.4). Establishes the **two-axis model** (𝕌 = quantity/rewarded,
  ℚ = quality/reward-neutral observable) as a first-class part of the project, with a
  companion overview, the paper in Markdown + PDF, and Figure 1 regenerated. The Quant
  keeps its own version line, independent of the white-paper version.
- README: new "Companion Standard: The Quant (ℚ)" section, a ℚ row in Core Concepts, and
  `quant/` in the repository layout.

### Changed
- Internal Quant draft v0.4 (now public as v0.1.0) narrows the proposal to its rigorous, empirically grounded core: removed the
  non-normative speculative material (civilization-scale baseline schedule, action/holographic
  forms, and the "intelligence" `I > 1` threshold) and every reference to it.
- Fixed the Quant → DUCP cross-reference to cite the public white paper **v0.1.0**.
- Trademark notice extended to cover "Quant" and the Quant (ℚ) mark; document licensed
  CC BY-NC-ND 4.0, consistent with the rest of the project.

## [0.1.0] — 2026-06 — First public release

First public release of the DUCP specification, published as a request for
comments.

### Highlights
- Public white paper establishing the protocol: the Universal Compute Unit
  (𝕌 / UCU) as a hardware-neutral, work-minted unit that is itself the currency;
  the DVM standard execution environment; layered, attestation-first
  verification; work-minted elastic economics; and non-transferable **Standing**
  as the governance substrate.
- Neutral, descriptive naming throughout (DVM, DUCP Network, Challenger,
  Validator, Standing).
- A Related Work section situating DUCP against prior art (compute-as-money,
  useful-work currencies, decentralized verification, and reputation governance),
  with novelty stated as a combination claim plus one rare property.
- Honest limitations and open problems stated openly (§14).
- Licensing set for retained ownership with open contribution: white paper under
  CC BY-NC-ND 4.0; contributions under the DUCP CLA; trademark and pre-1.0
  implementation rights reserved.
- Governance documented as single-steward through the pre-1.0 phase, transitioning
  to the protocol's role-chamber model at v1.0.

### Notes
- The revisions that preceded this release (2024–2026) were **private design
  iterations** by the author and are archived for historical interest only. This
  release supersedes them; nothing in DUCP's public history predates 0.1.0.

[0.1.0]: ./releases/DUCP_White_Paper_v0.1.0.docx
