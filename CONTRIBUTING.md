# Contributing to DUCP

Thank you for your interest in the Decentralized Universal Compute Protocol. DUCP
is developed in the open and improves through outside scrutiny. Critiques,
questions, and proposals are all genuinely welcome — especially adversarial ones.

Please read this guide and the [Code of Conduct](CODE_OF_CONDUCT.md) before
contributing.

## Local workspace

DUCP spans multiple repositories (`ducp-spec`, `ducp-node-rs`, and the org profile).
Clone them as **siblings** under one parent folder — see **[WORKSPACE.md](WORKSPACE.md)**
for the recommended layout.

## How DUCP is developed right now

DUCP is in its **pre-1.0 phase** (see "Status of This Document" in the white
paper and [GOVERNANCE.md](GOVERNANCE.md)). During this phase the protocol is
stewarded by its author, **Pawan Singh**, who holds final authority over the
specification while it is being shaped. Contribution is open; ownership and
direction are retained by the author until the protocol reaches a stable v1.0.
This is deliberate — it keeps the design coherent before it is set — and it is
explained in full in GOVERNANCE.md.

What that means in practice: your input is valued and will be considered on its
merits, and accepted changes are credited, but the maintainer makes the final
call on what enters the specification.

## Ways to contribute

- **Review and critique.** The most valuable contribution is a careful read and
  an honest critique. The open problems in §14 of the white paper are the best
  starting points (trustless energy attestation, formal security analysis, the
  DVM/benchmark/metering specification, cross-paradigm normalization).
- **Open an issue.** Report an error, an unclear passage, a flawed assumption, or
  a missing comparison to prior work.
- **Propose a change.** For anything substantive, follow the proposal process
  below.
- **Improve the prose or diagrams.** Editorial fixes are welcome via pull request.

## The contribution workflow

1. **Search first** to avoid duplicates.
2. **Open an issue** describing the problem or idea before doing significant
   work, so the direction can be discussed early.
3. **Discuss in the open.** Substantive decisions happen in public threads.
4. **Submit a pull request** referencing the issue. Keep changes focused; explain
   the motivation and the impact on the specification.
5. **Sign the CLA** (see below) — required before any change can be merged.
6. **Review.** The maintainer reviews, may request changes, and decides whether
   to accept. Accepted changes are recorded in [CHANGELOG.md](CHANGELOG.md) and
   reflected in the next version.

## Proposing substantive changes

For changes that affect the protocol's design — the unit, verification,
economics, governance, or anything in the locked "identity" of the protocol —
open an issue labelled **`proposal`** that states:

- **Motivation** — the problem being solved.
- **Proposal** — the change, concretely.
- **Specification impact** — what sections and mechanisms it touches.
- **Alternatives considered** — and why this one.
- **Open questions / risks.**

Proposals are discussed publicly. The maintainer summarizes the outcome and, if
accepted, the change is versioned per the policy in the white paper
(MINOR bump for substantive changes, PATCH for editorial fixes). Changes that touch
the protocol's identity-level commitments are weighed especially carefully and made in
the open; during the pre-1.0 phase they remain within the steward's authority. The
constitutional lock that protects that identity against future on-chain governance
takes effect at v1.0 (§12).

## Versioning

The public history begins at **0.1.0**. See "Status of This Document" in the
white paper for the full policy. In short: `0.MINOR.PATCH` during the
pre-implementation phase; `1.0.0` is reserved for a specification frozen against
a working reference implementation and a public testnet.

## Contributor License Agreement (required)

To keep the protocol's ownership unified during the pre-1.0 phase, **every
contribution is accepted only under the [DUCP Contributor License Agreement](CLA.md)**,
which assigns the contributed rights to the author and grants you a license back
to use your own contribution. You will be asked to agree to the CLA before your
first contribution is merged. If you are contributing on behalf of an employer,
make sure you are authorized to do so.

## Style

- Write plainly and precisely; match the white paper's voice.
- Prefer prose to bullet-soup; define terms on first use.
- Be candid about limitations — intellectual honesty is a core value of this
  project.

## Conduct

All participation is governed by the [Code of Conduct](CODE_OF_CONDUCT.md). Be
rigorous with ideas and respectful of people.

## Questions

Open an issue or reach the maintainer at mr.singhpawan@gmail.com.
