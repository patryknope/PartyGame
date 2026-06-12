\# PROJECT\_BIBLE



\## Project Name



PartyGame (Working Title)



\---



\# Project Overview



PartyGame is a multiplayer party game inspired by Mario Party and Pummel Party.



The goal is not to clone either game.



The goal is to create a party game built around:



\* Board gameplay

\* Minigames

\* Economy

\* Buildings

\* Items

\* Unique board mechanics

\* Strategic decisions

\* Comeback systems



The game should create memorable stories and interactions between players.



\---



\# Project Goals



Primary goals:



1\. Create a fun multiplayer party game.

2\. Learn game development.

3\. Finish and release a complete game.

4\. Reach Early Access with a polished core experience.



The project is currently developed as a hobby project.



\---



\# Development Philosophy



The project follows several core principles.



\## Easy To Learn



New players should understand the basics quickly.



\---



\## Hard To Master



Experienced players should gain advantages through knowledge and decision making.



\---



\## Decisions Matter



Players should constantly make meaningful choices.



Examples:



\* Buy trophy or invest?

\* Upgrade building or save money?

\* Take safe route or risky route?



\---



\## Randomness Creates Stories



Randomness is important.



However:



Randomness should create memorable situations.



Randomness should not completely replace skill.



\---



\## Multiple Paths To Victory



Players should have different strategies available.



Examples:



\* Trophy focused

\* Economy focused

\* Control focused

\* Event focused



\---



\## Permanent Decisions Are Interesting



The project intentionally uses permanent choices.



Example:



Buildings cannot be moved or sold.



This makes placement meaningful.



\---



\# Core Design Pillars



\## Trophies



Trophies are the primary win condition.



All trophies have equal value.



No legendary trophies.



No double trophies.



\---



\## Economy



Economy drives decision making.



Coins are the universal currency.



Every board may visually replace Coins with a thematic version.



Examples:



Casino:



\* Chips



Pirates:



\* Doubloons



Space:



\* Credits



Mechanically they remain Coins.



\---



\## Board Identity



Every board must offer a unique experience.



Each board has its own main mechanic.



Examples:



Casino:



\* Roulette

\* VIP

\* Dealer



Future boards should follow the same philosophy.



\---



\## Core Systems vs Board Systems



Core Systems:



\* Economy

\* Trophies

\* Buildings

\* Dice

\* Items

\* Combat



These work on every board.



Board Systems:



\* Roulette

\* VIP

\* Pirate Ship

\* Space Events



These are unique to individual boards.



\---



\# Team Structure



Project Owner:



\* Michał



Lead Designer:



\* ChatGPT



Lead Programmer:



\* Claude



Final project decisions always belong to Michał.



\---



\# AI Collaboration Philosophy



The project intentionally uses multiple AI systems.



ChatGPT:



\* Design

\* Systems

\* GDD

\* Planning



Claude:



\* Programming

\* Architecture

\* Code Review

\* Technical Validation



Both AIs should review each other's work when useful.



\---



\# Documentation Policy



Documentation is the source of truth.



Not memory.



Not chat history.



Not assumptions.



Accepted decisions must be documented.



\---



\# Documentation Structure



PROJECT\_BIBLE.md



\* Project philosophy

\* Team structure

\* Vision



GDD\_MASTER.md



\* Actual game design document



CHANGELOG.md



\* History of accepted decisions



AI\_COLLABORATION\_GUIDE.md



\* AI workflow



REVIEW\_LOG.md



\* Claude reviews



\---



\# GitHub Policy



Major changes should be committed regularly.



Recommended workflow:



git add .

git commit -m "Description"

git push



\---



\# Early Access Vision



Early Access should be a complete game.



Not a demo.



Planned scope:



\* 1 Board (Casino)

\* 25-30 Minigames

\* Full Trophy System

\* Full Building System

\* Full Item System

\* Full Match Flow



\---



\# Full Game Vision



Target scope:



\* 4-6 Boards

\* 50+ Minigames

\* 50+ Items

\* Multiple Board Mechanics

\* Expanded Custom Game Rules



\---



\# Current Development Stage



Current Stage:



Game Design Document Creation



Current Chapter:



Chapter 5 - Buildings



Status:



In Progress



Implementation has not started yet.



The current priority is completing and validating the full GDD before production begins.

\---



\# Additional Design Pillars



\## Board Identity First



Every board must have a unique central mechanic.



The board mechanic should define how the board feels and how players interact with it.



Examples:



Casino:



\* Roulette

\* VIP

\* Dealer Events



Future boards should follow the same principle.



Board mechanics should not be simple visual reskins.



Each board should create a distinct gameplay experience.



\---



\## Board Trophies Matter



PartyGame intentionally treats all Trophies equally.



Examples:



\* Main Trophy

\* Main Event Trophy

\* Mini Event Trophy

\* Special Room Trophy

\* Bonus Trophies



Every Trophy grants:



1 Victory Point



No Trophy is inherently more valuable than another.



\---



\## Strategic Permanence



Certain decisions are intentionally permanent.



Examples:



\* Building placement

\* Building category selection

\* Building development



The purpose is to reward planning and long-term strategy.



\---



\## Economy Creates Decisions



Economy should constantly force players to choose between competing goals.



Examples:



\* Trophy progression

\* Building progression

\* Item purchases

\* Board opportunities



Players should rarely be able to afford everything they want.



\---



\# Documentation First Development



PartyGame is developed using a documentation-first workflow.



The project should never rely on AI memory or chat history.



Accepted decisions must be documented.



Documentation is considered the primary source of truth.



Priority Order:



1\. GDD\_MASTER.md

2\. PROJECT\_BIBLE.md

3\. CHANGELOG.md

4\. REVIEW\_LOG.md

5\. AI Memory



\---



\# Development Workflow



Current Workflow:



1\. Design System

2\. Document System

3\. Review System

4\. Update Documentation

5\. Commit Documentation

6\. Prototype

7\. Playtest

8\. Iterate



The project intentionally delays implementation until the GDD foundation is sufficiently complete.



\---



\# Current Development Roadmap



Phase 1:

Documentation Foundation



Status:

In Progress



Goals:



\* Complete GDD

\* Create documentation structure

\* Perform design reviews



\---



Phase 2:

Technical Foundation



Goals:



\* Godot architecture

\* Repository structure

\* Development workflow

\* Prototype framework



\---



Phase 3:

Vertical Slice



Goals:



\* Casino Board

\* Core Match Flow

\* Buildings

\* Trophies

\* Basic Items

\* Basic Minigames



\---



Phase 4:

Playtesting \& Iteration



Goals:



\* Balance

\* UX Improvements

\* System Refinement



\---



Phase 5:

Early Access Preparation



Goals:



\* Polish

\* Content Expansion

\* Steam Preparation



\---



\# Current Project Status



Current Focus:



Completing the Early Access Foundation GDD.



Priority Systems Remaining:



\* Dice System

\* Item System

\* Lobby Rules

\* Minigames

\* Detailed Casino Systems



Implementation has not started yet.



Current objective is creating a stable and reviewable design foundation.



