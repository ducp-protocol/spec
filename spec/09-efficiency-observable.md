# 09 — The Efficiency Observable (ℚ)

- Spec: DUCP-SPEC 0.2.0 (Draft) · introduced by [DP-0001](../proposals/0001-record-q-as-genesis-observable.md) · lands with white paper **v0.2.0** · See [00 — Conventions](00-overview.md)

## 1. Purpose and scope

**1.1** This document resolves the **ℚ-style energy-metering** open item ([00](00-overview.md), [03 §2.1](03-verification.md), [05 §2.2](05-standing.md)) by specifying how DUCP records the **Quant (ℚ)** — a substrate-independent measure of computational energy efficiency — as a **reward-neutral observable**. The unit's definition, bounds, and scaling laws are normative in the companion [Quant Standard v0.1.0](../quant/Quant_Standard_v0.1.0.md); this document specifies only how the protocol records ℚ and what may read it.

**1.2** ℚ is the **quality axis** to 𝕌's quantity axis ([01](01-unit.md)): 𝕌 measures *how much* logical work was performed; ℚ measures *how cleanly* (useful work per normalized joule). Recording ℚ MUST NOT change how 𝕌 is metered, minted, or settled (`I-UNIT-ENERGYFREE`).

## 2. The (𝕌, ℚ) record

**2.1** Every settled task MUST record a pair: its 𝕌 count ([01 §3](01-unit.md), always present) and a ℚ entry that is either a value or **null**.

**2.2** ℚ MUST NOT be an input to the 𝕌 count, to minting, or to settlement ([04](04-economics.md)) (`I-Q-REWARDNEUTRAL`). A task whose ℚ is null MUST mint and settle identically to one whose ℚ is a value.

**2.3** ℚ MUST be **protocol-derived** from attested inputs and the benchmark, never a value chosen or reported by a participant (`I-Q-DERIVED`). A participant supplies measured inputs (the Power Seal, §3); the protocol computes ℚ.

## 3. The Power Seal (energy attestation)

**3.1** The **Power Seal** is the concrete form of the optional energy attestation that MAY ride the TEE tier ([03 §2.1](03-verification.md)). It is an **optional** field of the Compute Proof, absent by default. Its absence MUST leave the proof valid and ℚ null.

**3.2** When present, a Power Seal MUST carry: `seal_grade` (§5), `boundary` (§5), the attested static `power_cap`, the observed completion `window`, the rated maximum junction temperature `T_max`, `attestation_evidence` binding the seal to a hardware root of trust **and** to the Task Hash (bulky evidence referenced by content address, not stored inline, §7), and the `benchmark` version ([01 §4.4](01-unit.md)) under which ℚ is computed.

**3.3** The Power Seal MUST attest **configuration** (a static power cap), not data-dependent power telemetry, so that it is side-channel-safe and signable by existing roots of trust ([Quant §6](../quant/Quant_Standard_v0.1.0.md)). This is what lets energy attestation ride the TEE tier without reopening the confidentiality–attestation tension noted in [03 §5](03-verification.md).

## 4. Computing ℚ

**4.1** Where a Power Seal is present and valid (§6), the protocol MUST compute ℚ deterministically per the [Quant Standard §3](../quant/Quant_Standard_v0.1.0.md):

```
ℚ ≡ (C · E_baseline · T_std) / (E_consumed · T)
```

where `C` is the task's metered logical work ([01](01-unit.md)) and `E_baseline`, `T_std` are the standard-energy figure and standard temperature carried by the reference benchmark ([01 §4](01-unit.md)). The numerator `C · E_baseline · T_std` is therefore protocol-known; only `E_consumed` and `T` come from the Power Seal.

**4.2** Because the Power Seal **bounds** rather than measures energy, the protocol MUST record the provable **lower bound** (the *Sealed* ℚ):

```
ℚ ≥ (C · E_baseline · T_std) / (power_cap · window · T_max)
```

The recorded ℚ MUST be this floor, tagged with the seal grade and boundary it was produced under (§5).

**4.3** Where no valid Power Seal is present, ℚ MUST be **null**. ℚ MUST NOT be derived from wall-clock time, throughput, or any self-reported energy figure (`I-Q-NULL`).

## 5. Seal grades and comparability

**5.1** Each ℚ value MUST carry the **seal grade** under which it was produced:

- **S0 — Identity:** a self-attested static power cap. Side-channel-safe; available today; weakest evidence.
- **S1 — Witnessed:** an out-of-band, root-of-trust–signed cap or meter (e.g. BMC / smart PDU). Tamper-evident and cross-Provider comparable; coarser.
- **S2 — Locked:** a vendor-locked, signed on-die power register. The strongest grade and the single hardware capability this standard asks of silicon vendors — **Open** until such a register exists.

**5.2** Each ℚ value MUST carry its measurement **boundary** (`chip` / `node` / `facility`). The protocol MUST NOT fix a single boundary; it records the declared one.

**5.3 Comparability (`I-Q-COMPARE`).** ℚ values MUST be compared only within an identical (`seal_grade`, `boundary`). Consumers, markets, and the Standing efficiency multiplier ([05 §2.2](05-standing.md)) MUST NOT rank ℚ across differing grades or boundaries.

## 6. Verification

**6.1** When a Power Seal is present, the verifying nodes ([03](03-verification.md)) MUST additionally check: (a) **evidence validity** — the attestation chains to a recognized root of trust and binds the Task Hash; (b) **plausibility** — the implied energy is not below the Landauer floor for the resolved work and `T_max` is consistent with the attested device; (c) **well-formedness** — `seal_grade` and `boundary` are valid and consistent with the evidence.

**6.2** If all checks pass, the protocol computes and records ℚ (§4). If any check fails, or no Power Seal is present, ℚ MUST be null and **base settlement MUST be unaffected** ([03 §2.1](03-verification.md)). Verifiers MUST validate the attestation as evidence; they MUST NOT re-measure energy (`I-VERIFY-RUNONCE`).

## 7. The ℚ-ledger

**7.1** From genesis, every settled task MUST record its ℚ entry — `{ ℚ | null, seal_grade, boundary, benchmark_version }` — alongside its 𝕌 count. Early in the network's life this entry is predominantly null; the populated fraction grows as attestation matures, with no protocol change required.

**7.2** The ℚ value and its tags are recorded on-chain; bulky `attestation_evidence` MUST be stored off-chain and referenced by content address.

## 8. Use (all reward-neutral)

**8.1** ℚ MAY drive **efficiency-preferred routing** ([04 §6.1](04-economics.md), [06 §1.2](06-task-lifecycle.md)) and the **efficiency multiplier** on Standing accrual ([05 §2.2](05-standing.md)), and MAY be exposed to opt-in markets, ℚ-gated pools, and disclosure feeds.

**8.2** Any reward that reads ℚ MUST be **additive and never-penalizing**, and MUST act through the market or Standing layers — never through 𝕌 minting or base settlement (`I-Q-REWARDNEUTRAL`). The efficiency-multiplier function is a governance parameter ([05](05-standing.md), [07](07-governance.md)); the reward-neutrality of base settlement is a constitutional commitment (white paper §8.1). Its status during the pre-1.0 phase is set out in [DP-0001 §8](../proposals/0001-record-q-as-genesis-observable.md): binding from genesis as a steward commitment, with formal constitutional lock at v1.0.

## 9. Invariants

- **I-Q-REWARDNEUTRAL** — a missing or invalid Power Seal, and ℚ itself, MUST NOT affect 𝕌 metering, minting, settlement, or proof validity.
- **I-Q-DERIVED** — ℚ is protocol-derived from attested inputs and the benchmark, never self-reported.
- **I-Q-NULL** — where energy is not validly attested, ℚ is null; it MUST NOT be substituted by a time- or throughput-derived proxy.
- **I-Q-COMPARE** — ℚ is comparable only within an identical (seal grade, boundary).

## 10. Conformance

An implementation MUST satisfy the [DP-0001 §9](../proposals/0001-record-q-as-genesis-observable.md) test vector. For one task metered at 𝕌 = 50,000, against a frontier baseline of 13.7 pJ/op at `T_std` = 300 K, four Providers:

| Provider | `E_consumed`/op | `T` | 𝕌 (minted & paid) | ℚ (recorded) |
|---|---|---|---|---|
| A | 27.4 pJ | 350 K | 50,000 | 0.43 |
| B | 13.7 pJ | 300 K | 50,000 | 1.00 |
| C | 10.0 pJ | 250 K | 50,000 | 1.64 |
| D | (no Power Seal) | — | 50,000 | null |

MUST each receive **identical 𝕌 and identical payment**, recording ℚ ≈ {0.43, 1.00, 1.64, null} respectively (within the benchmark's stated uncertainty).

## 11. Open items

The measurement **boundary** standardization (5.2) and the **S2** vendor-locked power register (5.1); the per-task decentralized measurement procedure (the [Quant](../quant/Quant_Standard_v0.1.0.md) measurement protocol); the **efficiency-multiplier function** ([05](05-standing.md)); and a formal bound on Sealed-Power-Proof fraud ([08](08-security.md)). This document resolves the *recording* design for the energy-attestation open items in [03 §8](03-verification.md) and [00](00-overview.md); the *trustless-measurement substrate* they reference remains Open and gates the richest grades.
