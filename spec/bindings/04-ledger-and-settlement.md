# Binding — 04 · Ledger, Settlement & Consensus

- DUCP-SPEC 0.2.0 · Reference-node binding · See [README](README.md) · normative parents [../04](../04-economics.md), [../07](../07-governance.md)

The ledger is a deterministic state machine; the consensus engine orders transactions into blocks and replicates the same transition on every node. Crates: `ducp-ledger`, `ducp-consensus`.

## 1. State

```rust
pub struct State {
    pub accounts:  Map<Identity, Account>,        // balance, escrowed, bonded
    pub standing:  Map<Identity, StandingRecord>, // separate ledger (I-STAND-NOTMONEY)
    pub tasks:     Map<TaskId, Submission>,
    pub supply:    Supply,                         // total minted / burned (audit)
    pub epoch:     Epoch,
}
pub struct Supply { pub minted: Ucu, pub burned: Ucu }   // circulating = minted - burned
```

**Conservation invariant (`I-LEDGER-CONSERVE`).** After every block, `Σ(balance + escrowed + bonded) == minted - burned`. New 𝕌 enters only via work-issuance (§3); 𝕌 leaves only via burns (§4). Any transition violating this MUST be rejected.

## 2. Transition function

`apply(State, SignedTx) -> Result<State, Reject>` MUST be pure and deterministic. Signatures and `nonce` are checked first. Per transaction:

**`SubmitTask(body)`** — assign `tier = SampledReexec` and `benchmark`; require `balance ≥ max_ucu + fee`; move `max_ucu + fee` from `balance → escrowed`; create `Submission{ status: Submitted, ucu_count: 0 }`. `TaskId = hash(canonical(body))`.

**`ClaimTask{task}`** — require `Submitted` and an unexpired deadline; compute `claim_stake = stake_base · discount(standing[provider])` ([../05 §3.2](../05-standing.md)); require `balance ≥ claim_stake`; move it `balance → bonded`; set `provider`, `status: Executing`. **Exclusive claim:** one Provider per task.

**`SubmitProof(proof)`** — require `status: Executing`, `proof.provider == provider`, `proof.ucu_count ≤ max_ucu`, `proof.benchmark == benchmark`. Set `status: Verified` and record `proof`. (No re-execution here — [03 §1](03-verification.md).) Then settle (§3) in the same block.

**`Transfer{to,amount}`** — require `balance ≥ amount`; move `balance → to.balance`.

**`Challenge{task,bond}`** — require within clawback window; move `bond` from `balance → bonded(challenger)`; enqueue a forced re-execution ([03 §3](03-verification.md)); resolve per §4.

Unknown/invalid transitions MUST be rejected without mutating state.

## 3. Settlement (atomic, on `Verified`)

Let `u = proof.ucu_count`, escrow held `= max_ucu + fee`. All effects below MUST apply atomically or not at all (`I-LC-FINAL`, `I-ECON-FINAL`):

1. **Payment transfer** — `u` from `requester.escrowed → provider.balance` (`I-ECON-TRANSFER`; not burned/reminted).
2. **Refund** — `max_ucu - u` from `requester.escrowed → requester.balance`.
3. **Validator fee** — `fee` from `requester.escrowed → fee_pool` (Validator/sequencer).
4. **Work-issuance** — mint `W = issuance(u)` to `provider.balance`; `supply.minted += W` (`I-ECON-ONEMINT`). `issuance(u) = ⌊issuance_rate · u⌋`, with `issuance_rate` set **below the real resource cost** of the work (`I-SEC-WASHBOUND`, [../08 §3.1](../08-security.md)).
5. **Standing** — `standing[provider].sp += accrual(u)` where `accrual(u) = ⌊sp_rate · u · efficiency_mult⌋`; This binding sets `efficiency_mult = 1.0` (no energy measurement) and `sp_rate ≈ 1 SP per 1 𝕌` ([../05 §2.1](../05-standing.md)).
6. **Bond lock** — `provider.bonded` (the claim stake) stays locked until `clawback_until = epoch + CLAWBACK_EPOCHS`.
7. Write `Receipt`; set `status: Settled` (terminal for the ledger).

After `clawback_until` with no successful challenge, the claim stake returns `bonded → balance`.

## 4. Fraud resolution & burns

On a successful audit/challenge ([03 §4](03-verification.md)) for a settled task with payment `P=u` and issuance `W`:

1. Recover `P` from `provider.bonded` → `requester.balance` (economic reversal via stake).
2. **Burn** `W`: `supply.burned += W` (`I-ECON-BACKED`).
3. Slash fine `F` from `provider.bonded`; pay `R ≤ F` to the auditor/Challenger; remainder burned.
4. `standing[provider].sp` set to floor (per [03 §4](03-verification.md)); `strikes += 1`.

Burns occur **only** here and in an optional governance fee-burn — never in ordinary settlement (`I-ECON-NOBURNSETTLE`).

## 5. Decay

At each epoch boundary, `standing[id].sp ← ⌊sp · (1 - decay_rate)⌋` for all identities (lazy evaluation using `last_decay_epoch` is permitted, provided results are identical). Decay MUST be applied deterministically before votes/weights are read (`I-STAND-DECAY`).

## 6. Consensus interface

```rust
pub trait ConsensusEngine {
    /// Order admitted txs into the next block.
    fn propose(&mut self, mempool: &[SignedTx]) -> Block;
    /// Validate + apply a block deterministically, returning the new state root.
    fn commit(&mut self, block: &Block, state: &mut State) -> Result<Hash, Reject>;
}
```

**Binding — `SingleSequencer`.** One designated node (`Block.proposer`) orders admitted txs (FIFO by arrival, ties by `TxId`), applies the §2/§3 transition in order, and computes `state_root = hash(canonical(State))` (provisional: hash of canonically-serialized sorted maps; a Merkle commitment replaces it later). Other nodes **replay** `commit` and MUST reach the identical `state_root` — this is state-machine replication, so the devnet is verifiable even with one proposer. A BFT engine (Cosmos/Substrate/custom) is a later `impl ConsensusEngine` with no change to §§1–5.

## 7. Invariants & open items

- Preserves `I-ECON-ONEMINT`, `I-ECON-TRANSFER`, `I-ECON-FINAL`, `I-ECON-BACKED`, `I-ECON-NOBURNSETTLE`, `I-STAND-*`, `I-LC-*`; adds `I-LEDGER-CONSERVE`.
- **Open / provisional:** `issuance_rate`, `fee`, `sp_rate`, `decay_rate`, `stake_base`/`discount`, `CLAWBACK_EPOCHS` (all governance params, [05 §4](05-node-and-rpc.md)); the state-commitment scheme (hash → Merkle); BFT consensus; multi-validator fee distribution.
