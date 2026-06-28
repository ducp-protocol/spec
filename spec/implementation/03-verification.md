# Profile 0 — 03 · Verification (Sampled Re-execution)

- DUCP-SPEC 0.2.0 · Profile 0 · See [README](README.md) · normative parent [../03](../03-verification.md)

Profile 0 has exactly one verification tier — **sampled re-execution** — which the DVM assigns to every task at submit (`I-VERIFY-NOCHOICE`; TEE/ZK are reserved tiers). Because the DVM is deterministic ([02](02-dvm-and-metering.md)), re-execution is an **exact** check: re-run on the same `{module, input, benchmark}` and compare the `result_hash` and `ucu_count` byte-for-byte. Crate: `ducp-verification`.

## 1. Optimistic acceptance (`I-VERIFY-RUNONCE`)

**1.1** A task is executed **once** by its Provider. On `SubmitProof`, the task is provisionally accepted and proceeds to settle ([04](04-ledger-and-settlement.md)); it is **not** re-executed on the normal path.

**1.2** Soundness comes from (a) a randomly **sampled fraction** of tasks being audited, and (b) **open challenge** during the clawback window — backed by bonded stake. This is the optimistic model: fraud is caught after the fact and punished so that it is net-negative in expectation (`I-VERIFY-DETER`). (Cheap per-task proof *checks*, as opposed to re-execution, arrive with the TEE/ZK tiers; Profile 0 deliberately uses the universal re-execution floor.)

**1.3** The metered `ucu_count` is determined by execution, not asserted on trust: the Requester escrows the declared ceiling `max_ucu`, the Provider reports the actual `ucu_count ≤ max_ucu` in the `ComputeProof`, settlement pays the actual count (refunding the remainder), and that count is exactly what sampling/challenge re-derives. A Provider that misreports `ucu_count` or `result_hash` fails the check.

## 2. Sampling

**2.1** Each task is selected for audit with probability `p` via a deterministic draw seeded by `(block_hash ‖ task_id)`, so selection is reproducible and not gameable by the Provider:

```
selected = (blake3(block_hash ‖ task_id)[0..8] as u64) < (p * 2^64)
```

**2.2** A selected task is assigned to a **re-executor** — an active worker deterministically chosen from the eligible set (excluding the original Provider) by the same seed. The re-executor runs `Dvm::execute` and compares:

```
pass  ⇔  reexec.result_hash == proof.result_hash  AND  reexec.ucu_count == proof.ucu_count
```

**2.3** Mismatch ⇒ **fraud** (§4). Pass ⇒ the audit is recorded; the Provider's bond is released at the end of the clawback window. (VRF-based selection replaces the seeded draw in a later profile.)

## 3. Open challenge

**3.1** Anyone MAY submit `Challenge { task, bond }` while the task is within its clawback window ([04 §4](04-ledger-and-settlement.md)). The challenge forces a re-execution exactly as in §2.2.

**3.2** If the challenge proves fraud, the Challenger is rewarded from the fine (§4) and the Provider is penalized. If the result holds, the Challenger forfeits `bond` (anti-spam). `bond` MUST be ≥ a configured minimum.

## 4. Penalties & deterrence

On proven fraud for a task with payment `P` and work-issuance `W`:

1. **Clawback** — recover `P` from the Provider's bonded stake and return it to the Requester (the original transfer is economically reversed via stake, not by rewriting the settled tx — `I-ECON-FINAL`).
2. **Offsetting burn** — burn `W` so the fraudulent issuance leaves supply (`I-ECON-BACKED`); other holders stay fully backed.
3. **Fine** — slash an additional `F` from bonded stake; pay the auditor/Challenger a reward `R ≤ F` from it.
4. **Standing** — apply a large negative `standing_delta` and increment `strikes` (escalating).

**Deterrence (`I-VERIFY-DETER`).** Parameters MUST satisfy, for the most profitable fraud of gain `G`:

```
p · (P + W + F + value(standing_loss)) ≥ G        (audit) 
```

and the always-present challenge path makes detection probability strictly greater than `p`. Profile-0 devnet defaults (provisional): `p = 0.10`, `F = 2·P`, `R = F/2`, bond_min = `0.25·P`, and a Standing loss that zeroes the offender's `sp`. These are tuned on devnet; the formal calibration is an open item ([../08 §6](../08-security.md)).

## 5. Interface (crate `ducp-verification`)

```rust
pub enum VerifyOutcome { Accept, Fraud { expected: Hash, got: Hash } }

pub trait Verifier {
    /// Tier this verifier implements (Profile 0: SampledReexec).
    fn tier(&self) -> VerificationTier;
    /// Re-derive and compare. For SampledReexec this re-executes via the DVM.
    fn check(&self, task: &TaskBody, proof: &ComputeProof, dvm: &dyn Dvm) -> VerifyOutcome;
}
```

The scheduler invokes a `Verifier` only when a task is **sampled** or **challenged**; the steady-state path performs no re-execution (`I-VERIFY-RUNONCE`). Adding `TeeVerifier` / `ZkVerifier` later is an additional `impl Verifier` plus a tier-assignment rule, with no change to the lifecycle or ledger.

## 6. Invariants & open items

- Preserves `I-VERIFY-RUNONCE`, `I-VERIFY-NOCHOICE`, `I-VERIFY-DETER`.
- **Open / provisional:** `p`, `F`, `R`, bond minimum, and Standing-loss magnitude; re-executor eligibility rules; the move to VRF selection; multi-re-executor quorums for higher assurance.
