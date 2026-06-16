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

## ChatGPT — Lead Designer (55%)

Platform: ChatGPT (outside Claude Projects)

Role:
- Lead Designer
- Mechanical design and ideation
- Concept art direction
- Primary design force

ChatGPT has access to project files.
ChatGPT does not own documentation or code.

---

## Claude — Co-Designer + Documentation Owner

Platform: Claude Projects

Role:
- Co-Designer (45% design)
- Documentation Owner
- Primary communication hub with Michał
- Evaluates ChatGPT suggestions for feasibility and GDD consistency
- Generates ChatGPT consultation prompts

All documentation lives in Claude Projects.
All decisions are recorded here.

---

## Claude Code — Lead Programmer

Role:
- Lead Programmer
- Technical Architecture
- Code Review
- GDScript / Godot 4 implementation

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

# Design Workflow

The workflow between Claude and ChatGPT functions as a design review, not an expert consultation.

Each brings a different perspective:
- Claude evaluates through the lens of project consistency, architecture and documentation.
- ChatGPT questions assumptions, proposes alternatives and seeks compromises.

Combining these perspectives consistently leads to better decisions than using either source alone.

## Standard Flow

1. Topic is discussed with Claude
2. Claude generates a ChatGPT consultation prompt in a code block
3. Michał copies prompt and pastes ChatGPT response back to Claude
4. Claude evaluates response and proposes documentation
5. Michał makes final decision
6. Claude documents accepted decisions

Consultation can be skipped when Michał decides it is not needed.

## When to Consult ChatGPT

Consultations have the most value for:
- Large mechanics
- Architecture decisions
- Economy systems
- Multiplayer
- Roadmap
- Changes affecting multiple systems

Do not consult for every small design decision.

## Prompt Format

ChatGPT prompts include:
- Current topic and consultation goal
- No general game context (ChatGPT has project files)
- Topic-specific context if needed
- Prompts are delivered in a code block for easy copying

---

# File Generation Standard

When generating project files:
- Deliver only the file itself
- No surrounding text or explanation
- File should be ready to download and save directly

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
