# 03 — Verification

- Spec: DUCP-SPEC 0.2.0 (Draft) · See [00 — Conventions](00-overview.md)

## 1. Principle: run once, check cheaply

**1.1** A task MUST be executed exactly once by its assigned Provider inside the DVM. Validating nodes MUST verify a task by **inspecting evidence** (a proof or attestation) at settlement, not by routinely re-executing it (`I-VERIFY-RUNONCE`).

**1.2** Full re-execution MUST occur only as part of the sampled-re-execution tier (§3) or when a Challenger opens a challenge (§4). In steady state, duplicate execution MUST be bounded to the sampled fraction plus open challenges.

## 2. Tiers

A task's verification **tier** determines what evidence authorizes settlement. The protocol defines the following tiers, in order of preference where eligible:

**2.1 TEE attestation (backbone).** A hardware root of trust attests that the genuine DVM executed the genuine task unmodified and produced the claimed result. Where available and permitted for the workload, this SHOULD be the default tier. The attestation MAY also carry energy measurements for efficiency rewards ([05](05-standing.md)) — but energy attestation is **Open** (white paper §14) and MUST NOT gate base settlement.

**2.2 Zero-knowledge proof (trustless complement).** The Provider produces a succinct proof of correct execution that any node verifies cheaply with no trust in hardware. Required where a workload supports it and trustlessness is demanded.

**2.3 Sampled re-execution (fallback).** For deterministic workloads without a usable TEE/ZK path, a sampled fraction of claimed tasks is re-executed by other nodes. The sampling probability `p`, fine `f`, and verifier-set size MUST satisfy the deterrence inequality (§3.2).

**2.4 Trustless spot-audits (backstop).** Independent of tier, attested results MUST face a standing, randomized probability of independent scrutiny. This is the principal defense against a compromised TEE ([08](08-security.md)).

## 3. Sampled re-execution

**3.1** Eligible only for workloads satisfying `I-DVM-DET` ([02](02-dvm.md)). Non-deterministic workloads MUST NOT be assigned this tier.

**3.2 Deterrence (`I-VERIFY-DETER`).** Parameters MUST be set so the expected penalty for submitting a fraudulent result exceeds the expected gain: informally, `p · (clawback + fine + Standing loss) > gain_from_fraud`. The concrete values are governance parameters ([07](07-governance.md)); calibrating `p`, `f`, and set size is **Open** and gates the formal security analysis (white paper §14).

## 4. Challenge protocol

**4.1** Verification is open and permissionless: **anyone MAY act as a Challenger** and contest a result.

**4.2** A Challenger MUST post an anti-spam bond. A challenge triggers re-execution / proof re-checking. If the result is shown fraudulent, the Challenger MUST be rewarded from the resulting fines/clawbacks and the Provider penalized (clawback + fine + Standing loss). If the challenge fails, the Challenger forfeits the bond.

**4.3** Challenges MUST be admissible throughout the clawback window ([04 §4](04-economics.md)). The window MUST be sized to the realistic detection horizon; a bounded residual tail risk after the window is acknowledged ([08](08-security.md)).

## 5. Software standard vs. hardware root of trust

The DVM ([02](02-dvm.md)) is a software standard that proves *what was computed* deterministically; a TEE is a hardware vendor's root of trust that attests *that the genuine software ran on a given host* and can, in principle, sign physical measurements such as energy. Correctness alone is also provable by a ZK proof, which **cannot** speak to energy. Implementations MUST NOT treat a ZK proof as evidence of energy, nor a software-only claim as evidence that unmodified code ran on an untrusted host.

## 6. Tier assignment (anti-gaming)

**6.1** The DVM MUST assign each task's tier **deterministically from its workload type at submission**. A Provider MUST NOT choose its own tier and a Requester MUST NOT specify it (`I-VERIFY-NOCHOICE`).

**6.2** The protocol MUST select the **most efficient sound tier** a workload permits. The workload-to-tier mapping is a governance parameter ([07](07-governance.md)). A consequence is **tiered participation**: a task requiring TEE attestation routes only to TEE-capable Providers.

## 7. Invariants

- **I-VERIFY-RUNONCE** — tasks execute once; nodes check evidence, not re-run, except sampling/challenges.
- **I-VERIFY-NOCHOICE** — tier is protocol-assigned by workload, never chosen by Provider or Requester.
- **I-VERIFY-DETER** — fraud is net-negative in expectation under the assigned tier.

## 8. Open items

Energy attestation (2.1); sampling/fine/set-size calibration (3.2); concrete proof/attestation object formats and the workload-to-tier mapping; spot-audit probability.
