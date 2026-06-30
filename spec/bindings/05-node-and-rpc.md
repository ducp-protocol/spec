# Binding — 05 · Node, RPC, Parameters & Test Vectors

- DUCP-SPEC 0.2.0 · Reference-node binding · See [README](README.md)

## 1. Node components (`ducp-node`)

| Component | Responsibility |
|---|---|
| **RPC server** | Accepts signed transactions and read queries (§3). |
| **Mempool** | Holds admitted `SignedTx` awaiting ordering. |
| **Scheduler / Router** | Matches `Submitted` tasks to eligible Providers; tracks deadlines; enqueues sampled/forced re-executions. |
| **ConsensusEngine** | Orders txs → blocks, applies the transition, commits `state_root` ([04 §6](04-ledger-and-settlement.md)). |
| **Keystore** | Ed25519 keys; signs txs/blocks. |

A node runs in one or more **roles** ([../00 §4](../00-overview.md)); a devnet is one `SingleSequencer` plus N worker nodes (Provider/Challenger). Workers reach the sequencer over RPC (no P2P gossip in this binding).

## 2. Routing (binding)

`Submitted` tasks are offered to eligible Providers (those advertising the task's tier — all are `SampledReexec`-capable in P0). Selection is **Standing-preferred**: among available Providers, prefer higher Standing, breaking ties deterministically by `hash(task_id ‖ provider)`. (Energy-/efficiency-preferred routing activates with the energy substrate; in P0 `efficiency_mult = 1.0`, so Standing is the ordering signal.) Claiming is exclusive ([04 §2](04-ledger-and-settlement.md)).

## 3. RPC API (JSON-RPC 2.0)

State-changing methods take a `SignedTx` (the server verifies `author`, `nonce`, `sig` before admitting to the mempool). Read methods are unauthenticated.

| Method | Params | Returns |
|---|---|---|
| `ducp_submitTask` | `SignedTx(SubmitTask)` | `{ task_id, escrowed }` |
| `ducp_claimTask` | `SignedTx(ClaimTask)` | `{ ok, claim_stake }` |
| `ducp_submitProof` | `SignedTx(SubmitProof)` | `{ ok }` |
| `ducp_challenge` | `SignedTx(Challenge)` | `{ ok }` |
| `ducp_transfer` | `SignedTx(Transfer)` | `{ ok }` |
| `ducp_getTask` | `{ task_id }` | `Submission` + current `status`, `Receipt?` |
| `ducp_getAccount` | `{ id }` | `{ balance, escrowed, bonded }` |
| `ducp_getStanding` | `{ id }` | `{ sp, strikes }` |
| `ducp_getHead` | — | `{ height, state_root, epoch }` |
| `ducp_getBlock` | `{ height }` | `Block` |
| `ducp_estimateUcu` | `{ program, input, benchmark }` | `{ ucu }` (local `Dvm::meter`; advisory) |

Errors use JSON-RPC error objects; `Reject` reasons ([04 §2](04-ledger-and-settlement.md)) map to stable error codes. Binary fields (`Hash`, `ContentId`, payloads) are hex-encoded in JSON. Large payloads (`program`, `input`, `output`) are uploaded/fetched by `ContentId` via `ducp_putBlob`/`ducp_getBlob` (a simple content store in P0).

## 4. Parameters (devnet defaults — `ducp-governance`)

All values are **provisional** and held as static config in this binding; at v1.0 they become governance parameters ([../07 §4.2](../07-governance.md)). They are **not** invariants.

| Param | Symbol | Devnet default |
|---|---|---|
| Unit precision | `UCU_DECIMALS` | 9 (1 𝕌 = 10⁹ base) |
| Work-issuance rate | `issuance_rate` | 0.01 (1%), below real resource cost |
| Per-task fee | `fee` | 0.001 · `max_ucu` |
| Standing accrual | `sp_rate` | 1 SP per 1 𝕌 |
| Efficiency multiplier | `efficiency_mult` | 1.0 (no energy in P0) |
| Standing decay / epoch | `decay_rate` | 0.02 (2%) |
| Claim stake base | `stake_base` | 0.5 · `max_ucu` |
| Stake discount | `discount(sp)` | min(0.8, sp / sp_ref) reduction |
| Clawback window | `CLAWBACK_EPOCHS` | 32 |
| Audit probability | `p` | 0.10 |
| Fraud fine | `F` | 2 · `P` |
| Challenger reward | `R` | F / 2 |
| Min challenge bond | `bond_min` | 0.25 · `P` |
| Metering scale | `FUEL_PER_UCU` | calibrated from the reference workload ([02 §5](02-dvm-and-metering.md)) |

## 5. Test vectors (conformance)

Published with the reference implementation; a conforming node MUST reproduce all:

1. **Codec/hash (M0)** — for each core type, `{ value, canonical_hex, hash }`; `decode(encode(v)) == v`.
2. **Metering (M1)** — a canonical Wasm module + input with expected `{ total_fuel, ucu_count, result_hash }` under the devnet benchmark; two independent runs MUST match exactly.
3. **Settlement (M2/M3)** — an initial `State`, a sequence of `SignedTx` (submit → claim → proof), and the expected post-`State` (balances, escrowed, bonded, `supply`, `standing`) and `Receipt`.
4. **Fraud (M4/M5)** — a proof with a wrong `result_hash`, the forced re-execution outcome, and the expected post-state (clawback, burn `W`, fine `F`, Standing floor) — verifying `I-LEDGER-CONSERVE` holds across the fraud path.
5. **Replication** — applying the same block on two nodes yields the identical `state_root`.

## 6. Mapping to the build roadmap

These docs map onto the milestones in the [README §4](README.md): M0 ↔ [01](01-data-model.md); M1 ↔ [02](02-dvm-and-metering.md); M2/M3/M5 ↔ [04](04-ledger-and-settlement.md) + this doc; M4 ↔ [03](03-verification.md); M6 ↔ a multi-node devnet running a beachhead workload. Each milestone's acceptance criterion is a passing test-vector set from §5.
