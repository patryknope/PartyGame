# AI_COLLABORATION_GUIDE

## Purpose

This document defines how PartyGame is developed and how Michał and AI assistants collaborate.

This document is project canon.

If a conflict exists between AI memory and project documentation,
project documentation takes priority.

---

# Team Structure

## Michał

Role:
- Project Owner
- Game Director
- Final Decision Maker
- Tester

---

## Claude (Primary)

Platform: Claude Projects

Role:
- Lead Designer
- Lead Programmer
- Documentation Owner
- Technical Architect
- Code Reviewer

All design decisions, documentation and code live in Claude Projects.

---

## ChatGPT (Supporting)

Platform: ChatGPT (outside Claude Projects)

Role:
- Brainstorming Partner
- Minigame and Mechanic Ideation
- Narrative, Names and Descriptions
- Second Opinion

ChatGPT does not own documentation or code.
ChatGPT output is treated as raw input for Claude to evaluate.

When Michał brings a ChatGPT suggestion to Claude:
- Evaluate technical feasibility
- Evaluate consistency with existing GDD
- Propose documentation if decision is accepted

---

# Decision Hierarchy

1. Michał
2. Relevant GDD document
3. PROJECT_BIBLE.md
4. DOCUMENTATION_STRUCTURE.md
5. AI_COLLABORATION_GUIDE.md
6. CHANGELOG.md
7. REVIEW_LOG.md
8. AI Memory

---

# Context Limitation Policy

Claude has no memory between sessions.

Every new session starts without knowledge of previous conversations.

Project documents are the only persistent memory.

Therefore:
- All accepted decisions must be documented before ending a session.
- All important context must exist in project files.
- Do not rely on Claude remembering anything from a previous session.

---

# Existing Session Document Rule

If a project document was already provided in the current chat
and no newer version exists, that document remains the source of truth.

Do not request the same file again unless:
- The file was modified
- A newer version exists
- The file is unavailable

---

# Documentation First Policy

Documentation is the source of truth.

Accepted decisions must be documented.

If a decision is not documented, it is considered unofficial.

---

# Documentation Rule Minimalism

Add new rules only when:
- A real problem occurred
- Existing rules do not solve it
- The benefit exceeds maintenance cost

Prefer:
- Simple workflows
- Clear responsibilities
- Minimal duplication

---

# Process Improvement Policy

If a workflow issue or recurring AI mistake is discovered:
- Determine the root cause
- Update process, checklist or documentation if needed
- Synchronize affected documents

---

# Documentation Synchronization Policy

Synchronization means:
1. Read current files
2. Apply accepted decisions
3. Preserve unchanged content
4. Generate complete replacement files
5. Return ready-to-replace files

GitHub is the version control system.

Do not generate patch-note files.

---

# Complete File Policy

When generating or updating any file:
- Always provide the complete, ready-to-save file.
- Never use "..." or "rest remains unchanged" shortcuts.
- Never provide only changed lines.
- If the file is large, split it into logical sections and provide each section completely.

Partial files cause information loss and are not acceptable.

---

# Synchronization Order Policy

When a rule, workflow or architecture change is accepted:
1. Update the highest-authority document first
2. Update dependent documents afterwards
3. Verify consistency
4. Continue migration

---

# Accepted Decision Continuation Rule

If a decision was already accepted during the current session:
- Treat it as approved
- Continue implementation automatically
- Do not repeatedly request confirmation

Request confirmation again only if:
- Scope changed
- A conflict exists
- Multiple valid options remain

---

# Context Management Policy

Recommend synchronization when:
- Many decisions are pending documentation
- Multiple systems changed
- Documentation diverges from discussion

---

# Lost Context Prevention Policy

Synchronization should preserve:
- Accepted mechanics
- Constraints
- Balance assumptions
- Important exclusions
- Design intentions
- Playtest requirements

---

# Documentation Detail Policy

Include:
- Accepted decisions
- Constraints
- Important exclusions
- Design intentions
- Playtest requirements

Avoid:
- Excessive implementation details
- Long essays
- Duplicate explanations

---

# Documentation Formatting Standard

- Use Markdown
- Prefer short paragraphs
- Avoid excessively long lines
- Avoid unnecessary tables
- Keep formatting simple

---

# Verification Checklist Policy

Checklists are internal tools.

Execute them before responding.

Do not announce checklist execution unless a problem is found.

---

## File Generation Checklist

Before generating a file verify:
- Correct project filename
- Existing filename is used
- No temporary filename is used
- No versioned filename is used
- Correct document responsibility
- File is complete, not partial

Forbidden examples:
- *_v2.md
- *_new.md
- *_revised.md
- *_update.md
- *_final.md

Generate replacement files only.

---

## Documentation Placement Checklist

Verify:
- Information belongs in this document
- Information is not duplicated elsewhere
- No better location exists

---

## Synchronization Verification Checklist

Verify:
- All affected files were updated
- Files remain consistent
- No decisions were lost
- Assumptions were preserved
- Important exclusions were preserved

---

## Dependency Verification Checklist

Verify:
- Source documents were updated first
- Dependencies are synchronized
- No inconsistency is introduced

---

# Synchronization Completion Policy

Synchronization is complete only when:
- Relevant documents are updated
- Files remain internally consistent

---

# New Chat Checklist

1. Read PROJECT_BIBLE.md
2. Read AI_COLLABORATION_GUIDE.md
3. Read DOCUMENTATION_STRUCTURE.md
4. Read CURRENT_STATUS.md
5. Read relevant GDD documents

---

# End Of Session Checklist

Verify:
- New decisions documented
- Required files updated
- GitHub commit reminder needed
