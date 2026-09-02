---
name: dense-technical-writing
description: Write concise, information-dense technical artifacts. Use for specs, research reports, ADRs, architecture explanations, handoffs, tickets, questionnaires, and substantial agent-facing documentation. Do not use to compress teaching when repetition materially aids understanding.
---

# Dense Technical Writing

Make the artifact fast to understand and safe to act on.

## Write in decision order

1. Lead with the outcome, decision, or material finding.
2. Include only context needed to evaluate or act on it.
3. Ground claims in concrete evidence or one representative example.
4. State the strongest tradeoff, uncertainty, or remaining decision.

Distinguish **verified**, **inferred**, **proposed**, and **unresolved** information when the difference matters. Never present a draft design as settled.

## Maximize information density

- Remove throat-clearing, repeated conclusions, generic summaries, ceremonial prose, and words that do not change understanding.
- Use short, descriptive headings. Every section must answer a reader question or enable an action.
- Prefer a concrete trace, mapping, or example over an abstract inventory.
- Link to existing evidence instead of restating it. Preserve material constraints, caveats, and failure modes; concision is not omission.
- Do not target an arbitrary word count. Stop when the artifact is complete.

## Use the smallest useful visual

Add a visual only when it makes a relationship materially easier to understand:

- table for comparisons or exact mappings;
- flow for three or more dependent steps;
- timeline for state changes;
- tree for ownership or hierarchy;
- dependency graph for nontrivial blocking relationships.

Prefer portable Markdown. Use Mermaid only when the destination supports it; otherwise use a table or compact text diagram. Do not duplicate the visual line by line in prose or add decorative graphics.

## Preserve the deliverable contract

The consuming skill or repository defines required content, format, and destination. Apply this writing style within that contract; do not remove required evidence, alter authorization, or invent new scope to make the artifact cleaner.
