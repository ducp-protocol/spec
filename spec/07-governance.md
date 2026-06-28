# 07 — Governance & Constitution

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

> **Phase note.** This document specifies the protocol's *target* on-chain governance. During the pre-1.0 phase the project is steered by its maintainer (see the repository `GOVERNANCE.md`); the mechanism below is what DUCP adopts at and after **1.0.0**.

## 1. Source of voting power

**1.1** Governance power MUST derive from earned, non-transferable **Standing** ([05](05-standing.md)) — never from 𝕌 holdings (`I-GOV-NOTWEALTH`). Because the thing that governs cannot be bought, the system resists capture by capital.

## 2. Weighting

**2.1** Within a chamber, a participant's voting weight MUST be the **square root of their Standing Points**, subject to a **per-identity cap** of a small fraction of the chamber total. Square-root weighting damps large holders; the cap bounds any single actor (`I-GOV-SQRTCAP`).

**2.2** Standing **decay** ([05 §2.4](05-standing.md)) MUST apply to governance weight, so influence must be continually re-earned (anti-incumbency).

**2.3** An entity spanning multiple chambers (by holding multiple roles) MUST have its per-identity caps aggregated across chambers against a linked identity, on top of the cross-chamber requirement (§3).

## 3. Role chambers

**3.1** Participants MUST be organized into role **chambers**: Providers, Requesters, Challengers, Validators, and Traders. (Traders represent holders' stake in the currency — representation by participation, not wealth.)

**3.2** A proposal MUST win **cross-chamber approval** (a cross-chamber supermajority) to pass (`I-GOV-CROSSCHAMBER`), so no single interest can capture the protocol.

## 4. The constitution: locked vs. tunable

**4.1 Locked (beyond any vote).** The following MUST NOT be changeable by governance: the Purpose; the ten Core Values; the unit definition (𝕌 as information, benchmark-anchored, same-work-same-𝕌, efficiency out of the unit — [01](01-unit.md)); work-backing (only verified work mints 𝕌 — [04](04-economics.md)); unit-is-currency (no separate token, ever); non-transferability of Standing ([05](05-standing.md)); redeemability of 𝕌 for compute; the benchmark **methodology** ([01 §4.3](01-unit.md)); and the democratic governance structure itself (`I-GOV-LOCKED`).

**4.2 Tunable (by proposal).** Governance MAY set: the work-issuance rate; benchmark **data** (via the locked methodology); the workload-to-tier mapping; fee levels; Standing constants (rates, multipliers, decay, caps, curve); slashing and fine sizes; stake parameters; surge/auction parameters; proposal thresholds; and improvement-funding allocation.

**4.3** The principle is *identity locked, mechanics flexible*: §4.1 defines what DUCP **is**; §4.2 defines how it **runs**.

## 5. Proposal lifecycle

**5.1** Any participant above a small Standing threshold MAY submit a proposal. A mandatory public review window MUST follow, then a Standing-weighted cross-chamber vote; on a cross-chamber supermajority, the change activates at the next epoch boundary.

**5.2** Deeper or more consequential parameters MUST require a higher Standing threshold to propose and a longer activation delay, so the safeguard scales with the gravity of the change.

**5.3** There MUST be no privileged proposers and no off-chain decision path: thresholds are participation-earned, deliberation is public, and the vote is on-chain.

## 6. Invariants

- **I-GOV-NOTWEALTH** — voting power derives from non-transferable Standing, never holdings.
- **I-GOV-SQRTCAP** — weight is square-root of SP, per-identity capped, and decaying.
- **I-GOV-CROSSCHAMBER** — changes require cross-chamber supermajority.
- **I-GOV-LOCKED** — the constitutional core (§4.1) is beyond any vote.

## 7. Open items

Concrete threshold/cap/supermajority values; the activation-delay schedule by parameter class; identity-linking mechanics for cross-chamber cap aggregation; the on-chain proposal and voting formats. The pre-1.0 → on-chain transition plan is specified in the repository `GOVERNANCE.md`.
