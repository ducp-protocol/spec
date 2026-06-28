# DUCP Governance

This document describes **how decisions about DUCP are made today**, and **how
governance is designed to change** as the protocol matures. It complements §12
("Governance") of the white paper, which describes the protocol's eventual
on-chain governance.

## Guiding principle

DUCP's design principle — **identity locked, mechanics flexible** — describes the
protocol's *destination*. At and after v1.0, the constitution locks what the protocol
*is* — its purpose, core values, the definition of the unit, work-backing,
unit-is-currency, non-transferable reputation, and democratic self-rule — while leaving
mechanics tunable through on-chain governance.

**During the pre-1.0 phase the design is still being shaped, so nothing is
constitutionally locked yet.** The steward may revise any part of the protocol —
including its identity-level commitments — in the open; the lock takes effect only with
the v1.0 constitution. The identity above is what the protocol *intends* to lock at v1.0
and treats as stable in the meantime — a signal to build on, not a pre-1.0 handcuff.

## Phase 1 — Pre-1.0: single steward

While DUCP is pre-1.0, the project is governed by a single steward.

- **Steward / maintainer:** Pawan Singh (the author).
- **Authority:** The steward holds final decision authority over the
  specification, the white paper, the roadmap, licensing, and the marks — and,
  because the design is not yet frozen, over the protocol's identity-level
  commitments as well. No part of the protocol is locked against revision during
  this phase; the locked core begins at v1.0 (Phase 2).
- **Why:** A coherent protocol identity is easier to shape with one hand on the
  tiller before the design is frozen. This is a deliberate, time-bounded phase,
  not the protocol's end state.
- **How decisions are made:** Anyone may open issues and proposals (see
  [CONTRIBUTING.md](CONTRIBUTING.md)). Substantive proposals are discussed in the
  open; the steward weighs the discussion and decides. Decisions and their
  rationale are recorded publicly.
- **Ownership:** Contributions are accepted under the [CLA](CLA.md), which
  assigns rights to the steward, keeping ownership unified through this phase.

Contributors are recognized in the changelog and release notes. Trusted,
sustained contributors may be invited to act as reviewers or co-maintainers at
the steward's discretion, but final authority remains with the steward until the
transition below.

## Phase 2 — The transition at v1.0

Version 1.0.0 is reserved for a specification frozen against a working reference
implementation and a public testnet. Reaching v1.0 is also the trigger for
governance to begin devolving from the steward to the protocol's participants.

At and after v1.0, DUCP is designed to adopt the **reputation-weighted,
role-chamber governance** described in §12 of the white paper:

- voting power derived from earned, non-transferable **Standing** (never from
  holdings), square-root weighted, per-entity capped, and decaying;
- **role chambers** (Providers, Requesters, Challengers, Validators, Traders)
  with cross-chamber approval required to pass changes;
- a **constitution** that locks the protocol's identity while leaving mechanics
  tunable through a public, on-chain proposal process.

The steward intends to define and publish the concrete handover — what authority
moves on-chain, in what order, and on what schedule — as part of the v1.0
process. The intent is a genuine transfer of control to the community of
contributors, not a permanent stewardship.

## Amending this document

During Phase 1, this governance document may be updated by the steward, with
changes recorded in [CHANGELOG.md](CHANGELOG.md). After the Phase 2 transition,
governance changes follow the on-chain process above.

## Contact

Pawan Singh — mr.singhpawan@gmail.com — linkedin.com/in/singhpawanpreet
