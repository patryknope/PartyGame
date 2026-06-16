# GDD_ARCHITECTURE

## Struktura Folderów

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

## Autoload
Singletony działające globalnie przez cały czas trwania gry.

Przewidywane:
- GameManager
- NetworkManager
- AudioManager

## Core
Systemy globalne działające na każdej planszy.

Zawiera:
- tury
- ruch gracza
- ekonomia
- eventy
- minigry
- multiplayer

Core pozostaje płaski dopóki liczba plików nie uzasadni podziału na podfolderów.

## Board
Mechaniki planszy i ruchu gracza.

Każda plansza ma własny podfolder:
```
board/
├── casino/
├── harbor/        # przyszłość
├── wild_west/     # przyszłość
└── space_station/ # przyszłość
```

## Minigames
Każda minigrka w osobnym folderze.

Każdy folder minigry zawiera:
- sceny
- skrypty
- zasoby
- UI

## Data
Dane konfiguracyjne oddzielone od kodu.

Zawiera:
- definicje przedmiotów
- definicje budynków
- konfiguracje plansz
- balans ekonomii

## Scenes
Główne sceny gry.

Przykłady:
- MainMenu.tscn
- Lobby.tscn
- LoadingScreen.tscn
- BoardScene.tscn

## Assets
Zasoby graficzne i dźwiękowe.

Podfolderów:
- art/
- audio/
- fonts/

## Kluczowa Zasada Architektoniczna
Core nie powinien znać szczegółów konkretnej planszy.

Mechaniki specyficzne dla planszy zostają w module planszy.

Przykład Casino:
- ruletka → board/casino/
- dealer → board/casino/
- VIP Room → board/casino/
- wydarzenia kasynowe → board/casino/

## Canon Decisions
- Struktura folderów jak powyżej.
- Core pozostaje płaski dopóki nie zajdzie potrzeba podziału.
- Każda plansza ma własny podfolder w board/.
- Każda minigrka ma własny podfolder w minigames/.
- Core nie zna szczegółów konkretnej planszy.
- Dane konfiguracyjne żyją w data/, nie w kodzie.

## Open Questions
- Szczegółowa zawartość autoload/
- Szczegółowa zawartość core/
- Struktura data/ gdy pojawią się pierwsze definicje

## Playtest Required
- Separacja core/ od board/ w praktyce
- Refaktor core/ gdy liczba plików uzasadni podział
