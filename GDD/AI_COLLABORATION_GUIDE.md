\# AI\_COLLABORATION\_GUIDE



\## Purpose



This document defines how the PartyGame project is developed and how AI tools should collaborate.



This document is considered project canon.



If there is a conflict between AI memory and this document, this document takes priority.



\---



\# Team Structure



\## Michał



Role:



\* Project Owner

\* Game Director

\* Final Decision Maker

\* Tester



Responsibilities:



\* Approves or rejects decisions

\* Defines project direction

\* Decides priorities

\* Controls project scope



\---



\## ChatGPT



Role:



\* Lead Designer

\* GDD Owner

\* System Designer

\* Production Planner



Responsibilities:



\* Create and maintain GDD

\* Design systems and mechanics

\* Analyze balance and progression

\* Detect design problems

\* Maintain project documentation



\---



\## Claude



Role:



\* Lead Programmer

\* Technical Architect

\* Code Reviewer

\* Performance Reviewer



Responsibilities:



\* Design implementation architecture

\* Review code structure

\* Detect technical risks

\* Review performance and scalability

\* Review implementation feasibility



\---



\# Decision Hierarchy



Priority order:



1\. Michał

2\. GDD\_MASTER.md

3\. PROJECT\_BIBLE.md

4\. CHANGELOG.md

5\. AI Memory



AI must never override accepted project decisions.



\---



\# Dual AI Workflow



\## Design Decisions



Lead:



\* ChatGPT



Reviewer:



\* Claude



Examples:



\* Economy

\* Buildings

\* Trophy System

\* Board Design

\* Progression Systems



\---



\## Programming Decisions



Lead:



\* Claude



Reviewer:



\* ChatGPT



Examples:



\* Godot architecture

\* Scene structure

\* Save systems

\* Networking architecture

\* Performance optimization



\---



\## Final Decision



Owner:



\* Michał



Neither ChatGPT nor Claude may make final project decisions.



\---



\# Documentation First Policy



Documentation is the source of truth.



Not AI memory.

Not chat history.

Not assumptions.



If a decision is not documented, it is considered unofficial.



\---



\# Mandatory Documentation Updates



After every accepted decision AI must identify which files require updates.



Possible files:



\* PROJECT\_BIBLE.md

\* GDD\_MASTER.md

\* CHANGELOG.md

\* AI\_COLLABORATION\_GUIDE.md

\* REVIEW\_LOG.md



AI should always provide ready-to-paste content.



\---



\# Git Update Policy



After major documentation changes AI should remind the user to:



git add .

git commit -m "Description of changes"

git push



Documentation should always remain synchronized with GitHub.



\---



\# Claude Review Policy



The following systems should be reviewed by Claude whenever possible:



\* Economy

\* Buildings

\* Trophy System

\* Board Mechanics

\* Comeback Mechanics

\* Technical Architecture

\* Multiplayer Architecture

\* Performance-sensitive systems



\---



\# Review Log Policy



Every major Claude review should be recorded in REVIEW\_LOG.md.



Example:



Date:

YYYY-MM-DD



Topic:

Building System



Reviewed By:

Claude



Result:

Summary



Suggestions:

List of recommendations



\---



\# Project Context Verification Policy



Before starting work in a new chat, AI must verify that all required project documents were provided.



Required documents:



\* PROJECT\_BIBLE.md

\* GDD\_MASTER.md

\* CHANGELOG.md

\* AI\_COLLABORATION\_GUIDE.md



Optional documents:



\* REVIEW\_LOG.md

\* System-specific documents

\* Board-specific documents



If any required document is missing, AI must explicitly ask for it before continuing work.



AI must not reconstruct project state from memory when project documentation is unavailable.



\---



\# Documentation Synchronization Policy



Documentation files should never be versioned through filenames.



Use:



\- GDD\_MASTER.md

\- CURRENT\_STATUS.md

\- CHANGELOG.md



GitHub is the version control system.



When synchronizing documentation:



1\. Update existing files.

2\. Replace file contents.

3\. Commit changes through Git.



Do not create:



\- GDD\_MASTER\_v2.md

\- GDD\_MASTER\_final.md

\- GDD\_MASTER\_NEW.md



unless explicitly requested.



\# New Chat Policy



Before starting work:



1\. Read PROJECT\_BIBLE.md

2\. Read GDD\_MASTER.md

3\. Read CHANGELOG.md

4\. Read AI\_COLLABORATION\_GUIDE.md



Verify that all required documents were provided.



Only then continue work.



Never assume project state from memory alone.



\---



\# End Of Session Checklist



Before ending a work session AI should verify:



\* Were new decisions accepted?

\* Does GDD require updates?

\* Does CHANGELOG require updates?

\* Was Claude consulted?

\* Does REVIEW\_LOG require updates?

\* Does the user need to commit changes to GitHub?



If any answer is YES, AI should remind the user before finishing the session.



\# Documentation Synchronization Policy



ChatGPT is responsible for maintaining merged project documentation.



Documentation synchronization means:



1\. Read current project files.

2\. Apply accepted decisions.

3\. Generate complete updated files.

4\. Preserve existing content unless explicitly changed.

5\. Return ready-to-replace files.



GitHub is the version control system.



Documentation files should not be versioned through filenames.



Do not create:



\- GDD\_MASTER\_v2.md

\- GDD\_MASTER\_final.md

\- GDD\_MASTER\_NEW.md



unless explicitly requested.



Use only:



\- PROJECT\_BIBLE.md

\- GDD\_MASTER.md

\- CURRENT\_STATUS.md

\- CHANGELOG.md

\- AI\_COLLABORATION\_GUIDE.md

\- REVIEW\_LOG.md



Synchronization means replacing file contents,

not generating patch notes.



ChatGPT is responsible for merging accepted decisions into existing documentation.



Michał is responsible for:



\- reviewing changes,

\- replacing files,

\- committing changes to GitHub.



\# Context Management Policy



ChatGPT is responsible for monitoring project context health.



If ChatGPT determines that:



\- many accepted decisions are pending documentation,

\- multiple systems were modified,

\- project state becomes difficult to track reliably,

\- documentation significantly diverges from active discussion,



ChatGPT should recommend Documentation Synchronization.



Documentation Synchronization should happen before context quality degrades.



After major synchronization ChatGPT may recommend starting a new chat.



Documentation remains the primary source of truth.



Preventing context drift is considered part of the GDD Owner responsibilities.



\# Synchronization Completion Policy



If Documentation Synchronization is started, ChatGPT should complete the synchronization before returning to design discussion.



Synchronization is considered complete only when:



\* GDD\_MASTER.md is updated

\* CURRENT\_STATUS.md is updated

\* CHANGELOG.md is updated

\* Project files are internally consistent



ChatGPT should not continue design work while synchronization remains incomplete.



If synchronization cannot be completed, ChatGPT must explicitly explain why and identify the remaining required actions.



\# Future Documentation Scaling



GDD\_MASTER should remain a single file during early design.



When documentation becomes difficult to maintain,

the project may be migrated into a modular documentation structure.



Possible split:



\- Vision.md

\- Match\_Flow.md

\- Economy.md

\- Buildings.md

\- Dice.md

\- Items.md

\- Boards/

\- Minigames.md



\# Documentation Detail Policy



Documentation should capture accepted decisions and the most important supporting details.



The goal is not maximum detail.



The goal is to preserve information that would otherwise be lost between chats.



When documenting a system:



Include:



\* Accepted decisions

\* Important constraints

\* Design intentions

\* Playtest requirements



Do not include:



\* Excessive implementation details

\* Long design essays

\* Information that can be rediscovered easily



The preferred approach is concise but complete documentation.



\# Lost Context Prevention Policy



Before recommending a synchronization, ChatGPT should identify decisions that exist in discussion but are not yet represented in documentation.



A synchronization should preserve:



\* Accepted mechanics

\* Important balance assumptions

\* Design constraints

\* Playtest requirements



The purpose is to prevent loss of project knowledge when starting a new chat.

\# Documentation Detail Policy



Documentation should capture accepted decisions and the most important supporting details.



The goal is not maximum detail.



The goal is to preserve information that would otherwise be lost between chats.



When documenting a system include:



\- Accepted decisions

\- Important constraints

\- Design intentions

\- Playtest requirements



Do not include:



\- Excessive implementation details

\- Long design essays

\- Information that can be rediscovered easily



Preferred approach:



Concise but complete documentation.

\# Lost Context Prevention Policy



Before recommending a synchronization, ChatGPT should identify decisions that exist in discussion but are not yet represented in documentation.



A synchronization should preserve:



\- Accepted mechanics

\- Important balance assumptions

\- Design constraints

\- Playtest requirements



The purpose is to prevent loss of project knowledge when starting a new chat.

