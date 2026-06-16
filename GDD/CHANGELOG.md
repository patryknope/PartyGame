# CHANGELOG

## 2026-06-12

### ACCEPTED

Buildings are permanent.

Design Notes:
- Strategic permanence

Important Exclusions:
- Cannot be sold
- Cannot be moved

---

### ACCEPTED

Production Buildings use Courier Delivery.

Design Notes:
- Visible production process
- Increased board interaction

Playtest Required:
- Frustration level
- Delivery pacing

---

### ACCEPTED

Every Trophy has equal value.

---

### ACCEPTED

Roulette is the primary Casino mechanic.

---

## 2026-06-13

### ACCEPTED

Special Room is the generic system name.

Casino Variant:
- VIP Room

---

### ACCEPTED

Dice are a separate progression category.

Important Exclusions:
- Not Items
- No rarity tiers

---

### ACCEPTED

Unlimited Dice Collection.

Important Exclusions:
- No Dice Slots
- No Dice Loadouts

---

### ACCEPTED

Jackpot Dice.

Design Notes:
- Mostly small rewards
- Rare medium rewards
- Very rare major rewards
- Rare VIP Key rewards

Important Exclusions:
- No teleports

Playtest Required:
- Reward satisfaction
- Bust frustration level

---

### ACCEPTED

Courier travel time should not exceed item production time.

Playtest Required:
- Production pacing

---

### ACCEPTED

Item Rarity System.

Four tiers:
- Common
- Uncommon
- Rare
- Legendary

Design Notes:
- Rarity affects shop appearance chance and price
- Exact rates and prices to be determined during playtesting

---

### ACCEPTED

Initial Item Pool.

Utility Items:
- Extra Roll (Common)
- Shield (Common)
- Health Kit (Common)
- Copy Cat (Uncommon)
- Reverse (Uncommon)
- Loaded Dice (Rare)
- Room Key (Rare)
- Remote Shop (Rare)
- Swap (Legendary)

Warfare Items:
- Trap (Common)
- Punch (Uncommon)
- Rocket (Uncommon)
- Magnet (Uncommon)
- Bomb (Uncommon)
- Cursed Dice (Rare)
- Lucky Bastard (Legendary)
- Loaded Investigation (Legendary)

---

### ACCEPTED

Room Key is the generic name for Special Room access item.

Design Notes:
- Does not teleport player
- Player must still travel to Special Room
- Casino variant name: VIP Key

---

### ACCEPTED

REVIEW_LOG repurposed as rejected ideas log.

Design Notes:
- Records rejected ideas with reasons
- Prevents returning to same ideas in future
- Replaces previous review workflow

---

## 2026-06-16

### ACCEPTED

Lobby & Match Rules.

Design Notes:
- Host creates room and controls all match settings
- Character selection is cosmetic only
- Early Access ships with Casino board only
- Each player starts with Basic Dice only
- Turn order is random by default
- Match length configurable: 10 / 15 (default) / 20 / 30 turns
- Starting Coins are configurable (default value open question)

---

### ACCEPTED

Visual Style: 3D Low Poly Cartoon.

Design Notes:
- Inspired by Fall Guys, Mario Party, Pummel Party, Stumble Guys
- Humor philosophy from Looney Tunes / Tom & Jerry
- Stylization over realism
- Readability over detail

Important Exclusions:
- No advanced deformations
- No squash & stretch
- No complex animation systems

---

### ACCEPTED

Character System: Cartoon Mascots.

Design Notes:
- Modular character parts: head, body, outfit, headwear, back accessories
- Shared skeleton and animation set across all characters
- Same models used in all minigames
- Players build unique characters from parts

---

### ACCEPTED

Asset Pipeline.

Design Notes:
- Kenney.nl is primary asset source, not just placeholder
- Mixamo is primary animation source
- Blender accepted for later stages (simple low poly only)
- AI 3D tools (Meshy, Tripo) for unique individual assets

Important Exclusions:
- Blender not used during prototype stage
- No advanced modeling or rigging in Blender

---

### ACCEPTED

Production Priority Order.

Order:
1. Gameplay
2. Multiplayer
3. Minigames
4. UI
5. VFX
6. 3D Graphics

---

### ACCEPTED

ChatGPT role expanded to include Art Direction Consultant.

Design Notes:
- Evaluates asset consistency
- Evaluates visual direction of boards
- Does not make design decisions
- Does not update documentation

---

### ACCEPTED

Network Architecture.

Design Notes:
- Peer-to-peer z hostem
- Infrastruktura: Steam Networking, Steam Lobby, Steamworks
- Brak host migration
- Grace period: 5 sekund
- Timeout: 60 sekund dla wszystkich
- Zwykły gracz po timeoucie wypada, gra toczy się dalej
- Host po timeoucie — koniec sesji dla wszystkich
- Reconnect wspierany na planszy i podczas minigier
- LQC wymagane przed startem sesji
- Głosowanie graczy gdy ktoś wypada

---

### ACCEPTED

Production Order.

Design Notes:
- Etap 1: lokalny prototyp (tury, ruch, ekonomia, plansza, jedna minigrka)
- Etap 2: multiplayer (Steam Networking, lobby, synchronizacja)
- Etap 3: pozostały content (budynki, itemy, ruletka, VIP)
- Warunek przejścia do Etapu 2: core gameplay potwierdzone jako fun

---

### ACCEPTED

Project Folder Structure.

Design Notes:
- autoload/, core/, board/casino/, minigames/, players/, items/
- buildings/, ui/, data/, scenes/, assets/
- Core nie zna szczegółów konkretnej planszy
- Core pozostaje płaski dopóki nie zajdzie potrzeba podziału

---

### ACCEPTED

Coding Rules.

Design Notes:
- Wszystkie operacje przez centralne managery
- Jeden właściciel danych dla każdego systemu
- UI nie zawiera logiki gry
- Jedno źródło prawdy dla stanu gry
- Minimalny State Machine wymagany od początku

---

### ACCEPTED

Programmer: Claude Code.

Design Notes:
- Claude Code bezpośrednio pisze i modyfikuje pliki projektu Godot
- Michał testuje i daje feedback
- Konfiguracja Claude Code do ustalenia przed Etapem 1
