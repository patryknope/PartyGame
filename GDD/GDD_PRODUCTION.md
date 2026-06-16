# GDD_PRODUCTION

## Overview
Dokument definiuje kierunek artystyczny, pipeline produkcji graficznej
oraz narzędzia używane w projekcie PartyGame.

---

## Styl Wizualny

Główny styl:
- 3D Low Poly
- Cartoon
- Kolorowy
- Czytelny z dużej odległości
- Stylizowany zamiast realistycznego

Inspiracje wizualne:
- Fall Guys
- Mario Party
- Pummel Party
- Stumble Guys

Nie kopiujemy żadnej z tych gier.
Traktujemy je wyłącznie jako punkt odniesienia.

---

## Filozofia Humoru

Inspiracje:
- Looney Tunes
- Tom & Jerry
- Klasyczne kreskówki slapstickowe

Przenosimy filozofię humoru, nie styl wykonania.

Tak:
- Przesadzone przedmioty
- Absurdalne sytuacje
- Humor wizualny
- Przesadzone efekty
- Zabawne animacje zwycięstwa
- Przesadzone proporcje obiektów
- Komediowe reakcje postaci

Nie:
- Zaawansowane deformacje modeli
- Pełny squash & stretch
- Animacje wymagające profesjonalnego animatora
- Skomplikowane systemy animacyjne

---

## Główne Założenia

### Czytelność ponad szczegółowość
Gracz obserwuje planszę z oddalenia.

Priorytet:
- Rozpoznawalne sylwetki
- Czytelne budynki
- Wyraźne kolory
- Łatwe rozpoznawanie graczy

Nie priorytet:
- Szczegółowe tekstury
- Realizm
- Wysoki poziom detali

### Stylizacja ponad realizm
Przykłady:
- Większe budynki niż wynikałoby z proporcji
- Przesadzone szyldy
- Duże elementy dekoracyjne
- Humorystyczne proporcje

---

## System Postaci

### Cartoon Mascots
Postacie oparte na modułowym systemie części.

Założenia:
- Wspólny korpus dla wszystkich postaci
- Wspólny szkielet
- Wspólny zestaw animacji
- Wymienne elementy wizualne

### Moduły Postaci

Głowa:
- Lis, panda, rekin, kaczka, kot
- Żaba, szop, papuga
- Możliwe rozszerzenia w przyszłości

Korpus:
- Oddzielny element
- Możliwość mieszania z dowolną głową

Strój:
- Pirat, astronauta, VIP kasynowy
- Ninja, król, wiking

Nakrycie głowy:
- Korona, cylinder, hełm astronauty
- Kapelusz pirata

Plecy / Dodatki:
- Rakieta, papuga, plecak odrzutowy
- Skrzynia skarbów

### Dlaczego ten system

Nie trzeba tworzyć setek gotowych skinów.
Przykładowo:
- 10 głów
- 10 korpusów
- 20 strojów
- 20 nakryć głowy
- 20 dodatków

Tworzy ogromną liczbę kombinacji przy małej liczbie assetów.
Gracz buduje własną unikalną postać.

### Skalowalność na minigry
Każda minigra używa:
- Tych samych modeli postaci
- Tego samego szkieletu
- Tych samych animacji

Zmienia się wyłącznie otoczenie i mechanika minigry.

---

## Tekstury

Preferowany kierunek:
- Jednolite materiały
- Proste kolory
- Ewentualnie lekkie gradienty

Unikać:
- Realizmu
- Skomplikowanych tekstur
- PBR wymagającego dużej ilości pracy

---

## Plansze

Każda plansza powinna posiadać własną tożsamość wizualną.

Casino:
- Złoto
- Czerwienie
- Fiolety
- Neony
- Żetony
- Ruletki
- Klimat teleturnieju zamiast realistycznego kasyna

Cel:
Gracz po jednym screenie powinien od razu rozpoznać motyw planszy.

---

## Efekty Specjalne (VFX)

VFX budują klimat bardziej niż szczegółowe modele.

Priorytet:
- Eksplozje
- Confetti
- Jackpoty
- Monety
- Błyski
- Efekty zwycięstwa

Dobre VFX poprawiają odbiór gry bardziej niż szczegółowe modele.

---

## Pipeline Assetów

Etap 1 — Prototyp:
- Kenney.nl jako główna baza
- Darmowe assety Fab.com
- Mixamo (animacje)

Etap 2 — Grywalny prototyp:
- Pełne mechaniki Kasyna
- Działający multiplayer
- Działające minigry

Etap 3 — Wymiana i rozbudowa:
- Fab.com
- Sketchfab
- AI 3D (Meshy, Tripo) dla unikalnych elementów
- Ewentualnie własne modele w Blenderze

### Kenney jako długoterminowa baza
Kenney nie jest tylko placeholderem.

Możliwe zastosowania:
- Baza dla prototypu
- Źródło gotowych assetów
- Źródło modeli do dalszych modyfikacji

Docelowo:
- Start na assetach Kenney
- Stopniowe przerabianie
- Zastępowanie własnymi modelami w tym samym stylu

---

## Narzędzia

Modele 3D:
- Kenney.nl (darmowe, low poly)
- Fab.com (darmowe i płatne paczki)
- Sketchfab (darmowe modele)
- Meshy.ai (AI, unikalne elementy)
- Tripo3D (AI, unikalne elementy)

Animacje:
- Mixamo (darmowe, Adobe)

Blender:
- Wstępnie zaakceptowany
- Tylko do prostych modeli low poly
- Zakres: budynki, dekoracje, przedmioty, elementy plansz
- Bez zaawansowanego modelowania i riggingu
- Wprowadzany dopiero po etapie prototypu

---

## Priorytety Produkcji

1. Gameplay
2. Multiplayer
3. Minigry
4. UI
5. VFX
6. Grafika 3D

Grafika nigdy nie ma pierwszeństwa przed grywalnym prototypem.

---

## Rola ChatGPT — Konsultant Artystyczny

Zakres:
- Ocena spójności assetów
- Ocena kierunku wizualnego plansz
- Ocena postaci i budynków
- Ocena kolorystyki
- Ocena czy nowe assety pasują do stylu gry
- Pomoc w utrzymaniu spójności wizualnej

ChatGPT nie podejmuje decyzji projektowych.
ChatGPT nie aktualizuje dokumentacji.
Wszystkie decyzje zatwierdza Michał i dokumentuje Claude.

---

## Canon Decisions
- Gra jest w 3D.
- Minigry mogą być w 2D.
- Styl wizualny: 3D Low Poly Cartoon.
- Filozofia humoru: Looney Tunes / slapstick bez zaawansowanych animacji.
- Postacie: system Cartoon Mascots z modułowymi częściami.
- Kenney.nl jest główną bazą assetów, nie tylko placeholderem.
- Mixamo jest głównym źródłem animacji.
- Blender wstępnie zaakceptowany, wprowadzany po etapie prototypu.
- Gameplay ma zawsze pierwszeństwo przed grafiką.

## Open Questions
- Finalny wygląd postaci gracza
- Liczba kosmetyków na Early Access
- Szczegółowy wygląd planszy Casino
- Zakres własnych modeli w Blenderze
