# DUCP Specification

This directory holds the **normative DUCP specification** as it is formalized from
the white paper into modular, versioned documents.

## Status

The authoritative description of the protocol today is the white paper
([`../whitepaper/`](../whitepaper/)), version **0.1.0**. The formal specification is
being extracted from it, one concern per document. Until a file below exists and is
marked *normative*, the white paper governs.

## Planned structure

| File | Covers (white paper §) |
|---|---|
| `00-overview.md` | Purpose, values, participants (§§1–5) |
| `01-unit.md` | The unit 𝕌 / UCU and metering (§6) |
| `02-dvm.md` | The DUCP Virtual Machine (§6.3) |
| `03-verification.md` | Layered verification (§9) |
| `04-economics.md` | Work-issuance, settlement, fees (§10) |
| `05-standing.md` | Standing reputation (§8) |
| `06-task-lifecycle.md` | Task lifecycle (§11) |
| `07-governance.md` | Governance & constitution (§12) |
| `08-security.md` | Security model (§13) |

## Versioning

Spec documents track the white paper version. Changes follow the process in
[`../CONTRIBUTING.md`](../CONTRIBUTING.md) and are recorded in
[`../CHANGELOG.md`](../CHANGELOG.md). The normative spec is frozen against a working
reference implementation and a public testnet at **v1.0.0**.
