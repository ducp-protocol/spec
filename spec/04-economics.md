# 04 — Economics & Settlement

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. Supply: work-minted and elastic

**1.1** New 𝕌 MUST be created in exactly one way: as **work-issuance** rewarding verified useful work ([03](03-verification.md)). There MUST be no other mint (`I-ECON-ONEMINT`).

**1.2** There MUST be no fixed supply cap and no halving schedule; supply tracks the real compute economy. The **work-issuance rate** is a governance parameter ([07](07-governance.md)), expected to be elevated at bootstrap and to taper.

## 2. Settlement

On verified delivery of a task, two distinct effects MUST occur and MUST be recorded distinctly:

**2.1 Payment transfer.** The Requester's escrowed 𝕌 MUST be **transferred** to the Provider. It is existing money changing hands; it MUST NOT be burned and re-minted (`I-ECON-TRANSFER`).

**2.2 Work-issuance.** A small, governance-tunable amount of **new** 𝕌 MUST be issued to the Provider as the work reward — the sole new-money source (§1.1). The Provider thus receives the market payment plus the issuance subsidy.

**2.3** A per-task fee MUST compensate Validators for consensus and settlement checks. Fee level is a governance parameter.

## 3. Burns

**3.1** Burning MUST be reserved for genuine supply reduction only: (a) an OPTIONAL fee-burn for deflationary policy, and (b) the **clawback burn** that corrects fraud (§4). Burning MUST NOT be part of ordinary settlement (`I-ECON-NOBURNSETTLE`).

## 4. Finality and clawback

**4.1 Ledger finality.** On a valid proof/attestation, settlement MUST be **final**: the result is accepted, payment transfers, and issuance occurs at once. A settled transaction MUST NOT be rewritten thereafter (`I-ECON-FINAL`).

**4.2 Bonded clawback.** Soundness is preserved separately by bonded stake: a Provider's stake MUST remain locked for a **clawback window** ([03 §4](03-verification.md)). If fraud is later proven, the protocol MUST take the clawback amount plus a fine from the bonded stake and MUST burn an offsetting amount of 𝕌 equal to the fraudulent issuance.

**4.3 Holder protection (`I-ECON-BACKED`).** The offsetting burn MUST remove exactly the fraudulent issuance from supply at the fraudster's expense, so that every other holder's 𝕌 remains fully work-backed. No innocent holder may absorb the loss.

**4.4** Finality is of the **ledger**, not of the **bond**: distinguish irreversible transaction settlement from the separately slashable stake. Implementations MUST NOT conflate the two.

## 5. Value model

**5.1** 𝕌 is a **stable measure** (a numeraire): because one 𝕌 is a fixed quantum of computation by definition ([01](01-unit.md)), prices and costs MAY be denominated in 𝕌.

**5.2** 𝕌 is a **redeemable anchor**: one 𝕌 MUST always be redeemable for its defined quantum of compute, because Providers stand ready to perform work for it. The floor is enforced by the market through arbitrage, NOT by any central peg or reserve (`I-ECON-NOPEG`). The protocol MUST NOT operate a price-defending reserve.

## 6. Markets

**6.1 Routing.** Under normal load, work MUST clear at base prices with efficiency-preferred routing ([05](05-standing.md)).

**6.2 Urgency.** Under congestion, an auction/surge mechanism MAY allocate scarce capacity. Urgency bids MUST be **transfers** of existing 𝕌, never new issuance (`I-ECON-NOINFLATE`). Auction parameters are governance-set.

## 7. Treasury & bootstrap

**7.1** Any treasury MUST be minimal, funded by a slice of fees and (at bootstrap) sponsorship, and allocated retroactively by governance. Sponsorship MUST confer no governance power and no favoritism (donations are pooled and allocated by the same Standing-governed process; sponsors MUST NOT earmark) (`I-ECON-NOBUYGOV`).

**7.2** There MUST be no premine. Bootstrap relies on free issuance to early Providers and day-one redeemability.

## 8. Invariants

- **I-ECON-ONEMINT** — verified work is the sole source of new 𝕌.
- **I-ECON-TRANSFER** — payment is transferred, not burned-and-reminted.
- **I-ECON-FINAL** — settled transactions are irreversible; only bonded stake is clawed back.
- **I-ECON-BACKED** — clawback burns exactly the fraudulent issuance; other holders stay fully backed.
- **I-ECON-NOPEG** — value floor is market-enforced via redeemability, not a central peg.
- **I-ECON-NOINFLATE** — fees, urgency bids, and transfers never mint new 𝕌.
- **I-ECON-NOBUYGOV** — money cannot buy governance power, even via sponsorship.

## 9. Open items

Issuance/fee/auction parameter values; clawback-window sizing; the residual wash-trading bound (developed in [08](08-security.md)); unit precision shared with [01](01-unit.md).
