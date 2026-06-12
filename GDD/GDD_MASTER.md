\# GDD\_MASTER



Version: 1.0 Draft



Status: Active Development



\---



\# Chapter 1 - Vision



\## Game Overview



PartyGame is a multiplayer party game inspired by Mario Party and Pummel Party.



The goal is not to recreate either game directly.



The goal is to create a party game focused on:



\* strategic decision making,

\* board gameplay,

\* economy,

\* buildings,

\* items,

\* player interaction,

\* unique board mechanics,

\* memorable match stories.



The game should combine skill, planning and randomness.



\---



\## Target Players



Primary Audience:



\* Friends playing together

\* Casual multiplayer groups

\* Party game fans

\* Mario Party fans

\* Pummel Party fans



Supported Players:



\* 2 to 6 players



\---



\## Core Design Pillars



\### Decisions Matter



Players should constantly make meaningful choices.



Examples:



\* Save Coins or spend them.

\* Buy a Trophy or invest into buildings.

\* Take a safe route or a risky route.

\* Focus on economy or disruption.



\---



\### Randomness Creates Stories



Randomness is important.



Randomness should create memorable moments.



Randomness should not completely replace player decisions.



\---



\### Multiple Paths To Victory



Players should be able to pursue different strategies.



Examples:



\* Trophy focused

\* Economy focused

\* Event focused

\* Building focused

\* Control focused



\---



\### Permanent Decisions



Permanent decisions create strategic depth.



Example:



Buildings cannot be sold or moved after construction.



\---



\### Board Identity



Every board must feel unique.



Each board should contain its own primary mechanic.



Examples:



Casino:



\* Roulette

\* VIP

\* Dealer



Future boards should follow the same philosophy.



\---



\## Full Game Scope



Target:



\* 4-6 boards

\* 50+ minigames

\* 50+ items

\* Custom game settings

\* Multiple board mechanics



\---



\## Early Access Scope



Early Access should be a complete game.



Not a demo.



Planned content:



\* 1 board (Casino)

\* 25-30 minigames

\* Full economy

\* Full building system

\* Full item system

\* Full trophy system



\---



\# Accepted Decisions



\* Early Access is a complete game.

\* Every board has a unique mechanic.

\* Trophies are the primary win condition.



\---



\# Open Questions



None currently.



\---



\# Chapter 2 - Match Structure



\## Supported Players



Minimum:



\* 2



Maximum:



\* 6



\---



\## Match Length



Default:



\* 15 turns



Planned Options:



\* 10 turns

\* 15 turns

\* 20 turns

\* 30 turns



\---



\## Match Flow



Round Structure:



1\. All player turns

2\. Minigame

3\. Board Mechanic Update

4\. Next Round



\---



\## Turn Flow



Player Turn:



1\. Use War Item (optional)

2\. Select Dice

3\. Roll Dice

4\. Movement

5\. Route Decisions

6\. Board Interactions

7\. Final Tile Resolution

8\. Use Utility Items

9\. End Turn



\---



\## War Items



War Items may only be used before movement.



Purpose:



\* attacking players

\* disruption

\* aggression



\---



\## Utility Items



Utility Items may be used during the player's turn.



Purpose:



\* mobility

\* economy

\* utility

\* planning



\---



\## Tie Breakers



If players have equal Trophy counts:



Winner is determined by total Wealth.



\---



\# Accepted Decisions



\* Default match length is 15 turns.

\* Wealth breaks ties.

\* Utility items are usable during the turn.

\* War items are usable before movement.



\---



\# Open Questions



\* Final list of match settings.


# CHAPTER 3 - ECONOMY



\## Overview



Economy is one of the primary systems of PartyGame.



Its purpose is to create meaningful decisions throughout the match.



Players must constantly choose between:



\* Short-term gains

\* Long-term investments

\* Trophy progression

\* Building progression

\* Item purchases

\* Board interactions



Economy should support strategy, not dominate it.



\---



\## Currency



Universal Currency:



Coins



Coins are the internal system name.



Individual boards may visually replace Coins with thematic versions.



Examples:



Casino:



\* Chips



Pirates:



\* Doubloons



Space:



\* Credits



Mechanically these remain Coins.



\---



\## Wealth



Wealth represents the total value of a player's assets.



Wealth is used for:



\* Tie breakers

\* Certain comeback mechanics

\* Certain board mechanics

\* Potential future systems



Current Wealth Sources:



\* Coins

\* Buildings

\* Building Upgrades

\* Items

\* Dice

\* Trophies



Exact Wealth Formula:



OPEN QUESTION



\---



\## Income Sources



Current planned income sources:



\* Minigames

\* Economy Buildings

\* Board Events

\* Special Rooms

\* Board Mechanics

\* Property Ownership

\* Trophy Rewards

\* Future Systems



\---



\## Spending



Current planned spending categories:



\* Trophies

\* Buildings

\* Building Upgrades

\* Items

\* Dice

\* Board Services

\* Special Events



\---



\## Economy Design Philosophy



Economy should create tension.



Players should rarely feel capable of purchasing everything they want.



A player investing heavily into one area should sacrifice progress in another area.



Examples:



\* Economy vs Trophies

\* Buildings vs Items

\* Immediate Power vs Long-Term Growth



\---



\# CANON DECISIONS



\* Coins are the universal currency.

\* Boards may rename Coins visually.

\* Wealth is used as the primary tie breaker.

\* Economy should force meaningful choices.



\---



\# OPEN QUESTIONS



\* Final Wealth Formula

\* Trophy Costs

\* Building Costs

\* Upgrade Costs

\* Dice Costs

\* Item Costs



\---



\# CHAPTER 4 - TROPHY SYSTEM



\## Overview



Trophies are the primary win condition of PartyGame.



The player with the highest number of Trophies wins the match.



All Trophies have equal value.



No Trophy is inherently more valuable than another.



\---



\## Main Trophy



Main Trophy is the primary board Trophy.



Rules:



\* Only one Main Trophy may exist at a time.

\* When collected it respawns elsewhere.

\* The respawn location is chosen by the board.



Purpose:



\* Constant movement

\* Map interaction

\* Player conflict



\---



\## Board Trophies



Board Trophies are unique to each board.



Board Trophies are connected to the board's core mechanic.



Examples:



Casino:



\* Main Event Trophy

\* Special Room Trophy

\* Mini Event Trophy



These names are intentionally generic.



Future boards may replace them with their own themed versions.



\---



\## Bonus Trophies



Bonus Trophies are awarded based on player performance.



Default Setup:



Success Trophies:



\* 3



Neutral Trophies:



\* 3



Comeback Trophies:



\* 3



Total:

9



\---



\## Trophy Customization



Players may configure Bonus Trophy settings in the lobby.



Examples:



\* Enable/Disable Categories

\* Change Trophy Count

\* Future Custom Rules



\---



\## Trophy Equality



Every Trophy grants:



1 Victory Point



Examples:



Main Trophy:

1 Point



Board Trophy:

1 Point



Bonus Trophy:

1 Point



There are no double-value trophies.



There are no legendary trophies.



\---



\## Trophy Respawning



Board-related Trophies may respawn after collection.



Respawn behavior depends on the board.



This system exists to:



\* Keep players moving

\* Prevent static gameplay

\* Create repeated opportunities



\---



\# CANON DECISIONS



\* Trophies are the primary win condition.

\* Every Trophy has equal value.

\* Only one Main Trophy exists at a time.

\* Bonus Trophies are configurable in lobby.

\* Board Trophies are board specific.



\---



\# OPEN QUESTIONS



\* Exact Trophy Costs

\* Bonus Trophy Pool Expansion

\* Respawn Rules Per Board



\---



\# CHAPTER 5 - BUILDINGS



\## Overview



Buildings are one of the primary progression systems.



Buildings provide:



\* Economy

\* Item Generation

\* Map Control



Buildings are designed as long-term investments.



\---



\## Building Categories



Every player may own:



\* 1 Economic Building

\* 1 Production Building

\* 1 Control Building



Maximum:



3 Buildings Total



One per category.



\---



\## Building Placement



Buildings may be constructed directly by the player.



Builder NPC is NOT required for construction.



Purpose:



\* Faster gameplay

\* Simpler flow

\* Reduced friction



\---



\## Building Permanence



Buildings are permanent.



Players cannot:



\* Sell Buildings

\* Move Buildings

\* Change Building Type



Building placement is intended to be a meaningful strategic decision.



\---



\## Builder NPC



Builder exists exclusively for upgrades.



Builder does NOT construct Buildings.



Builder responsibilities:



\* Upgrade Buildings

\* Unlock Talent Levels

\* Future Upgrade Services



\---



\## Economic Building



Purpose:



Generate passive income.



Activation:



Beginning of owner's turn.



Design Goal:



Provide long-term economic growth.



\---



\## Production Building



Purpose:



Generate Items.



Current Preferred Concept:



The building produces item crates.



Item delivery is connected to a courier-style system.



\---



PLAYTEST REQUIRED



Courier delivery system must be evaluated during prototype testing.



If courier gameplay feels frustrating:



Fallback Option:



Generated Items are delivered directly to inventory.



\---



\## Control Building



Purpose:



Disrupt opponents.



Possible Effects:



\* Damage

\* Coin Theft

\* Item Theft

\* Debuffs

\* Future Effects



Activation:



Opponent enters Influence Zone.



\---



\## Influence Zone



Control Buildings create an Influence Zone.



Influence Zone:



\* Exists immediately after construction.

\* Has fixed size.

\* Is considered part of the building.

\* Blocks future construction.



Reason:



The zone itself is treated as occupied territory.



\---



\## Talent System



Each Building contains:



\* 3 Talent Trees

\* 3 Levels Per Tree



Total:



9 Upgrades



\---



\## Talent Progression



Players may eventually purchase every Talent.



There are no mutually exclusive paths.



Restriction:



Economy.



Not upgrade caps.



\---



\## Board Visual Variants



Buildings are part of Core Systems.



Mechanics remain identical.



Visuals may change by board.



Examples:



Casino:



\* Casino-themed Buildings



Pirates:



\* Pirate-themed Buildings



Space:



\* Space-themed Buildings



\---



\# CANON DECISIONS



\* Buildings are permanent.

\* Buildings cannot be sold.

\* Buildings cannot be moved.

\* Players build buildings themselves.

\* Builder only upgrades buildings.

\* One building per category.

\* Economic Buildings generate income.

\* Production Buildings generate items.

\* Control Buildings create influence zones.

\* Influence zones block future construction.

\* Buildings use 3 talent trees.

\* All talents can eventually be maxed.



\---



\# OPEN QUESTIONS



\* Exact Building Costs

\* Exact Upgrade Costs

\* Talent Designs

\* Influence Zone Size

\* Final Production Building Delivery Method



\---



\# CLAUDE REVIEW REQUIRED



\* Building Balance

\* Economic Scaling

\* Courier System Feasibility

\* Influence Zone Design

\* Upgrade Cost Progression
## Production Building



Purpose:



Generate Items.



Current Implementation:



The building produces item crates.



Items are delivered through a Courier System.



The courier must physically travel to deliver the generated item.



The building cannot produce another item until the previous delivery has been completed.



Design Goals:



\* Increase board interaction.

\* Create visible progression.

\* Add personality to buildings.

\* Make Production Buildings feel different from Economy Buildings.



\---



\## PLAYTEST REQUIRED



The Courier System is considered the primary implementation.



The system should remain unless testing proves it creates excessive frustration or significantly weakens Production Buildings.



Potential fallback:



Automatically deliver generated items directly to player inventory.



Current Status:



CANON DECISION



Primary Implementation:

Courier System

\# CHAPTER 6 - PROPERTY \& BOARD STRUCTURE



\## Board Philosophy



Boards should not be simple loops or squares.



Boards should encourage:



\* Route planning

\* Risk versus reward decisions

\* Player interaction

\* Strategic movement



Every board should contain multiple branching paths.



\---



\## Route Structure



Boards contain:



\* Main routes

\* Branch routes

\* Reconnecting paths



Branches should regularly reconnect to maintain map flow.



Players should be able to move between different sections of the map without becoming trapped.



\---



\## Movement



Players move according to their dice result.



Movement continues until all movement points are consumed.



Certain board mechanics may interrupt movement.



\---



\## Tile Categories



Planned tile categories:



\* Property Tiles

\* Reward Tiles

\* Penalty Tiles

\* Event Tiles

\* Shop Tiles

\* Board Mechanic Tiles

\* Special Room Tiles



Additional tile types may be added later.



\---



\## Pass-Through Mechanics



Some special locations activate when a player passes through them.



Examples:



\* Shops

\* VIP Entrances

\* Special Board Mechanics



Movement continues after interaction unless otherwise specified.



\---



\## End-Of-Movement Mechanics



Most standard tiles activate only when the player finishes movement on them.



Examples:



\* Property Tiles

\* Reward Tiles

\* Penalty Tiles

\* Event Tiles



\---



\## Property System



Properties represent ownership of board locations.



Properties are separate from Buildings.



Owning a Property provides strategic value and may interact with future systems.



\---



\## Property Purchase



When a player finishes movement on an unowned Property Tile:



The player may purchase the Property.



Exact purchase cost:



OPEN QUESTION



\---



\## Property Takeover



Players may take ownership of an unbuilt Property from another player.



Takeover Cost:



10 Coins



Distribution:



\* 5 Coins → Previous Owner

\* 5 Coins → Bank



Buildings cannot be taken over.



Only the Property ownership changes.



\---



\## Building Restrictions



If a Property contains a Building:



\* Property cannot be taken over.

\* Building cannot be removed.

\* Building cannot be moved.



\---



\## Influence Zone Restrictions



Control Building Influence Zones are treated as occupied territory.



Inside an Influence Zone:



\* New Buildings cannot be constructed.

\* Existing Buildings remain unaffected.



The Influence Zone is considered part of the Control Building.



\---



\# CANON DECISIONS



\* Boards contain branching routes.

\* Branches should reconnect.

\* Properties and Buildings are separate systems.

\* Players can purchase Properties.

\* Players can take over unbuilt Properties.

\* Buildings prevent Property takeovers.

\* Influence Zones block future construction.



\---



\# OPEN QUESTIONS



\* Property Purchase Cost

\* Future Property Bonuses

\* Future Property Interactions



\---



\# CHAPTER 7 - CASINO BOARD



\## Overview



Casino is the first planned board.



Casino serves as the foundation of Early Access.



The board is designed around risk, rewards and gambling-inspired mechanics.



\---



\## Core Board Mechanic



Main Mechanic:



Roulette



Roulette is the central system of the Casino Board.



Many board events originate from Roulette outcomes.



\---



\## Dealer



The Dealer (Krupier) acts as the board controller.



The Dealer is responsible for:



\* Triggering Events

\* Managing Roulette outcomes

\* Creating match variety



The Dealer is not a player.



The Dealer is a board mechanic.



\---



\## Board Events



Casino contains multiple event categories.



Examples:



\* Positive Events

\* Negative Events

\* Global Events

\* Player Events

\* Economy Events



Specific events are not yet finalized.



\---



\## Mini Events



Mini Events represent smaller board interactions.



Purpose:



\* Frequent board activity

\* Additional decisions

\* Increased unpredictability



Mini Events may reward or punish players.



\---



\## Main Events



Main Events represent larger board-changing moments.



Purpose:



\* Shake up the game state

\* Create memorable moments

\* Encourage adaptation



Main Events are expected to occur less frequently than Mini Events.



\---



\## VIP Area



VIP is one of the major Casino systems.



VIP is intentionally designed as a highly interactive area.



Players may:



\* Enter VIP

\* Be removed from VIP

\* Gain access through board mechanics

\* Gain access through items

\* Gain access through Roulette effects



\---



\## VIP Design Goals



VIP should create:



\* High value opportunities

\* Player competition

\* Strategic decisions



VIP should feel important without becoming mandatory.



\---



\## Board Trophies



Casino Board currently contains:



\* Main Trophy

\* Main Event Trophy

\* Mini Event Trophy

\* Special Room Trophy



All Trophies remain equal in value.



Each Trophy grants:



1 Victory Point



\---



\## Board Identity



Casino should feel:



\* Chaotic

\* Unpredictable

\* Entertaining

\* Interactive



The board should generate stories naturally through its mechanics.



\---



\# CANON DECISIONS



\* Roulette is the primary Casino mechanic.

\* Dealer controls board events.

\* VIP is a major Casino system.

\* Main Event Trophy exists.

\* Mini Event Trophy exists.

\* Special Room Trophy exists.

\* All Trophies have equal value.



\---



\# OPEN QUESTIONS



\* Exact Roulette Rules

\* Exact VIP Rewards

\* Exact Dealer Event Pool

\* Event Frequency

\* Trophy Spawn Rules



\---



\# CHAPTER 8 - COMBAT \& DEATH



\## Overview



Combat systems exist to increase player interaction.



Combat should create tension and opportunities.



Combat should not completely dominate the match.



\---



\## Death



Players may die through combat or board effects.



Death is intended as a setback.



Death is not intended to remove a player from the match.



\---



\## Death Penalty



Current direction:



Player loses a percentage of Coins.



Current estimated range:



15% - 25%



Final value:



OPEN QUESTION



\---



\## Comeback Philosophy



PartyGame intentionally includes comeback mechanics.



Players falling behind should still have opportunities to recover.



\---



\## Wheel Of Death



Wheel Of Death is a planned comeback system.



Wealth influences the wheel outcome.



Lower-Wealth players receive better odds.



Higher-Wealth players receive worse odds.



Purpose:



\* Reduce runaway leaders

\* Create dramatic moments

\* Support comeback gameplay



\---



\# CANON DECISIONS



\* Death removes Coins.

\* Death does not eliminate players.

\* Wheel Of Death favors poorer players.

\* Comeback systems are intentional.



\---



\# OPEN QUESTIONS



\* Final Death Penalty

\* Combat Rules

\* Item-Based Combat

\* Combat Frequency



\---



\# CLAUDE REVIEW PACKAGE



Review Required:



1\. Economy Scaling

2\. Trophy Economy

3\. Building Balance

4\. Courier System

5\. Influence Zones

6\. Property System

7\. VIP System

8\. Roulette Design

9\. Comeback Systems

10\. Wealth Formula



\---



\# PLAYTEST REQUIRED



1\. Courier System

2\. Influence Zone Size

3\. Property Takeover Cost

4\. VIP Value

5\. Roulette Frequency

6\. Main Event Frequency

7\. Death Penalty

8\. Wealth Formula

9\. Trophy Costs



\---



\# CURRENT GDD STATUS



Completed:



\* Vision

\* Match Structure

\* Economy

\* Trophy System

\* Buildings

\* Property System

\* Board Structure

\* Casino Foundation

\* Combat Foundation



Pending:



\* Dice System

\* Item System

\* Minigames

\* Lobby \& Match Rules

\* Detailed Casino Systems

\* Production Roadmap



Current Progress Estimate:



70-80% of Early Access Foundation GDD





