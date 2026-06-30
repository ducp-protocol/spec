# The Quant (ℚ) — Companion Standard

**A substrate-independent unit of computational energy efficiency, benchmarked against the Landauer limit.**

<p align="center">
  <a href="Quant_Standard_v0.1.0.pdf"><img src="https://img.shields.io/badge/Companion%3A%20The%20Quant%20(%E2%84%9A)-RFC%20v0.1.0-2E8B57?style=for-the-badge" alt="The Quant (ℚ) — RFC v0.1.0"></a>
</p>

The Quant is DUCP's **companion standard**. Where the protocol's native unit **𝕌 (the Universal Compute Unit)** measures *how much* useful work was delivered, the Quant **ℚ** measures *how cleanly* it was delivered — the useful information resolved per joule, normalized to a reference machine and to operating temperature. Together they form a **two-axis model of computation**: 𝕌 is the quantity axis (metered and rewarded), ℚ is the quality axis (measured and made legible, **never** affecting payment).

The Quant is defined to stand on its own. It is usable by anyone comparing efficiency across CPUs, GPUs, and emerging substrates — Green500 entrants, sustainability-bound buyers, and hardware vendors — independent of whether they use DUCP. DUCP is its first reference adopter.

> **Request for Comments & Collaboration.** **v0.1.0** is the first public release — a unit defined to be *measured*, not asserted — now seeking scrutiny, validated benchmark data, and collaborators. See [Comments & collaboration](#comments--collaboration).

## Read it

- [**The Quant (ℚ): A Standard for Measuring Computational Energy Efficiency — v0.1.0 (PDF)**](Quant_Standard_v0.1.0.pdf) — current
- [Markdown source](Quant_Standard_v0.1.0.md) — editable source
- [Changelog](CHANGELOG.md) · [Release `quant-v0.1.0`](https://github.com/ducp-protocol/ducp-spec/releases/tag/quant-v0.1.0)
- Prior drafts (provenance): [`releases/`](releases/) · author-local [`archive/companion-docs/Quant_Standard_Proposal_v0.3.pdf`](../archive/companion-docs/Quant_Standard_Proposal_v0.3.pdf) (not published)

## Status

**v0.1.0 (Request for Comments & Collaboration), June 2026.** An open standard proposal seeking scrutiny and validated benchmark data, not a ratified standard. Public history begins at v0.1.0; prior internal drafts are archived. The version line is independent of the DUCP white-paper version.

**Versioning.** `0.MINOR.PATCH` during the RFC phase; **1.0.0** reserved for a normative-stable standard. See [CHANGELOG.md](CHANGELOG.md).

## How it connects to DUCP

| Shared element | Role |
|---|---|
| **Two-axis model** | 𝕌 = quantity (rewarded); ℚ = quality (reward-neutral observable). |
| **Reward-neutrality** | ℚ is recorded per settled task but never affects 𝕌 minting, payment, or proof validity — so no older device, hot climate, or constrained region is ever penalized. |
| **Benchmark Node** | The same reference machine that sets DUCP's 𝕌 metering publishes the Quant's $E_\text{baseline}$ and $T_\text{std}$, tightened on the Green500 cadence. |
| **Sealed Power Proof** | The bound-don't-measure mechanism (developed in DUCP) by which ℚ is recorded trustlessly where per-task energy cannot be both confidential and attested. |
| **Vendor-locked power register** | The single concrete hardware ask shared by both efforts. |

DUCP depends only on the Quant's classical, Landauer-bounded core (§§3–6 of the paper). See the main protocol [white paper](../whitepaper/) and the [README](../README.md).

## Comments & collaboration

This is a **request for comments and collaboration** — critique, especially adversarial, is welcome.

- **Comment or propose:** open an issue in the [DUCP spec repo](https://github.com/ducp-protocol/ducp-spec/issues) with the [`quant`](https://github.com/ducp-protocol/ducp-spec/issues?q=label%3Aquant) label, or email mr.singhpawan@gmail.com.
- **Where help matters most** — the paper's open work:
  - validated benchmark entries with NIST-traceable power and temperature logs (MLPerf-style runs);
  - empirical regression on the arithmetic-precision scaling law;
  - the vendor-attested **locked power register** (Seal grade S2) — the one concrete hardware ask;
  - standardizing the per-task measurement boundary (chip / node / facility).

ℚ is deliberately defined to be *measured, not asserted*: the most valuable contributions are real measurements and rigorous critique.

## Licensing, Ownership & Trademarks

Same terms as the rest of DUCP — **ownership and control are retained by the author through the pre-1.0 phase.**

- **Copyright** © 2026 Pawan Singh. All rights reserved except as expressly granted.
- **Document license** — [CC BY-NC-ND 4.0](../LICENSE-DOCS): read, share, and cite the verbatim, attributed document for non-commercial purposes; no derivatives or commercial use without written permission.
- **Trademarks** — "Quant" and the Quant (ℚ) mark are trademarks of the author, alongside "DUCP," "Decentralized Universal Compute Protocol," and the 𝕌 / UCU mark.

*This summary is informational, not legal advice.*

## Citation

```
Singh, P. (2026). "The Quant (ℚ): A Standard for Measuring
Computational Energy Efficiency." Version 0.1.0, June 2026.
Request for Comments & Collaboration. Companion to the
Decentralized Universal Compute Protocol (DUCP).
```
