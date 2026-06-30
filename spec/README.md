# DUCP Specification

The normative DUCP specification — **DUCP-SPEC v0.2.0 (Draft)** — formalized from the white paper into modular, versioned documents. Start with **[00 — Overview & Conventions](00-overview.md)**.

## Status

This is a **Draft**. Requirements are normative where stated with RFC-2119 keywords (MUST / SHOULD / MAY — see [00 §2](00-overview.md)); design questions not yet settled are flagged **Open** in each document, rather than given false precision. Where a normative point here and the [white paper](../whitepaper/) differ, the white paper governs until the relevant document is marked *Normative-Stable*. Version **1.0.0** is reserved for a specification frozen against a working reference implementation and a public testnet.

## Documents

| Doc | Title | Covers (white paper §) |
|---|---|---|
| [00](00-overview.md) | Overview & Conventions | conventions, conformance, versioning, terminology |
| [01](01-unit.md) | The Unit — 𝕌 / UCU | the unit, the IR, metering, the benchmark (§6) |
| [02](02-dvm.md) | The DVM | execution environment & metering (§6.3) |
| [03](03-verification.md) | Verification | tiers, assignment, challenge protocol (§9) |
| [04](04-economics.md) | Economics & Settlement | work-issuance, settlement, finality (§10) |
| [05](05-standing.md) | Standing | reputation: accrual, decay, weighting (§8) |
| [06](06-task-lifecycle.md) | Task Lifecycle | the five stages, failure, patterns (§11) |
| [07](07-governance.md) | Governance & Constitution | chambers, weighting, locked core (§12) |
| [08](08-security.md) | Security Model | threats, defenses, invariants (§13) |
| [09](09-efficiency-observable.md) | The Efficiency Observable (ℚ) | reward-neutral ℚ recording & energy attestation (DP-0001; §§6/8/9 → v0.2.0) |

All documents are currently **Draft**. Each ends with an **Open items** section listing what remains.

## Bindings (reference-node)

The **[reference-node binding specification](bindings/)** pins the concrete engineering choices for the first interoperable node — **WebAssembly** IR, **single-sequencer devnet**, **sampled re-execution** — while preserving every invariant above and putting TEE/ZK/energy/BFT behind interfaces. It includes a milestone roadmap (M0–M6), conformance test vectors, and a crate map for the [`ducp-node-rs`](https://github.com/ducp-protocol/ducp-node-rs) reference implementation. Start at [`bindings/README.md`](bindings/README.md).

| Doc | Title |
|---|---|
| [bindings/01](bindings/01-data-model.md) | Data Model & Encoding |
| [bindings/02](bindings/02-dvm-and-metering.md) | The DVM (WebAssembly) & Metering |
| [bindings/03](bindings/03-verification.md) | Verification (Sampled Re-execution) |
| [bindings/04](bindings/04-ledger-and-settlement.md) | Ledger, Settlement & Consensus |
| [bindings/05](bindings/05-node-and-rpc.md) | Node, RPC, Parameters & Test Vectors |

## How to contribute

Substantive changes start as a proposal in [`../proposals/`](../proposals/) and follow [`../CONTRIBUTING.md`](../CONTRIBUTING.md). The highest-value work is in the **Open items** — especially the executable **DVM reference**, the **metering/benchmark** formalization, **trustless energy attestation**, and the **formal security analysis** (sampling, slashing, the wash-trading bound). These gate **1.0.0**.

## Versioning

Spec documents track the white paper version; changes are recorded in [`../CHANGELOG.md`](../CHANGELOG.md).
