# PROJECT_BIBLE

## Project Name

PartyGame (Working Title)

---

# Project Overview

PartyGame is a multiplayer party game inspired by Mario Party and Pummel Party.

The goal is not to clone either game.

The goal is to create a party game built around:

- Board gameplay
- Minigames
- Economy
- Buildings
- Items
- Unique board mechanics
- Strategic decisions
- Comeback systems

The game should create memorable stories and interactions between players.

---

# Project Goals

1. Create a fun multiplayer party game.
2. Learn game development.
3. Finish and release a complete game.
4. Reach Early Access with a polished core experience.

The project is currently developed as a hobby project.

---

# Development Philosophy

## Easy To Learn

New players should understand the basics quickly.

## Hard To Master

Experienced players should gain advantages through knowledge and decision making.

## Decisions Matter

Players should constantly make meaningful choices.

## Randomness Creates Stories

Randomness should create memorable situations, not replace skill.

## Multiple Paths To Victory

Players should have different strategic approaches available.

## Permanent Decisions Are Interesting

Permanent choices create meaningful long-term strategy.

---

# Core Design Pillars

## Trophies

Primary win condition.

## Economy

Creates meaningful decisions and tradeoffs.

## Board Identity

Every board must have a unique gameplay identity.

## Core Systems vs Board Systems

Core systems work on every board.

Board systems are unique to individual boards.

---

# Team Structure

Project Owner:
- Michał

Lead Designer:
- ChatGPT

Co-Designer:
- Claude

Lead Programmer:
- Claude Code

Documentation Owner:
- Claude

Final project decisions always belong to Michał.

---

# AI Collaboration Philosophy

## ChatGPT — Lead Designer (55%)
- Mechanical design and ideation
- Concept art direction
- Primary design force

## Claude — Co-Designer + Documentation Owner (45% design)
- Design support and evaluation
- Technical feasibility review
- Full documentation ownership
- Primary communication hub with Michał
- Evaluates and integrates ChatGPT suggestions
- Generates ChatGPT consultation prompts

## Claude Code — Lead Programmer
- Writing code (GDScript / Godot 4)
- Technical architecture
- Code review

---

# Design Workflow

The workflow between Claude and ChatGPT functions as a design review, not an expert consultation.

Each brings a different perspective:
- Claude evaluates through the lens of project consistency, architecture and documentation.
- ChatGPT questions assumptions, proposes alternatives and seeks compromises.

For significant design decisions:
1. Topic discussed with Claude
2. Claude generates a ChatGPT consultation prompt in a code block
3. Michał pastes ChatGPT response back to Claude
4. Claude evaluates and documents the decision
5. Consultation can be skipped when Michał decides it is not needed

ChatGPT has access to project files so prompts do not need general game context.
Prompts include only the current topic and consultation goal.

Consultations have the most value for:
- Large mechanics
- Architecture decisions
- Economy systems
- Multiplayer
- Roadmap
- Changes affecting multiple systems

---

# File Generation Standard

When generating project files:
- Deliver only the file itself
- No surrounding text or explanation
- File should be ready to download and save directly

---

# Technical Decisions

Engine: Godot 4

Language: GDScript

Multiplayer: Online (peer-to-peer na start)

Local Multiplayer: Tak

Dedykowany serwer: Opcja przyszłościowa po Early Access

---

# Early Access Vision

Early Access should be a complete game.

Planned scope:

- 1 Board (Casino)
- 25-30 Minigames
- Full Trophy System
- Full Building System
- Full Item System
- Full Match Flow
- Online Multiplayer (peer-to-peer)
- Local Multiplayer

---

# Full Game Vision

Target scope:

- 4-6 Boards
- 50+ Minigames
- 50+ Items
- Multiple Board Mechanics
- Expanded Custom Rules
- Dedicated Server (post Early Access consideration)

---

# Long-Term Development Roadmap

Phase 1:
Documentation Foundation

Phase 2:
Technical Foundation

Phase 3:
Vertical Slice

Phase 4:
Playtesting & Iteration

Phase 5:
Early Access Preparation
