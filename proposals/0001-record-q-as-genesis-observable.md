# DP-0001: Record ℚ as a Reward-Neutral Genesis Observable

- Status:   Draft
- Author(s): Pawan Singh
- Created:  2026-06-28
- Affects:  white paper (→ v0.2.0), `spec/`, `ducp-node-rs`; constitution (formal lock at v1.0)
- Companion: [The Quant (ℚ) Standard v0.4](../quant/Quant_Standard_v0.4.md)

## Summary

Bring the Quant (ℚ) — DUCP's companion efficiency standard — into the protocol at the **genesis block** as a **reward-neutral observable**: a second number recorded alongside the Universal Compute Unit (𝕌) on every settled task, made legible to markets and reputation but **never** affecting 𝕌 minting, settlement, or proof validity.

What ships at genesis is the *schema and ledger*, not efficiency-based rewards: one optional energy-attestation field on the Compute Proof (the **Power Seal**), an on-chain **ℚ-ledger** (mostly null at first), and a **reward-neutral invariant** (declaratory of existing locked identity; formal constitutional lock reserved to v1.0) that keeps base reward strictly 𝕌-proportional. This makes the protocol's unit of record the pair **(𝕌, ℚ)** — quantity and quality — without reopening any v0.1.0 guarantee. ℚ is computed where a valid Power Seal is present and recorded as `null` otherwise.

## Motivation

**Energy is the binding constraint, and the protocol is silent on it.** Data centers drew ~415 TWh in 2024 (~1.5% of world electricity), projected to ~945 TWh (~3%) by 2030 [Quant §1]. Efficiency — useful work per joule — is the figure that decides how much computation can be deployed. Yet DUCP v0.1.0 treats efficiency only abstractly: §8.1 ("Efficiency Lives in the Reward Layer, Never the Unit") rewards it indirectly through routing and Standing, but the protocol records *nothing* about energy-per-useful-bit. The Quant standard (companion, v0.4) defines a substrate-independent efficiency unit — but nothing in the protocol records it.

**No comparable network records this.** Surveyed decentralized-compute systems verify correctness, storage, or output quality; none records consumed-energy-per-useful-bit. A populated ℚ-ledger is a distinctive, defensible capability and the data substrate for verified-green-compute markets.

**It is genesis-or-never.** The Compute Proof schema, the Verifier validation path, and the fields locked at settlement are consensus-critical — the hardest things to change after launch. Adding the efficiency dimension later means a hard fork of those structures *plus* a politically charged change to the reward rule. Adding an optional field with `ℚ = null` semantics at genesis is backward-compatible by construction: proofs without it stay valid forever, and every later efficiency feature becomes a *read* of an observable present since block 0. The cost at genesis is a few schema fields; the cost of deferral is a fork.

**ℚ's role, stated precisely.** ℚ is the *quality axis* of a two-axis model: 𝕌 measures *how much* useful work was delivered (metered, rewarded); ℚ measures *how cleanly* (measured, reward-neutral). Making ℚ legible lets the **market** (efficiency-preferred routing, green premiums) and **Standing** (ℚ-weighted reputation) reward efficiency — without ever baking it into the unit, so no older device, hot climate, or constrained region is penalized.

## Specification

### 1. The (𝕌, ℚ) record pair

Every settled task records a pair:

- **𝕌** — always present. Derived by the DVM / 𝕌 Meter from the task's portable representation; identical on any hardware; the metered, rewarded unit.
- **ℚ** — present-or-`null`. Derived from an attested energy reading supplied by the executing hardware (the Power Seal, §2). `null` whenever no valid seal is present.

𝕌 and ℚ are computed and stored independently. **ℚ is never an input to 𝕌.**

### 2. The Power Seal — one optional field on the Compute Proof

The Compute Proof (white paper §9 / proof types) gains a single optional field, `power_seal`, absent by default. Every existing-style proof remains valid; for such proofs ℚ is simply `null`.

| Field | Contents |
|---|---|
| `seal_grade` | Trust tier of the attestation: `S0` / `S1` / `S2` (§5). |
| `boundary` | Where energy was bounded/measured: `chip` / `node` / `facility` (§5). |
| `power_cap` | The attested static power cap in force during the task (watts). |
| `window` | Observed completion window (seconds) under that cap. |
| `T_max` | Rated maximum junction temperature of the attested SKU (K). |
| `attestation_evidence` | TEE quote / device-RoT signature / signed cap register, binding the seal to a hardware root of trust **and** to this Task Hash. Bulky evidence is stored off-chain and referenced on-chain by CID. |
| `baseline_ref` | Benchmark Node epoch supplying `E_baseline × T_std` (§7). |

The Power Seal records *configuration* (an attested power cap), **not** data-dependent telemetry. This is the key design choice: a static cap is side-channel-safe by construction and is exactly the kind of fact hardware attestation already signs, so it sidesteps the confidentiality–attestation tension that blocks live power telemetry (see Alternatives).

### 3. Computing ℚ (the Sealed Power Proof)

Where a valid Power Seal is present, the protocol computes ℚ deterministically from the [Quant v0.4 operational definition](../quant/Quant_Standard_v0.4.md):

```
ℚ ≡ (C × E_baseline × T_std) / (E_consumed × T)
```

Because the seal bounds rather than measures energy, the protocol records a provable **lower bound** — the *Sealed ℚ floor*. The cap times the window upper-bounds energy (`E_consumed ≤ power_cap × window`) and the rated maximum upper-bounds temperature (`T ≤ T_max`), giving:

```
Sealed ℚ  ≥  (C × E_baseline × T_std) / (power_cap × window × T_max)
```

`C` (work) and `E_baseline, T_std` (frontier baseline) come from the protocol; `power_cap`, `window`, `T_max` come from the seal. With no valid seal, **ℚ = null** — never a time-derived or self-reported stand-in.

### 4. Verifier checks (gated on field presence)

The VRF-selected Verifier set performs its existing correctness checks unchanged. **When — and only when — `power_seal` is present**, it additionally checks:

1. **Evidence validity** — the attestation chains to a recognized hardware root of trust and binds to this Task Hash.
2. **Plausibility** — the implied energy and temperature are physically possible relative to the Benchmark Node baseline (e.g., not below the Landauer floor for the resolved bits; `T_max` consistent with the attested SKU).
3. **Declaration well-formedness** — `seal_grade` and `boundary` are well-formed and consistent with the evidence type.

If all pass, ℚ is computed (§3) and recorded. **If any fail, or the field is absent, ℚ = null and the Compute Proof is unaffected** — 𝕌 is minted and escrow released exactly as today. Verifiers validate an attestation; they never re-measure energy.

### 5. Seal grades and comparability

The seal grade is the strength of the power-cap attestation; it lets the mechanism grade up gracefully as hardware matures.

| Grade | What it is | Typical boundary | Note |
|---|---|---|---|
| **S0 — Identity** | Self-attested static power cap + provider identity | any | Side-channel-safe; available today; weakest evidence. |
| **S1 — Witnessed** | Out-of-band, RoT-signed BMC / smart-PDU cap or meter | node / facility | Tamper-evident, cross-provider comparable; coarser (includes PSU/fan/PUE overhead). |
| **S2 — Locked** | Vendor-locked, signed on-die power register | chip | Strongest; makes the grade exact. The one concrete hardware ask of silicon vendors. |

**Comparability rule (normative):** ℚ values are only ever compared within the **same grade and boundary**. A chip-boundary S2 reading and a facility-boundary S1 reading measure different things and are never ranked against each other.

### 6. The ℚ-ledger

From the genesis block, every settled task records, alongside its 𝕌 count, a ℚ-ledger entry:

```
{ task_hash, U, Q | null, seal_grade | null, boundary | null, baseline_ref | null }
```

The ℚ value, grade, and boundary go on-chain (small); bulky `attestation_evidence` is stored off-chain by CID. Early on the ledger is overwhelmingly `null`; as attestation hardware and standards mature, the populated fraction rises **with no protocol change**. The ledger is the durable artifact that makes every later efficiency feature a read, not a fork.

### 7. Benchmark Node as ℚ-baseline authority

The Benchmark Node (white paper §6.4) — the reference machine that already calibrates the 𝕌 Tariff — is formalized as the source of `{E_baseline, T_std}` for ℚ. It publishes one baseline tuple per epoch, governance-ratified and tightened on the Green500 cadence per [Quant §5]. No new infrastructure.

### 8. Reward neutrality (binding from genesis; constitutional lock at v1.0)

> Base reward is strictly 𝕌-proportional. A missing, malformed, or invalid Power Seal **never** affects 𝕌 minting, settlement amount, or Compute Proof validity. The energy attestation is orthogonal to settlement.

This **restates an existing identity commitment** — that efficiency is rewarded outside the unit, never inside it (white paper §8.1, "Efficiency Lives in the Reward Layer, Never the Unit," and the project's core values). It is therefore *declaratory*: ℚ is reward-neutral from genesis as a direct consequence of identity DUCP has already committed to, not a new constraint introduced here. A provider supplying no energy data earns exactly the same 𝕌 as one supplying a perfect attestation, which removes any incentive to commit measurement fraud and preserves the no-discrimination guarantee.

This proposal binds the *behavior* from genesis as a **steward design commitment**. Its **formal codification as a constitutional article** — non-governable against *future* on-chain governance — takes effect with the **v1.0 constitution** (white paper §12), since the constitution as a binding instrument begins at v1.0; pre-1.0 it remains revisable by the steward like every other part of the design. Any future additive, **never-penalizing** ℚ multiplier (Phase 3) would likewise be a separate, explicitly-ratified governance act, **not** authorized here.

### 9. Worked example (normative test vector)

One task, metered at 𝕌 = 50,000. Frontier baseline ≈ 13.7 pJ/op at T_std = 300 K. Four providers run it:

| Provider | Energy/op | Die temp | 𝕌 (paid) | ℚ (recorded) | Grade |
|---|---|---|---|---|---|
| A — busy cloud GPU | 27.4 pJ | 350 K | 50,000 | 0.43 | S1 |
| B — efficient rig | 13.7 pJ | 300 K | 50,000 | 1.00 | S2 |
| C — next-gen / cooled | 10.0 pJ | 250 K | 50,000 | 1.64 | S2 |
| D — no Power Seal | 27.4 pJ | 350 K | 50,000 | null | — |

All four earn identical 𝕌; ℚ differs (and is `null` for D, with no penalty). This table is the conformance test vector for the implementation: same task → identical 𝕌, differing ℚ, identical payment.

### Sections touched

- **White paper → v0.2.0 (MINOR):** a new front-of-paper "Two Axes of Compute" section (𝕌 + ℚ as one system); ℚ's reward-neutral genesis role woven into the unit (§6), verification (§9), economics (§10), and governance/constitution (§12) sections. Cites Quant v0.4.
- **`spec/`:** a new normative `09-efficiency-observable.md`, paired with `01-unit.md`.
- **`ducp-node-rs`:** optional `power_seal` on the proof types (`dvm`); the three gated checks (`verification`); the ℚ column + null semantics + CID evidence (`ledger`); Benchmark Node baseline publication.

### Phased rollout (no further forks after Phase 0)

- **Phase 0 — Genesis:** schema + ledger live; ℚ mostly null; invariant locked.
- **Phase 1 — Measure:** seal grades climb S0 → S1 → S2 as attestation hardware matures; ledger populates; ℚ begins feeding Standing + routing.
- **Phase 2 — Market:** opt-in ℚ-gated / green pools, SCI-aligned certificates, efficiency premiums — pure ledger reads.
- **Phase 3 — (optional) Reward:** only if a grade earns enough trust may governance ratify an additive, never-penalizing multiplier. Never required.

## Alternatives considered

- **Defer ℚ to a later "v2 efficiency layer."** Rejected: forces a future hard fork of consensus-critical proof/verification structures, plus a harder, politically charged reward-rule change. Genesis cost is a few null fields.
- **Put ℚ in the reward formula at genesis.** Rejected: per-task energy cannot today be both confidential and trustlessly attested (the TEE–energy paradox — confidential-computing modes suppress fine-grained power telemetry as a side-channel defense). A gameable quantity in the reward rule reintroduces measurement fraud and hardware discrimination. Hence reward-neutral.
- **Sign raw on-die telemetry (RAPL/NVML).** Rejected: coarse (RAPL ~5–10%, GPU interfaces sample ~25% of runtime) and deliberately degraded or disabled inside enclaves; not trustworthy. The Power Seal bounds via an attested cap instead of measuring.
- **Hard-code one measurement boundary (chip vs. node/wall).** Rejected: they measure different things and the trade-off (fidelity vs. attestability vs. comparability) is unsettled; carry `boundary` as metadata and compare like-for-like.

## Open questions / risks

- **Measurement procedure & boundary.** The per-task, decentralized measurement procedure still needs standardizing in the Quant paper's measurement section; the protocol stays boundary-agnostic via tags.
- **S2 hardware dependency.** The exact, vendor-locked power register is an ask of silicon vendors; until it exists, S0/S1 carry the ledger and S2 ℚ values are sparse.
- **Sealed Power Proof fraud bound.** A corrupted claim can inflate the Sealed ℚ floor by at most the ratio of the rated maximum to the true cap (bounded), versus unbounded for fabricated telemetry — but the formal bound belongs in the security spec.
- **Null-heavy early ledger.** Markets and Standing reading ℚ must handle `null` gracefully and must not advantage attesting providers at the base layer (guaranteed by §8).
