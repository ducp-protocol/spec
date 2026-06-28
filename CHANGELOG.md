# Changelog

All notable changes to the DUCP specification and white paper are recorded here.
Versioning follows the policy in the white paper ("Status of This Document"):
`0.MINOR.PATCH` during the pre-implementation phase, with `1.0.0` reserved for a
specification frozen against a working reference implementation and a public
testnet.

The format is loosely based on the "Keep a Changelog" convention.

## [Unreleased]

### Planned — 0.2.0: ℚ woven into the protocol (DP-0001)
- Bring ℚ into the protocol as a **reward-neutral genesis observable** per
  [DP-0001](proposals/0001-record-q-as-genesis-observable.md): the **(𝕌, ℚ)** record
  pair; an optional **Power Seal** field on the Compute Proof; the on-chain **ℚ-ledger**;
  **seal grades** S0/S1/S2; three gated **Verifier checks**; the **Benchmark Node** as
  ℚ-baseline authority; and a **reward-neutral invariant** binding from genesis (declaratory
  of existing locked identity; formal constitutional lock reserved to v1.0). Substantive
  change (MINOR bump) — lands as white paper **v0.2.0** plus matching
  `spec/` docs and `ducp-node-rs` changes.

## [0.1.1] — 2026-06 — Quant companion

### Added
- **Companion standard: the Quant (ℚ)** — a substrate-independent, Landauer-normalized
  unit of computational energy efficiency, published under [`quant/`](quant/) as Quant
  Standard Proposal **v0.4**. Establishes the **two-axis model** (𝕌 = quantity/rewarded,
  ℚ = quality/reward-neutral observable) as a first-class part of the project, with a
  companion overview, the paper in Markdown + PDF, and Figure 1 regenerated. The Quant
  keeps its own version line, independent of the white-paper version.
- README: new "Companion Standard: The Quant (ℚ)" section, a ℚ row in Core Concepts, and
  `quant/` in the repository layout.

### Changed
- Quant v0.4 narrows the proposal to its rigorous, empirically grounded core: removed the
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

[0.1.0]: ./whitepaper/DUCP_White_Paper_v0.1.0.docx
