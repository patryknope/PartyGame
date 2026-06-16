# GDD_PHASE2

## Przegląd Fazy 2

Faza 2 to Technical Foundation.

Celem nie jest napisanie gry.
Celem jest zbudowanie fundamentu pod grę i potwierdzenie
że core gameplay jest fun zanim zainwestujemy czas w multiplayer.

Programista: Claude Code

---

## Model Sieciowy

Peer-to-peer z hostem.

Host:
- jest autorytetem stanu gry
- jednocześnie normalnie gra
- jest single point of failure

Infrastruktura:
- Steam Networking
- Steam Lobby
- Steamworks

Brak host migration.

---

## Kolejność Etapów

### Etap 1 — Lokalny Prototyp

Cel: potwierdzić że core gameplay jest fun i projekt jest realny.

Zakres:
- gracz i tury
- ruch po planszy
- ekonomia (coiny)
- podstawowa plansza Casino
- jedna minigrka

Definicja ukończenia:
- gracz pojawia się na planszy
- tury działają lokalnie
- ruch po planszy działa
- ekonomia działa
- jedna minigrka działa od początku do końca
- pętla: plansza → minigrka → plansza działa
- można zacząć nowy mecz bez restartu gry
- Michał rozegrał kilka pełnych meczów
- core gameplay jest fun
- brak krytycznych bugów blokujących rozgrywkę

Poza zakresem Etapu 1:
- multiplayer
- budynki
- itemy
- ruletka
- VIP
- dodatkowe minigry
- docelowa grafika i audio
- polished UI

---

### Etap 2 — Multiplayer Prototype

Warunek wejścia: Etap 1 potwierdzył że gra jest fun.

Zakres:
- Steam Networking
- lobby
- host/client
- synchronizacja podstawowych systemów

Definicja ukończenia:
- host tworzy lobby
- klient dołącza
- obaj widzą planszę i pionki
- tury działają przez sieć
- ekonomia działa przez sieć
- jedna minigrka działa przez sieć

---

### Etap 3 — Pozostały Content

Warunek wejścia: Etap 2 działa stabilnie.

Zakres:
- budynki
- itemy
- ruletka
- VIP Room
- dodatkowe minigry

---

## Architektura Projektu

### Struktura Folderów

```
res://
├── autoload/      # GameManager, NetworkManager, AudioManager
├── core/          # systemy globalne (płaski na razie)
├── board/         # plansza i ruch gracza
│   └── casino/    # mechaniki kasyna
├── minigames/     # każda minigra w osobnym folderze
├── players/       # gracz, dane gracza
├── items/         # przedmioty
├── buildings/     # budynki
├── ui/            # interfejs użytkownika
├── data/          # konfiguracje i definicje
├── scenes/        # główne sceny (menu, lobby, loading)
└── assets/        # grafiki, dźwięki, czcionki
```

### Kluczowa Zasada Architektoniczna

Core nie zna szczegółów konkretnej planszy.

Mechaniki Casino zostają w board/casino/:
- ruletka
- dealer
- VIP Room
- wydarzenia kasynowe

### Przewidywane Managery

- GameManager
- TurnManager
- EconomyManager
- BoardManager
- ItemManager
- BuildingManager

Dokładna lista zostanie ustalona podczas Etapu 1.

### State Machine

Minimalny State Machine wymagany od początku.

Minimalne stany:
- MainMenu
- TuraGracza
- RuchGracza
- Minigrka
- KoniecMeczu

Nie budujemy rozbudowanej hierarchii stanów w Fazie 2.

---

## Zasady Kodowania

Obowiązują od pierwszej linijki kodu.

### Zasada 1 — Zawsze przez managery

Źle:
```
gracz.coiny += 10
```

Dobrze:
```
EconomyManager.dodaj_coiny(gracz_id, 10)
```

### Zasada 2 — Jeden właściciel danych

Tylko EconomyManager zmienia coiny.
Tylko TurnManager zmienia tury.
Tylko BoardManager zmienia stan planszy.
Nikt inny nie modyfikuje tych danych bezpośrednio.

### Zasada 3 — UI nie zawiera logiki

Źle:
```
przycisk → dodaj 50 monet
```

Dobrze:
```
przycisk → EconomyManager.request_add_coins(gracz_id, 50)
```

### Zasada 4 — Jedno źródło prawdy

```
TurnManager    → zarządza turami
EconomyManager → zarządza ekonomią
BoardManager   → zarządza planszą
ItemManager    → zarządza przedmiotami
```

---

## Architektura Sieciowa

### Grace Period i Timeout

Grace Period: 5 sekund
- gra czeka cicho 5 sekund po utracie połączenia
- jeśli gracz wrócił — nikt nic nie zauważył
- jeśli nie wrócił — pauza i komunikat

Timeout: 60 sekund dla wszystkich graczy.

### Disconnect Zwykłego Gracza

- grace period 5 sekund
- pauza i głosowanie pozostałych graczy
- po timeoucie gracz wypada z meczu
- gra toczy się dalej dla pozostałych
- brak AI zastępującego gracza

### Disconnect Hosta

- grace period 5 sekund
- gra zostaje zamrożona
- jeśli host wrócił — gra toczy się dalej
- po timeoucie — sesja kończy się dla wszystkich

### Reconnect

Wspierany na planszy i podczas minigier.

### Lobby Quality Check (LQC)

Wymagane przed startem sesji.

Sprawdza:
- ping do hosta
- stabilność połączenia
- ostrzeżenia dla słabego hosta

---

## Narzędzia

Programista: Claude Code

Claude Code bezpośrednio pisze i modyfikuje pliki projektu Godot.
Michał testuje i daje feedback.
Konfiguracja Claude Code — do ustalenia przed rozpoczęciem Etapu 1.

---

## Canon Decisions

- Peer-to-peer z hostem, Steam Networking.
- Brak host migration.
- Grace period 5 sekund, timeout 60 sekund.
- Zwykły gracz po timeoucie wypada, gra toczy się dalej.
- Host po timeoucie — koniec sesji dla wszystkich.
- Reconnect wspierany na planszy i podczas minigier.
- LQC wymagane przed startem sesji.
- Głosowanie graczy gdy ktoś wypada.
- Struktura folderów jak powyżej.
- Core nie zna szczegółów konkretnej planszy.
- Minimalny State Machine wymagany od początku.
- Wszystkie operacje przez centralne managery.
- UI nie zawiera logiki gry.
- Jedno źródło prawdy dla każdego systemu.
- Najpierw lokalny prototyp, potem multiplayer, potem content.
- Etap 1 kończy się po turach, ruchu, ekonomii, planszy i jednej minigrence.
- Programista: Claude Code.

## Open Questions

- Dokładna lista managerów
- Szczegóły implementacji LQC
- Konfiguracja Claude Code
- Szczegółowy zakres podstawowej planszy w Etapie 1

## Playtest Required

- Etap 1 — czy core gameplay jest fun
- Reset rozgrywki — czy drugi mecz działa bez restartu
- Etap 2 — testy sieciowe z celowo złym połączeniem
- Grace period — czy 5 sekund to odpowiedni czas
- Timeout — czy 60 sekund to odpowiedni czas
- Reconnect podczas minigier real-time
