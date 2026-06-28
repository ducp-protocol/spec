# 05 — Standing (Reputation)

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. Nature

**1.1** **Standing** is an earned reputation accrued from objective, on-chain events and measured in **Standing Points (SP)** on a separate, non-spendable ledger.

**1.2 Non-transferability (`I-STAND-NOXFER`).** Standing MUST NOT be bought, sold, lent, or moved between identities by any mechanism. This property is **constitutional** ([07](07-governance.md)) and beyond any vote.

**1.3** Standing MUST be strictly distinct from 𝕌: 𝕌 is spendable money, Standing is unspendable reputation. Standing MUST NOT be mintable as 𝕌, and 𝕌 MUST NOT be convertible to Standing (`I-STAND-NOTMONEY`). The same good behavior earns both, by separate accounting.

**1.4** Standing MUST derive only from objective, on-chain events — never from subjective ratings (`I-STAND-OBJECTIVE`).

## 2. Dynamics

**2.1 Base accrual.** A Provider earns approximately **+1 SP per 1 𝕌 of verified work** (same scale as the currency, on the non-spendable ledger).

**2.2 Positive adjustments.** Attested efficiency above the benchmark MAY multiply accrual upward ([03 §2.1](03-verification.md); subject to the energy-attestation open item). Sustained reliability (uptime, on-time completion, passing verification) adds to Standing. Citizenship acts — catching fraud, responsible vulnerability disclosure, adopted protocol improvements — earn fixed awards.

**2.3 Penalties.** Fraud, fines, missed deadlines, and downtime MUST subtract Standing, with repeat offenses escalating.

**2.4 Decay.** SP MUST decay by a governance-set fraction each epoch, so Standing reflects current contribution (`I-STAND-DECAY`). Decay is the anti-incumbency force: standing must be continually re-earned.

**2.5 Bounds.** Accrual MUST be bounded against runaway accumulation. A new identity MUST begin with low Standing and high stake requirement (Sybil resistance, [08](08-security.md)). An identity whose Standing collapses to bankruptcy MUST be removed, with a deliberately costly path back.

## 3. Effects

Standing MUST translate into the following advantages, and no others that could be purchased with 𝕌:

**3.1 Governance weight.** Within a chamber, voting weight MUST be a dampened, capped transform of SP — **square-root weighted** with a per-identity cap ([07 §2](07-governance.md)).

**3.2 Lower stake.** Higher Standing MUST reduce the stake a participant locks to take on work.

**3.3 Routing priority.** Higher Standing MAY earn more and better work through matching.

**3.4 Resilience buffer.** Higher Standing MUST grant more tolerance before sanctions, so an established participant is not undone by a single failure, while a fresh/low-Standing identity has little buffer ([06 §3](06-task-lifecycle.md)).

## 4. Funding

Standing's material benefits MUST be funded by redistribution (fines/clawbacks from bad actors flowing to good ones) and market premiums — never by inflating 𝕌. The reputation system MUST be self-funding and, in steady state, approximately zero-sum in monetary terms (`I-STAND-SELFFUND`; consistent with [04 `I-ECON-ONEMINT`](04-economics.md)).

## 5. Parameters

The per-𝕌 accrual rate, efficiency multipliers, reliability and citizenship awards, penalty schedule, decay fraction, accrual cap, and the square-root weighting + cap are all **governance parameters** ([07](07-governance.md)). Non-transferability (1.2) and objectivity (1.4) are **not** parameters; they are constitutional.

## 6. Invariants

- **I-STAND-NOXFER** — Standing is non-transferable (constitutional).
- **I-STAND-NOTMONEY** — Standing and 𝕌 are non-convertible in either direction.
- **I-STAND-OBJECTIVE** — Standing derives only from objective on-chain events.
- **I-STAND-DECAY** — Standing decays each epoch and must be re-earned.
- **I-STAND-SELFFUND** — Standing's benefits never inflate the currency.

## 7. Open items

Concrete values for all parameters in §5; the precise efficiency-multiplier function (gated by energy attestation, white paper §14); the bankruptcy/re-entry procedure.
