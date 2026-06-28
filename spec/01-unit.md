# 01 — The Unit (𝕌 / UCU)

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. Definition

**1.1** One **𝕌** (written **UCU** in plain text) MUST represent a quantity of *information processed*, normalized to a single consensus **reference benchmark** (§4) expressed as information processed per standard unit of energy.

**1.2** A task's 𝕌 count MUST be a **deterministic function of the logical work** the task performs over a portable intermediate representation (§2), and MUST NOT depend on the Provider's actual energy draw, hardware, wall-clock time, or location.

**1.3** 𝕌 is simultaneously the unit of computation and the native currency (see [04](04-economics.md)). There MUST NOT be a separate token, gas asset, or governance coin.

**1.4** 𝕌 is divisible. The number of decimal places (the smallest representable subdivision) is a fixed protocol constant — **Open** (proposed: a fixed integer base-unit count, set once and constitutionally locked to avoid silent redenomination).

## 2. The intermediate representation (IR)

**2.1** A computation MUST be expressed in a ratified IR before it is metered. A valid IR MUST satisfy: **determinism** (identical inputs → identical outputs and identical 𝕌 count on any conforming host), **portability** (substrate-independent), **meterability** (its operations have well-defined logical weights), and **verifiability** (its execution can be checked under at least one tier in [03](03-verification.md)).

**2.2** The set of ratified IRs is a governance parameter ([07](07-governance.md)). Each ratified IR MUST be normalized to one common value reference such that **equivalent logical work yields equivalent 𝕌 across IRs** (`I-UNIT-CROSSIR`).

**2.3** Adding, modifying, or retiring an IR MUST preserve `I-UNIT-CROSSIR` and is a constitutionally constrained act (supermajority + timelock, [07](07-governance.md)). Changing an IR MUST NOT change what one 𝕌 is worth.

**2.4** The concrete per-IR metering function (the map from IR operations to logical weights) is **Open** for each IR and is ratified with that IR. It MUST be deterministic and reproducible by any node from the task record alone.

## 3. Metering

**3.1** The 𝕌 count for a task MUST be **derived by the protocol** (computed by the DVM, [02](02-dvm.md)), never reported or chosen by a participant (`I-UNIT-DERIVED`).

**3.2** Given the same task, IR, and benchmark version, every conforming node MUST derive the identical 𝕌 count.

## 4. The reference benchmark

**4.1** There MUST be exactly one benchmark constant in effect at a time, recorded on-chain and shared by all nodes (`I-UNIT-ONEBENCH`). No participant may hold a private value of the benchmark.

**4.2** The benchmark MUST be defined by specification — a canonical reference workload executed on the DVM whose deterministic information-count is paired with a single standard-energy figure — and MUST NOT be defined by any particular physical device.

**4.3** The benchmark's **methodology** (how the reference workload and standard-energy figure are defined and calibrated) is part of the constitution and MUST NOT be altered by ordinary vote. Only the **data inputs** update, through the locked methodology.

**4.4** A benchmark update MUST activate network-wide at a synchronized epoch boundary, and every task MUST record the benchmark version under which it was metered.

**4.5** Calibration draws on reproducible, attested reference runs and frontier-efficiency data. The concrete calibration procedure and the resulting constant are **Open** (they depend on the attested-measurement substrate; see [03 §6](03-verification.md) and white paper §14). One 𝕌 is therefore **frontier-relative**, not a fixed absolute quantity of work for all time; the locked methodology + synchronized versioning bound that movement.

## 5. Invariants

- **I-UNIT-SAMEWORK** — identical logical work yields identical 𝕌 on any hardware.
- **I-UNIT-ENERGYFREE** — the 𝕌 count is independent of actual energy, hardware, time, and location.
- **I-UNIT-CROSSIR** — equivalent work yields equivalent 𝕌 across all ratified IRs.
- **I-UNIT-DERIVED** — 𝕌 is protocol-derived, never self-reported.
- **I-UNIT-ONEBENCH** — exactly one on-chain benchmark constant is in effect at a time.

## 6. Open items

Unit precision (1.4); per-IR metering functions (2.4); benchmark calibration procedure and constant (4.5).
