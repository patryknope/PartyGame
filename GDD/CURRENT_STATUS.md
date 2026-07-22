# CURRENT_STATUS

## Current Stage

Etap 2 — Multiplayer: host-authoritative networking DELIVERED over LAN (ENet);
Steam transport swap prepared (see STEAM.md). Etap 1 scope still awaits
Michał's fun-playtest.

---

## How To Run The Prototype

- Repo root is the Godot 4 project — open it in Godot 4.6+ and press F5, or use `run_game.bat`
- Hotseat 2-4 players; minigame controls: P1 WASD, P2 arrows, P3 TFGH, P4 IJKL
- Technical check without playing: `godot --headless -- autotest` (plays 2 full matches)

---

## Current Focus

- Michał plays the prototype and evaluates: is the core loop fun?
- Feedback → iteration on board balance and minigame pacing
- Minigames (design of the next ones)
- Detailed Casino Systems

---

## Active Topics

- Etap 1 playtest & feedback
- Roulette board mechanic (Casino) — colors → teams, open questions in GDD_CASINO
- Minigames
- Detailed Casino Systems

---

## Next Planned Topics

1. Etap 1 playtest results
2. Balance iteration (board values, minigame rewards)
3. Second minigame
4. Detailed Casino Systems

---

## Development Priority

1. Etap 1 playtest (is it fun?)
2. Iteration on Etap 1
3. Multiplayer Prototype (Etap 2)
4. Vertical Slice
5. Testing
6. Early Access

---

## Open Questions

- Final Wealth Formula
- Final Death Penalty
- Property Purchase Cost
- Trophy Costs
- Building Costs
- Upgrade Costs
- Item prices per rarity tier
- Shop appearance rates per rarity tier
- Default Starting Coins value (prototype placeholder: 20)
- Full list of Economy lobby options

---

## Recent Major Decisions

- Multiplayer implemented host-authoritatively on Godot High-Level Multiplayer
  API: ENet/LAN today, GodotSteam SteamMultiplayerPeer as a drop-in transport
  swap (2 functions, see STEAM.md). Verified by a two-instance network
  autotest with identical final state (2026-07-22).
- Prototype now plays to the canon win condition: Main Trophy purchasable on the
  board (50 coins placeholder, respawns after purchase), most Trophies wins,
  coins break ties. Dice selection added (Basic/Safe/Risk). Minigame pool grew
  to 3: Kolorowy Chaos, Goracy Ziemniak, Kradziez Korony (2026-07-22).
- Roulette is the board foundation: the whole Casino board sits on one giant
  Roulette (3 colors: red/black/green); position = current color; Dealer spins
  at round start; team minigames use a color-weighted soft draw (2026-07-22).
- Etap 1 prototype implemented by Claude Code (2026-07-22) — details in CHANGELOG.
- Manager list for Etap 1: GameManager, PlayerManager, TurnManager, EconomyManager, BoardManager, MinigameManager.
- Basic board scope: 20-tile loop + 4-tile risky shortcut, data-driven (data/casino_board.json).
- First minigame: Kolorowy Chaos (FFA elimination, 2-4 hotseat).
- Claude Code workflow: direct repo file edits, validated via headless autotest.
- Lobby & Match Rules established.
- Visual Style accepted: 3D Low Poly Cartoon.
- Character System accepted: Cartoon Mascots (modular parts).
- Asset pipeline established: Kenney → prototyp → Fab/Sketchfab → AI 3D.
- Blender accepted for later stages only.
- ChatGPT role expanded to include Art Direction Consultant.
- Item System completed.
- Item Rarity System accepted (Common, Uncommon, Rare, Legendary).
- Initial Item Pool established (9 Utility, 8 Warfare).
- REVIEW_LOG repurposed as rejected ideas log.
- Dice became a separate progression category.
- Unlimited Dice Collection accepted.
- Courier System remains primary Production Building direction.
- Wheel Of Death supports trailing players.
- Special Room became the generic system name.
- Network Architecture established: peer-to-peer z hostem, Steam Networking.
- Production Order established: lokalny prototyp → multiplayer → content.
- Project Folder Structure established.
- Coding Rules established: managery, jedno źródło prawdy, UI bez logiki.
- Programmer: Claude Code.
