# WarScore — lightweight OpenSpec workflow

Adapted from `hectoresen/CraftAtlas` **after inspecting** its `AGENTS.md`, `openspec/config.yaml`, `openspec/README.md` and documentation-sync skill. This repo deliberately **does not** adopt CraftAtlas's two-PR enforcement, rulesets, CI status requirements, strict branch conventions, approval provenance validator or release governance.

## Lifecycle
1. **Explore**: read AGENTS.md, README.md, relevant source, docs/PVP_STATISTICS.md, docs/GENERAL_VIEW.md and docs/GENERAL_VISUAL_SPEC.md.
2. **Propose**: create `openspec/changes/<id>/proposal.md`, `design.md`, `specs/<capability>/spec.md`, `tasks.md`.
3. **Owner approval gate**: show proposal and open decisions; wait for explicit approval before changing behavior/UI.
4. **Apply**: implement approved scenarios in small steps; use current client APIs and local assets.
5. **Verify**: automated checks plus in-game screenshots/observations. `NOT RUN` is not `PASS`.
6. **Sync and close**: run `skills/documentation-sync/SKILL.md`, reconcile specs/docs, then archive accepted changes if useful. Do not archive unverified work.

The official OpenSpec CLI is optional until installed/configured locally; its generated commands depend on the installed profile. Do not claim a CLI command was run merely because these files exist. Example CLI sequence (after installing a supported Node version and `@fission-ai/openspec`): `openspec init`, `openspec list`, `openspec validate --all --strict --no-interactive` (confirm actual CLI help).

## First proposed change
`feat001-general-pvp-dashboard`: draft proposal and acceptance criteria. **Not approved, not implemented.** Implementation may begin only after owner approval. In-game verification is a separate owner/tester step.

## Sources of truth
- Implemented behavior: code + README.
- Proposed behavior: pending change under `openspec/changes/`.
- Historical statistics contract: `docs/PVP_STATISTICS.md`.
- UI target: `docs/GENERAL_VISUAL_SPEC.md`, `docs/GENERAL_VIEW.md`.
- Evidence: actual in-client diagnostics and screenshots, not mockup numbers.
