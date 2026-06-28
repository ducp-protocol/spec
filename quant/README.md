# The Quant (ℚ) — Companion Standard

**A substrate-independent unit of computational energy efficiency, benchmarked against the Landauer limit.**

The Quant is DUCP's **companion standard**. Where the protocol's native unit **𝕌 (the Universal Compute Unit)** measures *how much* useful work was delivered, the Quant **ℚ** measures *how cleanly* it was delivered — the useful information resolved per joule, normalized to a reference machine and to operating temperature. Together they form a **two-axis model of computation**: 𝕌 is the quantity axis (metered and rewarded), ℚ is the quality axis (measured and made legible, **never** affecting payment).

The Quant is defined to stand on its own. It is usable by anyone comparing efficiency across CPUs, GPUs, and emerging substrates — Green500 entrants, sustainability-bound buyers, and hardware vendors — independent of whether they use DUCP. DUCP is its first reference adopter.

## Read it

- [**The Quant (ℚ): A Standard for Measuring Computational Energy Efficiency — v0.4 (PDF)**](Quant_Standard_v0.4.pdf) — current
- [Markdown source](Quant_Standard_v0.4.md) — editable source
- Prior draft (provenance): [`archive/companion-docs/Quant_Standard_Proposal_v0.3.pdf`](../archive/companion-docs/Quant_Standard_Proposal_v0.3.pdf)

## Status

**v0.4 (pre-release draft), June 2026.** An open standard proposal seeking scrutiny and validated benchmark data, not a ratified standard. This revision narrows the proposal to its rigorous, empirically grounded core: every claim is grounded in established physics and is measurable on present or near-term hardware. (Earlier speculative material — a civilization-scale baseline schedule, action/holographic forms, and an "intelligence" threshold — has been removed.) The version line is the Quant's own and is independent of the DUCP white-paper version.

## How it connects to DUCP

| Shared element | Role |
|---|---|
| **Two-axis model** | 𝕌 = quantity (rewarded); ℚ = quality (reward-neutral observable). |
| **Reward-neutrality** | ℚ is recorded per settled task but never affects 𝕌 minting, payment, or proof validity — so no older device, hot climate, or constrained region is ever penalized. |
| **Benchmark Node** | The same reference machine that sets DUCP's 𝕌 metering publishes the Quant's $E_\text{baseline}$ and $T_\text{std}$, tightened on the Green500 cadence. |
| **Sealed Power Proof** | The bound-don't-measure mechanism (developed in DUCP) by which ℚ is recorded trustlessly where per-task energy cannot be both confidential and attested. |
| **Vendor-locked power register** | The single concrete hardware ask shared by both efforts. |

DUCP depends only on the Quant's classical, Landauer-bounded core (§§3–6 of the paper). See the main protocol [white paper](../whitepaper/) and the [README](../README.md).

## Licensing, Ownership & Trademarks

Same terms as the rest of DUCP — **ownership and control are retained by the author through the pre-1.0 phase.**

- **Copyright** © 2026 Pawan Singh. All rights reserved except as expressly granted.
- **Document license** — [CC BY-NC-ND 4.0](../LICENSE-DOCS): read, share, and cite the verbatim, attributed document for non-commercial purposes; no derivatives or commercial use without written permission.
- **Trademarks** — "Quant" and the Quant (ℚ) mark are trademarks of the author, alongside "DUCP," "Decentralized Universal Compute Protocol," and the 𝕌 / UCU mark.

*This summary is informational, not legal advice.*

## Citation

```
Singh, P. (2026). "The Quant (ℚ): A Standard for Measuring
Computational Energy Efficiency." Version 0.4, June 2026.
Companion to the Decentralized Universal Compute Protocol (DUCP).
```
