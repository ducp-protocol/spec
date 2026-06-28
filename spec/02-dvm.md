# 02 — The DVM (DUCP Virtual Machine)

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. Scope

The DVM is DUCP's standard execution environment: a virtual machine defined by specification, into which every task loads and within which it runs. It (a) standardizes execution so behavior is independent of the host, and (b) meters information processed into 𝕌 ([01](01-unit.md)). The DVM is a **software standard**, distinct from any hardware root of trust (TEE); the two compose but answer different questions (see [03 §5](03-verification.md)).

## 2. Requirements

**2.1 Determinism.** Given the same task, IR, inputs, and DVM version, execution MUST produce identical outputs and an identical 𝕌 count on every conforming host (`I-DVM-DET`). Sources of nondeterminism (floating-point ordering, concurrency, uninitialized memory, host clocks, locale) MUST be eliminated or canonicalized by the DVM specification.

**2.2 Portability.** The DVM MUST be implementable on heterogeneous hardware (CPU, GPU, future accelerators) without changing observable behavior or the 𝕌 count. Accelerator operations MUST be credited through an IR aware of their true logical weight, not by physically metering the device.

**2.3 Metering.** The DVM MUST derive the task's 𝕌 count from the executed IR per [01 §3](01-unit.md). The count MUST be reproducible by any node from the task record.

**2.4 Isolation.** The DVM MUST isolate task execution from the host and from other tasks (no ambient access to host filesystem, network, clocks, or randomness except through declared, deterministic, metered interfaces).

**2.5 Resource accounting.** The DVM MUST enforce the task's declared limits (e.g., maximum work/𝕌, memory) and MUST terminate deterministically on breach, producing a well-defined failure result ([06 §3](06-task-lifecycle.md)).

**2.6 Verifiability.** The DVM's execution MUST be checkable under at least one verification tier ([03](03-verification.md)). Because the DVM is deterministic, any node MUST be able to re-derive a task's 𝕌 count, and (for deterministic workloads) re-execute to confirm the result.

## 3. Execution model

**3.1** A task submission references a ratified IR, the program, its declared inputs, declared limits, and the benchmark version. The DVM loads the program, executes it under §2, and emits: the result (or a deterministic failure), the derived 𝕌 count, and the execution metadata needed by the assigned verification tier.

**3.2** Inputs and outputs are content-addressed; payloads MAY be stored off-chain with their content identifiers recorded on-chain (data-availability details are **Open**).

**3.3** Randomness, where a workload requires it, MUST be supplied deterministically (e.g., a seeded, recorded source) so that `I-DVM-DET` holds. Non-deterministic workloads are out of scope for tiers that rely on re-execution and MUST be routed to a tier that does not (see [03 §3](03-verification.md)).

## 4. Composition with a hardware root of trust

When available, the DVM runs **inside** a TEE so the host can attest that the genuine DVM executed the genuine task unmodified ([03 §2](03-verification.md)). The DVM specification MUST be implementable both inside and outside a TEE with identical observable behavior and identical 𝕌 counts; TEE availability changes only *which verification tier* applies, never the result or the 𝕌 count.

## 5. Invariants

- **I-DVM-DET** — deterministic execution and 𝕌 derivation across conforming hosts.
- **I-DVM-PORTABLE** — observable behavior and 𝕌 count are host-independent.
- **I-DVM-ISOLATED** — tasks cannot observe or affect host or peer state except through declared, metered, deterministic interfaces.

## 6. Open items

The concrete DVM instruction/op model and the canonicalization rules for each ratified IR; the data-availability scheme for inputs/outputs (3.2); the formal specification of declared-limit enforcement and failure encodings (2.5). A normative DVM reference (the executable specification) is the principal deliverable gating spec **1.0.0**.
