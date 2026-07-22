# GDD_MINIGAMES

## Overview
Minigry rozgrywane są po każdej turze wszystkich graczy.

## Flow Minigry
1. Ekran opisu — nazwa, zasady, czas na przeczytanie
2. Ekran gotowości — każdy gracz potwierdza lub odpala odliczanie
3. Minigra
4. Ekran wyników — nagrody, animacje
5. Powrót na planszę

## Kategorie

### FFA (2-6 graczy)
Wszyscy przeciwko wszystkim.
Dostępne przy każdej liczbie graczy.

### TEAM_EVEN (1v1 / 2v2 / 3v3)
Tryby drużynowe z równą liczbą graczy.
Niedostępne przy nieparzystej liczbie graczy.

### ONE_VS_ALL (1 vs reszta)
Jeden gracz przeciwko wszystkim pozostałym.
Dostępne przy 2-6 graczy.

### ODD_SPECIAL (3 lub 5 graczy)
Minigry zaprojektowane specjalnie dla nieparzystej liczby graczy.

## Zasady Skalowania
- Każda minigra ma zdefiniowaną listę obsługiwanych liczb graczy.
- System losowania odfiltrowuje minigry niedostępne dla aktualnej liczby graczy.
- Minigry drużynowe są niedostępne przy nieparzystej liczbie graczy.
- Pula FFA musi być wystarczająco duża aby nieparzysty skład nie był odczuwalny.

## Kandydaci na Minigry

### FFA

#### Party Golf
Gracze rywalizują na serii 3-5 krótkich dołków rozgrywanych jednocześnie.
Za miejsca przyznawane są punkty.
Zwycięża gracz z najwyższym wynikiem po wszystkich dołkach.

#### Gorący Ziemniak
Jeden z graczy posiada bombę którą musi przekazać innym przed wybuchem.
Po każdym wybuchu rozpoczyna się kolejna runda aż do wyłonienia zwycięzcy.

#### Kradzież Korony
Korona pojawia się na środku mapy.
Wygrywa gracz który utrzyma ją najdłużej podczas całej rundy.

#### Katastrofa Totalna
Gracze próbują przetrwać serię losowych katastrof takich jak meteory, tornado,
lawa czy pioruny.
Każda katastrofa zmienia sytuację na arenie.

#### Bombowy Armagedon
Arena jest nieustannie bombardowana różnymi typami bomb.
Gracze muszą unikać wybuchów i przetrwać jak najdłużej.

#### Krusząca Arena
Podłoga stopniowo znika lub rozpada się pod stopami graczy.
Ostatni żywy gracz wygrywa.

#### Kolorowy Chaos
Na arenie pojawia się wskazany kolor.
Gracze muszą szybko stanąć na odpowiednim polu zanim pozostałe znikną.

#### Wyspa Zagłady
Arena stopniowo kurczy się i rozpada.
Dostępnej przestrzeni jest coraz mniej aż do finałowego starcia.

#### Ucieczka przed Lawą
Poziom lawy stale rośnie.
Gracze muszą wspinać się coraz wyżej i jednocześnie unikać innych uczestników.

#### Śmiertelna Linia
Każdy gracz kontroluje punkt który zostawia za sobą trwały ślad.
Ślady tworzą ściany — dotknięcie czyjejś linii lub własnej kończy grę dla tego gracza.
Arena stopniowo się zapełnia aż do wyłonienia ostatniego gracza.

---

### TEAM_EVEN

#### Piłka Zagłady
Drużyny walczą o zdobycie punktów poprzez wbicie gigantycznej piłki do bramki przeciwnika.
Dużo kolizji i chaosu fizycznego.

#### Most Wojenny
Drużyny próbują przepchnąć wspólny obiekt na stronę przeciwnika.
Wygrywa drużyna która pierwsza osiągnie cel.

#### Zbieracze Kryształów
Na mapie pojawiają się kryształy.
Drużyny zbierają je i dostarczają do swojej bazy, mogąc jednocześnie okradać przeciwników.

#### Kontrola Punktów
Na mapie znajdują się strefy przejęcia.
Drużyna posiadająca kontrolę nad strefami zdobywa punkty.

#### Kradzież Flag
Każda drużyna posiada własną flagę.
Celem jest przejęcie flag przeciwników i obrona własnej.

---

### ONE_VS_ALL

#### Deathrun / Sabotażysta
Jeden gracz aktywuje pułapki na torze przeszkód.
Pozostali próbują dotrzeć do mety.
Pułapki mogą zabijać, odrzucać lub cofać graczy.

#### Rekin
Jeden gracz wciela się w rekina polującego na pozostałych uczestników.
Ostatni ocalały lub gracz który przetrwa do końca czasu wygrywa.

#### Gigant
Jeden gracz kontroluje ogromnego potwora.
Pozostali próbują przetrwać, uciekać lub wykonywać cele na mapie.

#### Strażnik Skarbca
Jeden gracz broni skarbca lub artefaktu.
Pozostali próbują wykraść skarb przed upływem czasu.

---

### ODD_SPECIAL

#### Łowcy i Uciekinierzy
Mniejsza grupa graczy poluje na większą lub odwrotnie.
Różne cele dla obu stron.

#### Ochrona VIP
Jeden gracz jest VIP-em, część graczy pełni rolę ochrony.
Pozostali próbują go wyeliminować.

---

## Najmocniejsi Kandydaci
1. Deathrun / Sabotażysta
2. Party Golf
3. Gorący Ziemniak
4. Kradzież Korony
5. Katastrofa Totalna
6. Bombowy Armagedon
7. Piłka Zagłady
8. Krusząca Arena
9. Rekin
10. Most Wojenny
11. Śmiertelna Linia

## Open Questions
- Finalna lista minigier na Early Access
- Nagrody za wyniki w minigirach
- System punktacji w minigirach drużynowych
- Częstotliwość pojawiania się konkretnych minigier
- Czy kategorie drużynowe wspierają asymetryczne składy narzucane przez mechanikę
  planszy (np. 2v4, 1v5) — TEAM_EVEN zakłada równe drużyny, ONE_VS_ALL dokładnie
  1 vs reszta; niespójność zgłoszona przez GDD_CASINO (kolory Ruletki → drużyny)
