# GDD_BUILDINGS

## Overview
Buildings provide Economy, Item Generation and Map Control.

## Building Categories
- 1 Economic Building
- 1 Production Building
- 1 Control Building

Maximum: 3 Buildings

## Building Placement
Players construct buildings directly.

## Building Permanence
Cannot:
- Sell
- Move
- Change Type

## Builder NPC
Used only for upgrades.

Responsibilities:
- Upgrade Buildings
- Unlock Talent Levels
- Future Upgrade Services

## Economic Building
Generates passive income.
Activates at beginning of owner's turn.

## Production Building
Generates Items.

Primary Implementation:
Courier System

Rules:
- Courier physically delivers items.
- Production blocked until delivery completed.
- Courier travel time should not exceed production time.

Fallback:
Direct inventory delivery.

## Control Building
Possible effects:
- Damage
- Coin Theft
- Item Theft
- Debuffs

## Influence Zone
- Created immediately
- Fixed size
- Blocks future construction

## Talent System
- 3 Talent Trees
- 3 Levels per Tree
- 9 Upgrades total

## Talent Progression
All talents may eventually be purchased.

## Board Visual Variants
Mechanics remain identical, visuals change by board.

## Canon Decisions
- Buildings are permanent.
- Buildings cannot be sold.
- Buildings cannot be moved.
- Players build buildings themselves.
- Builder only upgrades buildings.
- One building per category.
- Economic Buildings generate income.
- Production Buildings generate items.
- Control Buildings create influence zones.
- Influence zones block future construction.
- Buildings use 3 talent trees.
- All talents can eventually be maxed.

## Open Questions
- Exact Building Costs
- Exact Upgrade Costs
- Talent Designs
- Influence Zone Size
- Final Production Building Delivery Method

## Claude Review Required
- Building Balance
- Economic Scaling
- Courier System Feasibility
- Influence Zone Design
- Upgrade Cost Progression

## Playtest Required
- Courier System
- Influence Zone Size
