# 08 — Security Model

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. Threat model

DUCP MUST be sound when most actors are self-interested and some are adversarial. Security rests on the composition of mechanisms specified elsewhere — layered verification ([03](03-verification.md)), open challenge, bonded stake and clawback ([04](04-economics.md)), fines, Standing ([05](05-standing.md)), and the constitution ([07](07-governance.md)) — applied against the threats below.

## 2. Threats and required defenses

| Threat | Required defense |
|---|---|
| **Computation fraud** | Layered verification + open Challenger challenge + retroactive clawback + fine + Standing loss, set so fraud is net-negative in expectation (`I-VERIFY-DETER`). |
| **Sybil attack** | Non-transferable Standing confers no advantage on fresh identities; new identities face high stake. Standing must be earned, not spun up (`I-SEC-SYBIL`). |
| **Verifier/Challenger collusion** | No fixed verifier set to bribe; challenge is open and permissionless; per-identity caps + cross-chamber approval limit concentrated influence. |
| **TEE compromise** | Randomized trustless spot-audits behind the attestation path ([03 §2.4](03-verification.md)); proven fraud triggers clawback + fines from bonded stake. |
| **Governance capture** | Unbuyable Standing-weighted chambers, square-root weighting, per-identity caps, decay, and the locked constitution ([07](07-governance.md)). |
| **Spam / DoS** | Per-task fees and stake requirements; Challengers post anti-spam bonds. |

## 3. Wash-trading and issuance-farming

The subtlest attack on a work-minted currency is self-dealing: one actor as both Requester and Provider, farming the work-issuance ([04 §2.2](04-economics.md)). DUCP MUST meet it with a layered defense **and** bound the worst case by an invariant, not detection alone.

**3.1 Structural floor.** Work-issuance MUST be calibrated below the real resource cost of performing the work, so a self-dealer takes a net loss each cycle before any policing.

**3.2 Identity separation.** Requester and Provider are Sybil-resisted, distinct identities; a Requester MUST hold real, work-earned 𝕌 to pay, so the attack cannot be seeded from nothing.

**3.3 Detection backstop.** Anti-collusion heuristics flag linked identities and circular flows, denying issuance and Standing and slashing on detection.

**3.4 Bounded blast radius (`I-SEC-WASHBOUND`).** The work-backing invariant ([04 `I-ECON-BACKED`](04-economics.md)) MUST cap the damage: even a wash-trade that evades every defense still produces real compute, so the worst case is a small subsidy leak toward useless-but-real work — **never counterfeit 𝕌**. The attacker cannot fake the work itself.

## 4. Acknowledged residual risks

The following are reduced but not eliminated, and are tracked as open problems (white paper §14):

- **Reactive fraud detection** — a compromised execution is caught by challenge/audit, not routine duplication; a bounded tail risk remains after the clawback window unlocks ([03 §4.3](03-verification.md)).
- **TEE trust** — attestation trusts silicon vendors' roots of trust, which have been compromised and will be again; spot-audits mitigate, not eliminate.
- **Residual wash-trading** — bounded to a subsidy leak (§3.4), not zero.
- **Standing-gaming and benchmark-governance contention** — defended by objective Standing inputs and the locked benchmark methodology; not guaranteed.

## 5. Invariants

- **I-SEC-SYBIL** — fresh identities gain no reputation advantage and face high stake.
- **I-SEC-WASHBOUND** — self-dealing can at worst leak a bounded subsidy; it can never create counterfeit 𝕌.
- (Composes with `I-VERIFY-DETER`, `I-ECON-BACKED`, `I-GOV-*`, `I-STAND-NOXFER`.)

## 6. Open items

Formal analysis gating spec **1.0.0**: sampling probabilities and slashing calibration ([03 §3.2](03-verification.md)); a quantified wash-trading bound; and the game theory of open challenge under collusion.
