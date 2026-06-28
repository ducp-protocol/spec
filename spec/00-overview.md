# DUCP Specification — Overview & Conventions

- **Spec ID:** DUCP-SPEC
- **Version:** 0.2.0 (Draft) — tracks white paper v0.2.0
- **Status:** Draft. Normative requirements are stated with the keywords in §2. Items the design has not yet settled are flagged explicitly as **Open**. This specification is **not frozen**; version **1.0.0** is reserved for a specification frozen against a working reference implementation and a public testnet.

## 1. Scope

This document set is the normative specification of the Decentralized Universal Compute Protocol (DUCP). It defines the unit, the execution environment, verification, economics, reputation, the task lifecycle, governance, and the security model precisely enough that independent implementations can interoperate.

The [white paper](../whitepaper/) is the explanatory companion. Where the white paper and this specification differ on a **normative** point, the white paper governs **until** the corresponding specification document is marked *Normative-Stable*. Until then, treat normative statements here as the project's current best formalization, open to change through the process in [`../proposals/`](../proposals/).

## 2. Requirement levels

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **MAY**, and **OPTIONAL** are to be interpreted as described in RFC 2119 and RFC 8174, and **only** when in capitals.

An **Invariant** (labeled `I-*`) is a property the protocol guarantees and that every conforming implementation MUST preserve. An **Open** item is a design question deferred to a later draft, a governance parameter, or a dependency named in the white paper's limitations (§14).

## 3. Document set

| Doc | Title | Status |
|---|---|---|
| [00](00-overview.md) | Overview & Conventions | Draft |
| [01](01-unit.md) | The Unit — 𝕌 / UCU | Draft |
| [02](02-dvm.md) | The DVM (DUCP Virtual Machine) | Draft |
| [03](03-verification.md) | Verification | Draft |
| [04](04-economics.md) | Economics & Settlement | Draft |
| [05](05-standing.md) | Standing (Reputation) | Draft |
| [06](06-task-lifecycle.md) | Task Lifecycle | Draft |
| [07](07-governance.md) | Governance & Constitution | Draft |
| [08](08-security.md) | Security Model | Draft |

## 4. Conformance

A **conforming node** MUST satisfy every MUST requirement in the documents applicable to the **roles** it performs. Roles (Provider, Requester, Challenger, Validator, Steward, Trader) define **conformance profiles**: e.g., a node performing the Provider role MUST conform to 01, 02, 03 (execution), 04 (settlement), and 06; a node performing the Validator role MUST conform to 03 (checking), 04, and 06. A node MUST NOT advertise a role whose profile it does not satisfy.

Two implementations are **interoperable** when, for the same task and inputs, they derive the same 𝕌 count, accept the same proofs/attestations, and reach the same settlement and Standing outcomes.

## 5. Versioning

This specification uses semantic versioning adapted for a specification (see the white paper, "Status of This Document"): `0.MINOR.PATCH` while pre-implementation; `1.0.0` reserved as in the Status line above. Every metered task MUST record the **benchmark version** (§01) and SHOULD record the **spec version** under which it was processed, so that historical results remain reproducible across recalibrations.

## 6. Terminology (normative)

- **𝕌 / UCU** — the Universal Compute Unit; the atomic measure of computation and the native currency (01).
- **DVM** — the DUCP Virtual Machine; the standard execution environment that runs tasks and derives 𝕌 (02).
- **IR** — intermediate representation; the portable description of a computation from which 𝕌 is metered (01).
- **Task** — a unit of requested computation with an associated 𝕌 count, escrow, and verification tier (06).
- **Proof / Attestation** — evidence that a task executed correctly: a ZK proof, a TEE attestation, or a re-execution sample (03).
- **Standing / SP** — non-transferable, earned reputation, measured in Standing Points (05).
- **Epoch** — the protocol's discrete time/round boundary at which parameter activations, decay, and settlement windows align.
- **Clawback window** — the interval after settlement during which a Provider's stake remains slashable (03, 04).
- **Benchmark** — the single consensus reference workload + standard-energy figure that fixes the scale of 𝕌 (01).

## 7. Spec-wide open items

- **Trustless energy attestation** — required for the richest efficiency rewards; no hardware provides it out of the box (white paper §14). Energy-dependent behavior in 03/05 is therefore graded and optional; **ℚ-style energy metering is Open**.
- **Consensus mechanism** — the concrete transaction-ordering/finality engine (the chain) is **Open**; this spec defines the *interfaces and invariants* settlement depends on, not the consensus algorithm.
- **Concrete parameter values** — issuance rate, fee levels, decay, caps, sampling probabilities, and similar are **governance parameters** (07); this spec fixes their *roles and bounds*, not their values.
