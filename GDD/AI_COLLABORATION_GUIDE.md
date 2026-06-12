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



