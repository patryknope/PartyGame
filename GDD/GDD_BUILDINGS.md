# GDD_BUILDINGS

## Overview
Buildings provide Economy, Item Generation and Map Control.
They are designed as long-term investments — placement is a meaningful strategic decision.
Buildings are permanent and cannot be sold, moved or changed after construction.

## Building Categories
Every player may own one building per category.
- 1 Economic Building
- 1 Production Building
- 1 Control Building

Maximum: 3 Buildings total

## Building Placement
Players construct buildings directly without visiting a Builder NPC.
This keeps gameplay flow fast and simple.

## Building Permanence
Buildings are permanent.
- Cannot be sold
- Cannot be moved
- Cannot change type

## Builder NPC
The Builder NPC exists exclusively for upgrades.
Responsibilities:
- Upgrade Buildings
- Unlock Talent Levels
- Future Upgrade Services

## Economic Building
Generates passive income for the owner.
Activates at the beginning of the owner's turn.
Design goal: provide steady long-term economic growth.

## Production Building
Generates Items for the owner.

Primary implementation: Courier System
- The building produces item crates.
- A courier physically travels to deliver the item.
- Production is blocked until the current delivery is completed.
- Courier travel time should not exceed item production time.

Design goals:
- Increase board interaction
- Create visible progression
- Make Production Buildings feel different from Economic Buildings

Fallback if Courier causes frustration: direct delivery to player inventory.

## Control Building
Disrupts opponents who enter the Influence Zone.

Possible effects:
- Damage
- Coin Theft
- Item Theft
- Debuffs

Activation: opponent enters the Influence Zone.

## Influence Zone
Created immediately after the Control Building is constructed.
- Fixed size
- Treated as occupied territory
- Blocks future building construction inside the zone

## Talent System
Each building has 3 Talent Trees with 3 Levels each.
Total: 9 upgrades per building.

Players may eventually purchase every Talent.
There are no mutually exclusive paths.
The only restriction is economy, not an upgrade cap.

## Board Visual Variants
Building mechanics are identical across all boards.
Visuals change to match the board theme.

## Canon Decisions
- Buildings are permanent.
- Buildings cannot be sold, moved or change type.
- Players build directly without the Builder NPC.
- Builder NPC handles upgrades only.
- One building per category maximum.
- Economic Buildings generate passive income.
- Production Buildings generate items via Courier System.
- Control Buildings create an Influence Zone.
- Influence Zones block future construction inside them.
- Each building has 3 Talent Trees with 3 Levels.
- All Talents can eventually be purchased (economy restriction only).

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
- Courier System (frustration level, delivery pacing)
- Influence Zone Size
