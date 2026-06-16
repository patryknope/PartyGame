# GDD_PRODUCTION_ORDER

## Filozofia

Największym ryzykiem projektu nie jest architektura sieciowa.
Największym ryzykiem jest: czy uda się stworzyć grywalną i angażującą grę.

Dlatego najpierw weryfikujemy gameplay, potem dodajemy multiplayer.

---

## Kolejność Etapów

### Etap 1 — Lokalny Prototyp

Cel: sprawdzić czy core gameplay jest fun i czy projekt jest realny.

Zakres:
- gracz i tury
- ruch po planszy
- ekonomia
- podstawowa plansza
- pierwsza minigrka

Definicja ukończenia Etapu 1:
- tury działają
- ruch działa
- ekonomia działa
- podstawowa plansza działa
- jedna minigrka działa

Nic więcej. Etap 1 nie zawiera budynków, itemów, ruletki ani VIP.

---

### Etap 2 — Multiplayer

Warunek wejścia: Etap 1 potwierdził że gra jest fun.

Zakres:
- Steam Networking
- lobby
- host/client
- synchronizacja podstawowych systemów

Definicja ukończenia Etapu 2:
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

## Zasady Kodowania Od Pierwszego Dnia

Zasady które zapobiegają dużym refaktorom przy dodawaniu multiplayera.

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

UI tylko wyświetla dane i wysyła żądania do managerów.

### Zasada 4 — Jedno źródło prawdy

```
TurnManager    → zarządza turami
EconomyManager → zarządza ekonomią
BoardManager   → zarządza planszą
ItemManager    → zarządza przedmiotami
```

Im mniej duplikacji stanu, tym mniej problemów przy multiplayerze.

---

## Przewidywane Managery

- GameManager
- TurnManager
- EconomyManager
- BoardManager
- ItemManager
- BuildingManager

Dokładna lista zostanie ustalona podczas Etapu 1.

---

## Znane Ryzyka

### Ryzyko 1 — Fałszywe poczucie bezpieczeństwa
Czysty lokalny kod nie gwarantuje braku problemów przy multiplayerze.
Synchronizacja ruchu, animacji, eventów i reconnect wymagają
prawdziwych testów sieciowych.

### Ryzyko 2 — Zbyt długi Etap 1
Etap 1 musi pozostać mały.
Jeśli rozrośnie się o budynki, itemy i ruletke —
wracamy do problemu odkładania multiplayera na koniec.

---

## Canon Decisions
- Najpierw lokalny prototyp, potem multiplayer, potem content.
- Etap 1 kończy się po turach, ruchu, ekonomii, planszy i jednej minigrence.
- Wszystkie systemy pisane przez centralne managery.
- UI nie zawiera logiki gry.
- Jeden właściciel danych dla każdego systemu.
- Jedno źródło prawdy dla stanu gry.

## Open Questions
- Dokładna lista managerów
- Szczegółowy zakres podstawowej planszy w Etapie 1
- Definicja "podstawowej planszy" — ile kafelków, ile rozgałęzień

## Playtest Required
- Etap 1 — czy core gameplay jest fun
- Etap 2 — testy sieciowe z celowo złym połączeniem
