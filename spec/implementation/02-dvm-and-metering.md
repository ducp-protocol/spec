# Profile 0 — 02 · The DVM (WebAssembly) & Metering

- DUCP-SPEC 0.2.0 · Profile 0 · See [README](README.md) · normative parent [../02](../02-dvm.md)

The Profile 0 DVM is a **deterministic WebAssembly runtime** that executes a task once and derives its 𝕌 count by fuel metering. Reference runtime: **wasmtime** (Rust). Crate: `ducp-dvm`.

## 1. Accepted module format

- A task program is a single Wasm module (`ContentId` → bytes). It MUST validate against the Wasm core spec under the **Profile 0 feature set**:
  - **Allowed:** MVP core, `mutable-globals`, `sign-extension`, `nontrapping-float-to-int`, `bulk-memory`, `multi-value`.
  - **Forbidden (Profile 0):** `threads`/atomics, `simd` (until canonicalization is specified), `reference-types`/`gc`, `exception-handling`, any nondeterministic proposal.
- A module using a forbidden feature MUST be rejected at submit with `Reject(UnsupportedFeature)` — it never reaches metering.

## 2. Determinism profile (`I-DVM-DET`)

The runtime MUST be configured so execution is bit-identical across hosts:

1. **NaN canonicalization ON** (Cranelift `nan_canonicalization`) — the one IEEE-754 nondeterminism source in Wasm is removed.
2. **Single-threaded**, no atomics, no shared memory.
3. **No ambient capabilities:** no clock, no randomness, no filesystem, no network. The only host imports are the deterministic ABI in §3.
4. **Deterministic resource limits:** fixed initial memory, fixed `max_memory_bytes`; growth beyond the limit traps deterministically.
5. **No host-observable iteration order, addresses, or timing** may influence outputs.

Given the same `{module, input, benchmark}`, every conforming DVM MUST produce the identical `output`, `result_hash`, and `ucu_count`.

## 3. Host ABI (Profile 0)

A minimal, deterministic import namespace `ducp`:

```wat
(import "ducp" "input_len"  (func (result i32)))
(import "ducp" "input_read" (func (param i32 i32 i32) (result i32))) ;; (dst, offset, len) -> bytes_read
(import "ducp" "output_write" (func (param i32 i32)))                ;; (src, len) -> append to output
(import "ducp" "fail"        (func (param i32)))                     ;; (code) -> deterministic abort
```

- `input_*` expose the task's `input` payload (content-addressed).
- `output_write` appends to an output buffer; the final buffer's canonical bytes are content-addressed to `output` and hashed to `result_hash`.
- No other imports are permitted. Logging, if added, MUST NOT affect `output`, `result_hash`, or `ucu_count`.

## 4. Metering → 𝕌

**4.1** The runtime meters execution in **fuel**: a deterministic, integer cost is charged per executed instruction from a fixed **cost table** `fuel_cost: Opcode → u64` (the per-IR metering function, [../01 §2.4](../01-unit.md)). Profile 0 ships a concrete table (provisional): most core ops cost `1`; memory ops and calls cost more; the table is content-hashed and recorded with the benchmark so it is reproducible.

**4.2** Let `total_fuel` be the fuel consumed by the run. The **𝕌 count** is:

```
ucu_count = (total_fuel * UCU_SCALE) / FUEL_PER_UCU      // integer division, deterministic
```

where `FUEL_PER_UCU` is a constant fixed by the **benchmark** (§5) and `UCU_SCALE = 10^UCU_DECIMALS` (= 10⁹). `ucu_count` depends only on `total_fuel` and the benchmark — never on wall-clock time, host, or energy (`I-UNIT-ENERGYFREE`, `I-UNIT-DERIVED`).

**4.3** The Provider's claimed `ucu_count` in the `ComputeProof` MUST equal the protocol's re-derivation; any mismatch is treated as fraud ([03](03-verification.md)).

## 5. The benchmark (Profile 0)

- Exactly one benchmark is in effect, recorded on-ledger (`I-UNIT-ONEBENCH`): `{ version, fuel_cost_table_hash, FUEL_PER_UCU, e_std_nominal }`.
- `FUEL_PER_UCU` is calibrated from a **canonical reference workload** (a fixed Wasm module + input shipped with the spec): run it under the cost table, obtain `fuel_ref`, and define `FUEL_PER_UCU = fuel_ref / UCU_REF` for a declared reference count `UCU_REF`. Profile 0 sets `UCU_REF` and thus `FUEL_PER_UCU` as a devnet constant (provisional).
- `e_std_nominal` is a **nominal** standard-energy figure recorded for forward-compatibility; Profile 0 does **not** measure energy, so it does not affect `ucu_count` or rewards. Real calibration against the efficiency frontier is deferred ([../01 §4.5](../01-unit.md)).
- A benchmark change activates at an epoch boundary and every task records its `benchmark` version.

## 6. Limits & failure

- `Limits.max_ucu` is converted to a fuel ceiling `max_fuel = max_ucu * FUEL_PER_UCU / UCU_SCALE`. Exhausting it MUST trap deterministically → `Failure(OutOfFuel)`.
- Exceeding `max_memory_bytes`, executing an illegal instruction, or calling `ducp.fail(code)` MUST produce a deterministic `Failure(kind)`.
- A failure is still a deterministic outcome: it has a canonical `result_hash` (over the failure kind) and a `ucu_count` equal to the fuel consumed up to the trap. Failure handling (requeue/return) is [04](04-ledger-and-settlement.md)/[../06](../06-task-lifecycle.md).

## 7. Interface (crate `ducp-dvm`)

```rust
pub struct ExecOutcome {
    pub result_hash: Hash,
    pub output: Vec<u8>,        // content-addressed by caller
    pub ucu_count: Ucu,
    pub status: ExecStatus,     // Ok | Failure(FailureKind)
}

pub trait Dvm {
    /// Deterministic: identical (module,input,benchmark) → identical ExecOutcome on any host.
    fn execute(&self, module: &[u8], input: &[u8], limits: &Limits, benchmark: &Benchmark) -> ExecOutcome;
    /// Re-derive the 𝕌 count only (used by verifiers and at submit).
    fn meter(&self, module: &[u8], input: &[u8], benchmark: &Benchmark) -> Ucu;
}
```

`execute` is called once by the Provider; `meter`/`execute` are called by re-executors during sampling/challenge ([03](03-verification.md)). Because both are deterministic, comparison is exact.

## 8. Invariants & open items

- Preserves `I-DVM-DET`, `I-DVM-PORTABLE`, `I-DVM-ISOLATED`, `I-UNIT-SAMEWORK`, `I-UNIT-ENERGYFREE`, `I-UNIT-DERIVED`, `I-UNIT-ONEBENCH`.
- **Open / provisional:** the concrete `fuel_cost` table values; `FUEL_PER_UCU` / `UCU_REF`; the canonical reference workload bytes; SIMD support (needs a canonicalization rule before enabling). These are tuned on devnet and frozen toward 1.0.
