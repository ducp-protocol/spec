<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="brand/ducp-logo-horizontal-dark.png">
    <img alt="DUCP — Decentralized Universal Compute Protocol" src="brand/ducp-logo-horizontal.png" width="540">
  </picture>
</p>

<p align="center"><em>Democratizing Sustainable Compute to Power Technological Evolution</em></p>

> **Status:** Current release — **v0.2.0** (June 2026), a Request for Comments
> that brings the Quant (ℚ) into the protocol as a reward-neutral observable
> (DP-0001). A design seeking scrutiny and collaborators, not a shipped system.
> Open to contribution; owned and stewarded by its author through the pre-1.0 phase.

**An open, trustless protocol that mobilizes the world's compute into one market and makes it a democratized, sustainable abundance — where verified work is the currency, efficiency is rewarded by the market, and governance is earned reputation rather than wealth.**

DUCP exists to accelerate technological evolution and the advancement of intelligence by making compute — the resource all of it runs on — a **democratized, sustainable abundance**: open to anyone to supply or use, plentiful rather than gated, and efficient rather than wasteful. Its central *mechanism* is to make verified computation itself a real, work-backed currency: the **Universal Compute Unit (𝕌, ticker UCU, spoken "the U")** is both the atomic measure of computation and the native currency — work delivered is value minted, with no separate token. One 𝕌 is a quantity of *information processed*, its scale fixed by a reference benchmark (information per standard unit of energy). The same work earns the same 𝕌 on any hardware, and **efficiency is rewarded in the market layer — never baked into the unit.** The currency serves the purpose; it is not the purpose.

## White Paper

- [**DUCP White Paper v0.2.0 (PDF)**](whitepaper/DUCP_White_Paper_v0.2.0.pdf) — current
- [DUCP White Paper v0.2.0 (DOCX)](whitepaper/DUCP_White_Paper_v0.2.0.docx) — editable source

Repository layout: [`whitepaper/`](whitepaper/) — the paper · [`quant/`](quant/) — the companion Quant (ℚ) standard · [`spec/`](spec/) — the formal specification (in progress) · [`proposals/`](proposals/) — change proposals.

**Versioning.** The public history begins at **0.1.0**. DUCP uses semantic versioning adapted for a specification: `0.MINOR.PATCH` during the pre-implementation phase (MINOR for substantive accepted revisions, PATCH for editorial fixes); **1.0.0 is reserved** for a specification frozen against a working reference implementation and a public testnet. The drafts that preceded this release were private and solo; nothing in DUCP's public history predates 0.1.0. See [CHANGELOG.md](CHANGELOG.md).

## Companion Standard: The Quant (ℚ)

DUCP ships with a companion standard, the **Quant (ℚ)** — a substrate-independent unit of *computational energy efficiency*, benchmarked against the Landauer limit. It is the second axis of a **two-axis model of computation**: where **𝕌** measures *how much* useful work was delivered (the metered, rewarded unit), **ℚ** measures *how cleanly* — recorded per task as a **reward-neutral** observable, measured and made legible but never affecting payment. The Quant stands on its own as an efficiency unit usable beyond DUCP (Green500 entrants, sustainability-bound buyers, hardware vendors); the protocol is its first reference adopter.

- [**The Quant (ℚ) — Standard Proposal v0.4 (PDF)**](quant/Quant_Standard_v0.4.pdf) · [Markdown source](quant/Quant_Standard_v0.4.md) · [companion overview](quant/)

The two couple through reward-neutrality, a shared Benchmark Node baseline, the **Sealed Power Proof** (how ℚ is recorded trustlessly when per-task energy can't be both confidential and attested), and a joint vendor-locked-power-register hardware ask. See [`quant/`](quant/).

## Core Concepts

| Concept | Description |
|---|---|
| **𝕌 (Universal Compute Unit)** | The atomic measure of computation and the native currency. One 𝕌 = a quantity of information processed, scaled by a reference benchmark (information per standard joule). Same work → same 𝕌 on any hardware. Symbol 𝕌 (logogram); written **UCU** in plain text; spoken "the U." |
| **ℚ (Quant)** | The *companion* unit of compute **efficiency** — useful information resolved per joule, normalized to a reference and to operating temperature, benchmarked against the Landauer limit. The quality axis to 𝕌's quantity axis; recorded per task as a **reward-neutral** observable. See the [companion standard](quant/). |
| **Unit-is-Currency** | 𝕌 *is* the money — no separate token. Verified work mints 𝕌, and 1 𝕌 is always redeemable for its defined quantum of compute, making 𝕌 a stable, work-backed numéraire that strengthens as compute demand grows. |
| **The DVM** | The DUCP Virtual Machine — the standard execution environment every task runs inside; deterministic and portable, so 𝕌 is metered identically on any machine. |
| **Standing** | A *non-transferable*, earned reputation (distinct from 𝕌 money — it cannot be bought). Earned through verified work, reliability, efficiency, and good citizenship; it drives stake discounts, routing priority, resilience, and governance weight. |
| **Efficiency** | The keystone value — rewarded entirely in the market (efficiency-preferred routing, premiums, scoring against a high-efficiency benchmark), never inside the unit, so no hardware or region is penalized. |
| **Layered Verification** | Open and permissionless: compute runs once, all nodes check the proof/attestation cheaply, re-execution happens only on challenge. TEE-attestation backbone, ZK proofs where feasible, sampled re-execution fallback, trustless spot-audits. |
| **The DUCP Network** | The protocol's network / mainnet. |

## Core Values

**Efficiency** (keystone) · **Integrity** · **Discipline** · **Real, work-backed value** · **Open & decentralized** · **Sustainable** · **Trustless** · **Fair** · **Consensus-governed** · **Democratic**

## Participants

| Role | Description |
|---|---|
| **Provider** | Supplies compute — executes work and is paid in 𝕌. |
| **Requester** | Buys compute — submits tasks and pays in 𝕌. |
| **Challenger** | Open auditor and challenger — hunts fraud and security flaws for bounties. |
| **Validator** | Runs the network: consensus and cheap proof/attestation checks. |
| **Steward** | Participates in governance. |
| **Trader** | Provides market liquidity for 𝕌. |

## How a Task Flows

```
Requester submits a task
        |
        v
The DVM compiles it, assigns a verification tier, and meters its 𝕌 (information)
        |
        v
Requester escrows payment  →  task routed to a Provider
                               (efficiency-preferred; auction/surge if urgent)
        |
        v
Provider executes inside the DVM (TEE / ZK / deterministic, per tier)
        |
        v
All nodes check the proof or attestation cheaply (any Challenger may contest)
        |
        v
Instant settlement: payment transferred to Provider + work-issuance minted + Standing updated
        |
        v
Provider stake stays bonded through a clawback window; fraud caught later is clawed back
```

## Economics

- **Work-minted, elastic supply** — new 𝕌 enters *only* through verified work; supply tracks the real compute economy; no cap, no halving.
- **Settlement** — the Requester's payment is *transferred* to the Provider, plus a small, governance-tunable *work-issuance*; burns are reserved for fees and clawbacks.
- **Lean fees, self-funding security** — a small fee compensates Validators; Challengers are paid from the fines and clawbacks they catch.
- **Bootstrap** — no premine: free issuance for early Providers + 𝕌's day-one redeemable utility + one focused beachhead workload.
- **Treasury** — minimal, funded by fees and sponsorship, allocated retroactively by governance (donations buy no governance power — governance is unbuyable).

## Governance

Voting power is **Standing × role chambers** — square-root weighted, per-entity capped, and decaying — so influence is *merit, not wealth*, and democracy is protected against plutocracy, whales, incumbency, and Sybils. A **constitution** locks the protocol's identity while leaving the mechanics governance-tunable through a direct, cross-chamber proposal process.

**During the pre-1.0 phase**, that on-chain governance is the *destination*, not yet the *mechanism*: DUCP is stewarded by its author, who holds final authority over the specification while it is shaped. Authority transitions to the role-chamber model at v1.0. See [GOVERNANCE.md](GOVERNANCE.md).

## Contributing

Critiques, questions, and proposals are welcome — especially adversarial ones.

- Read [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow and [GOVERNANCE.md](GOVERNANCE.md) for how decisions are made.
- All participation is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).
- Contributions are accepted under the [Contributor License Agreement](CLA.md) (assigns rights to the author, with a license back to you — this keeps the protocol's ownership unified during the pre-1.0 phase).
- **Where help is most needed:** the open problems in §14 of the white paper — trustless energy attestation, formal security analysis, the DVM/benchmark/metering specification, and cross-paradigm normalization.

## Reference Implementation

*In progress* — in Rust, at [`ducp-protocol/ducp-node-rs`](https://github.com/ducp-protocol/ducp-node-rs). It will include the DVM (execution environment & 𝕌 meter), the verification layer (TEE attestation, ZK, sampled re-execution), the Standing and settlement engines, and the governance machinery. Pre-1.0 it is source-available with rights reserved (Business Source License), converting to Apache-2.0 at v1.0 (see Licensing).

## Licensing, Ownership & Trademarks

DUCP is published openly for reading, citation, and contribution, while **ownership and control are retained by the author through the pre-1.0 phase.**

- **Copyright** © 2026 Pawan Singh. All rights reserved except as expressly granted.
- **White paper & specification** — [CC BY-NC-ND 4.0](LICENSE-DOCS): read, share, and cite the verbatim, attributed document for non-commercial purposes; no derivatives or commercial use without written permission.
- **Implementation rights (pre-1.0)** — reserved; an open implementation license is intended at v1.0. See [LICENSE](LICENSE).
- **Contributions** — accepted only under the [DUCP CLA](CLA.md).
- **Trademarks** — "DUCP," "Decentralized Universal Compute Protocol," the 𝕌 / UCU mark, "Quant," and the Quant (ℚ) mark are trademarks of the author.

*This summary is informational, not legal advice; the license, CLA, and trademark position are intended for review by counsel before publication.*

## Author

**Pawan Singh**
- LinkedIn: [linkedin.com/in/singhpawanpreet](https://www.linkedin.com/in/singhpawanpreet/)
- Email: mr.singhpawan@gmail.com

## Citation

```
Singh, P. (2026). "Decentralized Universal Compute Protocol (DUCP):
Technical White Paper." Version 0.2.0, June 2026.
```
