# DUCP Reference Node — Implementation Specification (Profile 0)

- Spec: **DUCP-SPEC 0.2.0** · Implementation **Profile 0** (MVP / devnet)
- Status: **Draft, build-ready.** Defines a concrete, buildable subset of DUCP sufficient to stand up a working node and a devnet/testnet, end to end (submit → execute → verify → settle) with real 𝕌 and Standing accounting.
- Companion: the normative spec ([../00–08](../00-overview.md)) defines *what must hold*; this profile defines *what to build first* without violating it.

## 1. What Profile 0 is

Profile 0 is the **minimum coherent node**: it accepts a task, executes it deterministically, verifies it by sampled re-execution, and settles it on a single-sequencer devnet ledger that mints 𝕌 by work-issuance and updates Standing.

**Locked engineering choices (Profile 0):**

| Concern | Profile 0 choice | Interface for later |
|---|---|---|
| IR / execution | **WebAssembly**, deterministic profile, fuel-metered (wasmtime) | `Ir` registry → add RISC-V / tensor IRs |
| Verification | **Sampled re-execution** + open challenge | `Verifier` trait → add TEE, ZK |
| Ledger / consensus | **Single-sequencer devnet** | `ConsensusEngine` trait → add BFT |
| Networking | **Direct RPC** to the sequencer | swap in P2P gossip later |
| Governance | **Static config** set by the maintainer | `07` on-chain chambers at v1.0 |
| Energy / efficiency | **Not measured** (efficiency multiplier = 1.0) | `EnergyAttestor` trait → later |

**Invariants preserved (from [../00–08](../00-overview.md)):** `I-UNIT-SAMEWORK`, `I-UNIT-ENERGYFREE`, `I-UNIT-DERIVED`, `I-UNIT-ONEBENCH`, `I-DVM-DET`, `I-VERIFY-RUNONCE`, `I-VERIFY-NOCHOICE`, `I-VERIFY-DETER`, `I-ECON-ONEMINT`, `I-ECON-TRANSFER`, `I-ECON-FINAL`, `I-ECON-BACKED`, `I-STAND-NOXFER`, `I-STAND-NOTMONEY`, `I-LC-ONCE`. Profile 0 MUST NOT violate any of these.

## 2. Out of scope for Profile 0

TEE and ZK tiers; trustless energy attestation and the efficiency bonus; production BFT consensus and P2P networking; multiple IRs; on-chain governance; auction/surge pricing; data-availability sharding. Each is represented by a trait (above) so it can be added without reshaping Profile 0. Until then, Standing's efficiency multiplier is fixed at 1.0 (no measurement, no bonus — consistent with [../05 §2.2](../05-standing.md)).

## 3. Architecture & crate map

```
                 ┌─────────────────────────── ducp-node ───────────────────────────┐
   Requester ──► │  RPC server  ─►  Scheduler/Router  ─►  Mempool                    │
   Provider  ──► │       │                │                 │                        │
   Challenger──► │       ▼                ▼                 ▼                        │
                 │  ducp-ledger ◄─── ducp-consensus ───► (block production)          │
                 │     ▲   ▲              (single sequencer)                          │
                 │     │   │                                                          │
                 │  ducp-dvm        ducp-verification        ducp-governance(params)  │
                 └──────────────────────────────────────────────────────────────────┘
```

| Component | Crate | Doc |
|---|---|---|
| Shared data model & codecs | **`ducp-types`** *(add)* | [01](01-data-model.md) |
| Wasm DVM + metering | `crates/dvm` (`ducp-dvm`) | [02](02-dvm-and-metering.md) |
| Sampled re-execution + challenge | `crates/verification` (`ducp-verification`) | [03](03-verification.md) |
| Accounts, 𝕌, Standing, settlement | `crates/ledger` (`ducp-ledger`) | [04](04-ledger-and-settlement.md) |
| Consensus engine (single-sequencer) | `crates/consensus` (`ducp-consensus`) | [04](04-ledger-and-settlement.md) |
| Parameter set (static config) | `crates/governance` (`ducp-governance`) | [05](05-node-and-rpc.md) |
| Node wiring, scheduler, RPC, keys | `node` (`ducp-node`) | [05](05-node-and-rpc.md) |

Two crates are recommended additions to the existing `ducp-node-rs` scaffold: **`ducp-types`** (the data model, depended on by all others) and an RPC module inside `ducp-node`.

## 4. Build roadmap (milestones)

| # | Milestone | Acceptance criteria |
|---|---|---|
| **M0** | Data model + codecs | `ducp-types` compiles; round-trip encode/decode + content-hash test vectors pass ([01](01-data-model.md)). |
| **M1** | Wasm DVM + metering | Execute a Wasm task deterministically; two independent runs yield identical result hash and identical 𝕌 ([02](02-dvm-and-metering.md)). |
| **M2** | Devnet ledger | Accounts, balances, escrow, Standing ledger; apply settlement transition atomically ([04](04-ledger-and-settlement.md)). |
| **M3** | End-to-end happy path | `submit → match → execute → verify(sample-off) → settle`; payment transfers + work-issuance mints + Standing updates, via RPC ([05](05-node-and-rpc.md)). |
| **M4** | Sampled re-execution + challenge | Random sampling re-executes and compares; open challenge with bond; slashing + clawback burn on mismatch ([03](03-verification.md)). |
| **M5** | Clawback window + finality | Bonded stake locked for window; fraud proven in-window → clawback + offsetting burn; settled tx never rewritten ([04](04-ledger-and-settlement.md)). |
| **M6** | Devnet + dogfood | Multi-node devnet (1 sequencer + N workers); a sample beachhead workload runs and settles repeatedly. |

## 5. Conformance (Profile 0)

A Profile 0 node is conforming when, for the same task and inputs, it (a) derives the **identical 𝕌 count** as any other conforming node, (b) produces the **bit-identical result hash**, and (c) reaches the **identical settlement and Standing outcome**. Golden test vectors are listed in [05 §5](05-node-and-rpc.md).
