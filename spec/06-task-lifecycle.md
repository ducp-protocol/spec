# 06 — Task Lifecycle

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. The five stages

Every task MUST proceed through the following stages, each producing an on-chain artifact. The stages form a state machine: `Submitted → Matched → Executing → Verified → Settled`, with transitions to `Failed` / `Requeued` per §3.

**1.1 Submit.** The Requester defines a task (IR reference, program, declared inputs, declared limits, deadline). The DVM compiles it, **deterministically assigns its verification tier** from the workload type ([03 §6](03-verification.md)), and meters its 𝕌 count ([01](01-unit.md)). The Requester MUST escrow payment in 𝕌 (the metered count plus fees). Artifact: the task record (with benchmark version).

**1.2 Match.** The task is routed to a Provider. Efficiency-preferred routing is the default; an auction governs allocation under congestion ([04 §6](04-economics.md)). The Provider MUST post a Standing-discounted stake ([05 §3.2](05-standing.md)) to claim it. Artifact: the claim.

**1.3 Execute.** The Provider runs the task **once** inside the DVM on the path its tier requires (TEE / ZK / deterministic-for-sampling). Artifact: the result + the tier's evidence (proof/attestation).

**1.4 Verify.** Every node checks the proof/attestation cheaply at settlement ([03 §1](03-verification.md)). Challengers MAY contest. Artifact: the verification record.

**1.5 Settle (instant).** On valid evidence, settlement is final ([04 §4](04-economics.md)): payment transfers to the Provider, work-issuance mints new 𝕌, the Validator fee is paid, and Standing updates. The Provider's stake remains bonded through the clawback window. Artifact: the settlement record.

## 2. State invariants

- **I-LC-ESCROW** — a task MUST NOT enter `Matched` without escrowed payment covering its metered 𝕌 + fees.
- **I-LC-ONCE** — a task MUST be executed exactly once absent a sampling/challenge re-execution ([03](03-verification.md)).
- **I-LC-FINAL** — `Settled` is terminal for the ledger; only bonded stake remains slashable in the clawback window.

## 3. Failure handling

DUCP separates two questions: what happens to the Requester's task, and what happens to the Provider who failed it.

**3.1 Requester-configurable fate.** A failed or timed-out task MUST follow the Requester's per-task policy: **auto-requeue** (default), **return-on-failure**, or **retry-then-return**, with OPTIONAL deadline and cost caps. Auto-requeue moves the task to another Provider; escrow handling MUST follow the chosen policy.

**3.2 Negligence-only, statistical accountability.** Provider accountability MUST NOT be waivable by a Requester. A single honest failure MUST NOT be punished; negligence and repeated failure MUST be. The protocol MUST distinguish them **without adjudicating intent**, using the reliability component of Standing and the resilience buffer ([05 §3.4](05-standing.md)): an occasional failure is absorbed by the buffer; a pattern of failure erodes reliability Standing, which mechanically lowers routing priority and escalates penalties. Judgment MUST be by frequency, not intent (`I-LC-NOINTENT`).

## 4. Task patterns

Implementations MUST support these submission patterns; deadlines are part of the task spec and enforced through reliability Standing:

- **Single** — one task, one 𝕌 count, one escrow.
- **Batch** — many independent tasks in one submission, claimable by different Providers.
- **Streaming** — a continuous flow drawing from a pre-deposited reserve rather than per-task escrow.
- **Pipeline** — chained tasks where one output feeds the next, each step settling independently (the Requester bears partial-completion risk).

## 5. Open items

The on-chain artifact encodings and the canonical state-machine transition table; escrow accounting rules per failure policy; streaming reserve mechanics; deadline representation and enforcement bounds.
