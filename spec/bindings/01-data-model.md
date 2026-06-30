# Binding — 01 · Data Model & Encoding

- DUCP-SPEC 0.2.0 · Reference-node binding · See [README](README.md)

Types are shown in Rust syntax for precision; they define the **canonical data model** every conforming node shares (crate `ducp-types`). Field encodings are normative for interoperability.

## 1. Encoding & hashing conventions

- **Canonical bytes.** Every hashed or signed structure MUST have a single canonical byte encoding. This binding uses deterministic length-prefixed encoding (provisional: `borsh`); fields are encoded in declaration order. No floats appear in any hashed structure.
- **Hash.** `Hash = [u8; 32]`, BLAKE3-256 of the canonical bytes (binding-provisional).
- **Content addressing.** `ContentId = Hash` of a payload's canonical bytes. Large payloads (inputs/outputs) MAY live off-ledger; only their `ContentId` is on-ledger.
- **Identity & signatures.** `Identity = PublicKey` (Ed25519, 32 bytes, P0). `Signature = [u8; 64]` (Ed25519). Every transaction MUST be signed by its author.
- **Amounts.** `Ucu = u128` base units. This binding fixes **1 𝕌 = 10⁹ base units** (`UCU_DECIMALS = 9`); this precision is binding-provisional pending the locked value ([../01 §1.4](../01-unit.md)). All monetary math is integer; no rounding except where explicitly specified.
- **Standing.** `Sp = i128` base points, same scale as `Ucu`.
- **Time.** `Epoch = u64`. This binding has no wall-clock dependence in metering; epochs advance per block batch (config).

## 2. Identifiers

```rust
pub type Hash = [u8; 32];
pub type Identity = [u8; 32];      // Ed25519 public key
pub type Signature = [u8; 64];
pub type ContentId = Hash;         // hash of a payload
pub type TaskId = Hash;            // = hash(canonical(Submission.body))
pub type TxId = Hash;              // = hash(canonical(SignedTx))
pub type Ucu = u128;               // base units; 1 UCU = 1e9
pub type Sp  = i128;               // Standing points, base scale
pub type Epoch = u64;
pub type BenchmarkVersion = u32;
```

## 3. Tasks

```rust
/// What a Requester asks for. Hashed → TaskId.
pub struct TaskBody {
    pub ir: IrId,                  // binding: IrId::WASM
    pub program: ContentId,        // the Wasm module bytes
    pub input: ContentId,          // canonical input payload
    pub limits: Limits,            // declared resource caps
    pub tier: VerificationTier,    // ASSIGNED by the DVM at submit, not chosen (I-VERIFY-NOCHOICE)
    pub benchmark: BenchmarkVersion,
    pub deadline: Epoch,
    pub failure_policy: FailurePolicy,
    pub nonce: u64,                // Requester-unique
}

pub enum IrId { WASM = 0 }         // This binding has exactly one IR

pub struct Limits {
    pub max_ucu: Ucu,              // hard ceiling on metered work
    pub max_memory_bytes: u64,
}

pub enum VerificationTier { SampledReexec = 0 /* P0 */, Tee = 1, Zk = 2 }
pub enum FailurePolicy { AutoRequeue, ReturnOnFailure, RetryThenReturn { retries: u8 } }
```

The metered `ucu_count` is **not** part of `TaskBody`; it is derived by the DVM ([02](02-dvm-and-metering.md)) and recorded in the `Submission`.

## 4. On-ledger records

```rust
/// Created at Submit. The Requester escrows `ucu_count + fee`.
pub struct Submission {
    pub task: TaskId,
    pub requester: Identity,
    pub ucu_count: Ucu,            // protocol-derived (I-UNIT-DERIVED)
    pub fee: Ucu,
    pub status: TaskStatus,
    pub provider: Option<Identity>,
    pub claim_stake: Ucu,          // Standing-discounted (set at Match)
}

pub enum TaskStatus { Submitted, Matched, Executing, Verified, Settled, Failed }

/// The Provider's evidence (binding: sampled-reexec tier).
pub struct ComputeProof {
    pub task: TaskId,
    pub provider: Identity,
    pub output: ContentId,         // result payload
    pub result_hash: Hash,         // hash(canonical(output)) — the comparison key
    pub ucu_count: Ucu,            // provider's claim; MUST equal protocol re-derivation
    pub benchmark: BenchmarkVersion,
    // tier-specific evidence:
    pub tier_data: TierData,
}

pub enum TierData {
    SampledReexec,                 // P0: nothing extra; determinism enables exact re-check
    Tee { attestation: Vec<u8> },  // reserved
    Zk { proof: Vec<u8> },         // reserved
}

/// Final settlement effect (recorded at Settle; immutable, I-ECON-FINAL).
pub struct Receipt {
    pub task: TaskId,
    pub paid_to_provider: Ucu,     // = ucu_count (transferred from escrow)
    pub work_issuance: Ucu,        // newly minted (I-ECON-ONEMINT)
    pub validator_fee: Ucu,
    pub standing_delta: Sp,        // Provider Standing change
    pub settled_epoch: Epoch,
    pub clawback_until: Epoch,     // bonded stake locked until here
}
```

## 5. Accounts & Standing

```rust
pub struct Account {
    pub id: Identity,
    pub balance: Ucu,              // spendable 𝕌
    pub escrowed: Ucu,             // locked in open tasks (Requester)
    pub bonded: Ucu,              // stake locked in clawback windows (Provider)
}

/// Separate, non-spendable ledger (I-STAND-NOTMONEY).
pub struct StandingRecord {
    pub id: Identity,
    pub sp: Sp,                    // current Standing
    pub last_decay_epoch: Epoch,
    pub strikes: u32,              // escalating-penalty counter
}
```

Standing is recorded on its own ledger keyed by `Identity`; there MUST be no operation that converts `sp ↔ balance` (`I-STAND-NOTMONEY`, `I-STAND-NOXFER`).

## 6. Transactions & blocks

```rust
pub enum Tx {
    SubmitTask(TaskBody),                 // Requester; escrows funds
    ClaimTask { task: TaskId },           // Provider; posts stake
    SubmitProof(ComputeProof),            // Provider
    Challenge { task: TaskId, bond: Ucu },// Challenger
    Transfer { to: Identity, amount: Ucu },
}

pub struct SignedTx { pub author: Identity, pub tx: Tx, pub nonce: u64, pub sig: Signature }

pub struct Block {
    pub height: u64,
    pub parent: Hash,
    pub epoch: Epoch,
    pub txs: Vec<TxId>,            // ordered by the sequencer (consensus, [04])
    pub state_root: Hash,         // commitment to ledger state after applying txs
    pub proposer: Identity,       // P0: the single sequencer
}
```

## 7. Determinism & test vectors

- All encode/decode MUST be canonical and reversible; `decode(encode(x)) == x`.
- `TaskId`, `TxId`, `ContentId`, and `state_root` MUST be reproducible byte-for-byte across implementations.
- Conformance (M0): a fixture set of `{structure, canonical_bytes_hex, hash}` golden vectors MUST be published with the reference implementation and pass on any conforming codec.

## 8. Open / provisional

Codec choice (`borsh`), hash (BLAKE3), signature scheme (Ed25519), and `UCU_DECIMALS = 9` are binding-provisional and may be fixed differently at 1.0; the **shapes and invariants** above are stable.
