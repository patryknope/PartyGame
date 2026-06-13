# REVIEW_LOG

## Purpose

Log of rejected ideas and design decisions.

When an idea is rejected — record it here with a reason.

Goal: prevent returning to the same ideas in the future.

---

## Entry Format

### [IDEA NAME]

Date: YYYY-MM-DD

Description:
Short description of the idea.

Reason for rejection:
Why the idea was not accepted.

Related systems:
Which parts of the GDD are affected.

---

## Entries

### Service Tunnel

Date: 2026-06-13

Description:
Utility Item. Instantly move to the nearest service tunnel entrance, then choose an exit.

Reason for rejection:
Requires Casino board to have a service tunnel network. Architectural decision too large for a single item. May be reconsidered if Casino board design supports it.

Related systems:
GDD_ITEMS, GDD_CASINO

---

### Bomb (Original Version)

Date: 2026-06-13

Description:
Place a bomb on the board. After X turns it explodes dealing damage to all players in radius.

Reason for rejection:
Area bomb on a fixed tile does not fit a turn-based game. Players could too easily avoid it. Replaced with Bomb assigned to a specific player.

Related systems:
GDD_ITEMS

---

### Building Block (Legendary Warfare Item)

Date: 2026-06-13

Description:
Temporarily block a chosen player's building.

Reason for rejection:
Not rejected permanently. Postponed — too complex for initial item pool. To be reconsidered during future item expansion.

Related systems:
GDD_ITEMS, GDD_BUILDINGS
