# GDD_CASINO

## Overview
Casino is the first planned board and the foundation of Early Access.
The board is designed around risk, rewards and gambling-inspired mechanics.
Casino should feel chaotic, unpredictable, entertaining and interactive.

## Core Board Mechanic
Primary mechanic: Roulette

Roulette is the central system of the Casino board.
Many board events and outcomes originate from Roulette results.

### Roulette As The Board Foundation
The entire board sits on one giant Roulette — the Roulette spans the whole map,
and every board tile sits on one of its colored segments.

Consequence: a player's position on the board equals their current color.

The Dealer spins the Roulette at the START of each round — the end of a round
is reserved for the minigame draw.

### Roulette Colors
The Roulette has 3 colors, like a real roulette wheel:
- Red
- Black
- Green

### Colors → Team Assignment (soft weighting)
At the end of a round, when a team minigame is drawn, players are assigned to
teams with a weight toward the color they are currently standing on:
- Standing on red → higher chance of joining the red team.
- The color only tilts the draw — it never decides 100%.

Why a weighted draw instead of fixed assignment:
with 3 colors and no randomness, matches would almost always settle into the
same team layouts (mostly 3v3 or 2v2v2). The soft draw deliberately varies team
configurations between rounds — sometimes 2v2v2, sometimes 3v3, sometimes 2v4,
occasionally even 1v5. This keeps matches fresh and unpredictable instead of
falling into a routine.

### Architectural Boundary
The colors → teams mechanic is Casino-specific and lives HERE, in GDD_CASINO —
not in GDD_MINIGAMES, which deliberately stays board-neutral per the rule
"core does not know board specifics". Future boards will have their own team
assignment mechanics.

## Poker Tables
Poker is the second gambling mechanic of the Casino board (after Roulette).

KARTY tiles host a Dealer-run video-poker table:
- Landing on a KARTY tile deals the player 5 cards
- The player picks cards to hold and gets one redraw
- Payout depends on the final poker hand (prototype table:
  pair 3, two pair 8, trips 15, straight 25, flush 30,
  full house 40, quads 60, straight flush 100)
- Playing is free — the "stake" is the tile itself

A dedicated FFA minigame (Poker Draw) also exists — see GDD_MINIGAMES.

Open Questions:
- Final payout table
- Should poker cost a stake to play?
- Interaction with future Dealer Events

## Dealer
The Dealer acts as the board controller — not a player, but a board mechanic.

Responsibilities:
- Spinning the Roulette at the start of each round
- Triggering Events
- Managing Roulette outcomes
- Creating match variety

## Board Events
Casino contains multiple event categories.
Examples:
- Positive Events
- Negative Events
- Global Events
- Player Events
- Economy Events

Specific events are not yet finalized.

### Mini Events
Smaller, frequent board interactions.
Purpose: frequent board activity, additional decisions, increased unpredictability.
Mini Events may reward or punish players.

### Main Events
Large, board-changing moments that occur less frequently than Mini Events.
Purpose: shake up the game state, create memorable moments, encourage adaptation.

## Special Room — VIP Room
Special Room is the generic core system name.
Casino uses the themed variant: VIP Room.
Future boards will have their own themed variants of this system.

Players may:
- Enter the VIP Room
- Be removed from the VIP Room
- Gain access through board mechanics
- Gain access through items
- Gain access through Roulette outcomes

VIP Design Goals:
- High value opportunities
- Player competition
- Strategic decisions
- Important but not mandatory

## Board Trophies
- Main Trophy
- Main Event Trophy
- Mini Event Trophy
- Special Room Trophy

All Trophies are worth 1 Victory Point.

## Canon Decisions
- Roulette is the primary Casino mechanic.
- The whole board sits on one giant Roulette; every tile belongs to a colored segment.
- Player position on the board equals the player's current color.
- The Roulette has 3 colors: red, black, green.
- The Dealer spins the Roulette at the start of each round; the end of a round belongs to the minigame draw.
- Team minigame assignment is a weighted draw tilted by the player's current color — never a guaranteed assignment.
- The weighted draw exists to vary team layouts between rounds (2v2v2, 3v3, 2v4, even 1v5).
- Colors → teams is Casino-specific and documented in GDD_CASINO; GDD_MINIGAMES stays board-neutral.
- The Dealer controls board events.
- VIP Room is a major Casino system.
- Special Room is the generic system name.
- Main Event Trophy exists.
- Mini Event Trophy exists.
- Special Room Trophy exists.
- All Trophies have equal value.

## Open Questions
- How exactly the 3 colors map onto concrete team structures in each minigame.
- Exact weight / probability of the team draw.
- How to reconcile asymmetric layouts (2v4, 1v5) with GDD_MINIGAMES categories
  (TEAM_EVEN assumes even teams, ONE_VS_ALL is by definition 1 vs rest) —
  noted inconsistency, needs a design session.
- Does the round-start spin rotate the colors under the players, or does color
  derive purely from board position?
- How do colors interact with FFA minigames (no teams)?
- Exact Roulette Rules
- Exact VIP Rewards
- Exact Dealer Event Pool
- Event Frequency
- Trophy Spawn Rules
