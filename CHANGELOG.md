# Dziennik zmian (CHANGELOG)

Ten plik opisuje zmiany w PartyGame prostym językiem — bez żargonu
programistycznego — żeby każdy mógł łatwo sprawdzić, co nowego pojawiło
się w grze. Najnowsze zmiany są na górze.

(Techniczny, szczegółowy dziennik decyzji projektowych znajduje się
osobno w `GDD/CHANGELOG.md` — ten plik jest wersją "dla ludzi".)

---

## 2026-07-22 — Lobby, animacje przedmiotów, żywsza plansza

### Dodano
- **Widok lobby przed grą przez internet** — teraz widać, kto już
  dołączył do gry, jak wygląda jego postać (miś w wybranym kolorze
  i z wybranym dodatkiem: czapka / okulary / kokarda / kwiatki), oraz
  kto jest już "Gotowy". Każdy gracz może sobie zmienić imię, kolor
  i dodatek przed startem. Gospodarz może odpalić mecz dopiero, gdy
  wszyscy zaznaczą gotowość.
- **Animacje przedmiotów** — użycie przedmiotu wygląda teraz efektownie:
  magnes ciągnie monety smugą złotych kółek od ofiary do gracza,
  rakieta i uderzenie (Punch) lecą łukiem do celu i wybuchają, tarcza
  tworzy pulsującą bańkę, pułapka zostawia obłoczek kurzu, a zamiana
  miejsc (Swap) rysuje wirujące linie między graczami.
- **Nowe przedmioty w sklepie**: Reverse (cofasz się zamiast iść do
  przodu), Copy Cat (kopiujesz wynik rzutu poprzedniego gracza), Punch
  (uderzenie: przeciwnik traci monety i cofa się o kilka pól).
- **Nowy typ pola na planszy: "?"** — pole niespodzianka: można na nim
  zyskać monety, stracić trochę monet, albo dostać za darmo losowy
  przedmiot.
- Więcej pól SKLEP i KARTY na planszy — więcej okazji do zakupów i do
  szybkiej gry w pokera po drodze, plansza nie jest już tak "pusta".

### Zmieniono
- Plansza jest teraz większa i lepiej widoczna na ekranie.
- Kolorowy Chaos (minigra) — kafelki areny teraz naprawdę **odpadają
  na stałe z każdą kolejną rundą** (nie tylko ciemnieją), więc plansza
  się kurczy i gra robi się coraz trudniejsza.

---

## 2026-07-22 — Poker i pełny zestaw kości

### Dodano
- Pola KARTY na planszy — stanięcie na takim polu rozdaje 5 kart w
  mini-pokerku (dobierasz karty, wymieniasz część, wygrywasz monety za
  układ).
- Nowa minigra: Poker Draw — każdy gracz dostaje 5 kart i jedną wymianę,
  wygrywa najlepszy układ.
- Nowe kostki do gry: Podróżna (2/4/8/10) oraz kostka JACKPOT (szansa na
  bonus, dodatkowy rzut albo "wybuch" i utratę monet).

---

## 2026-07-22 — Naprawki gry przez internet

### Naprawiono
- Automatyczne otwieranie portu w routerze (żeby granie przez internet,
  nie tylko w tej samej sieci Wi-Fi, działało bez grzebania w
  ustawieniach routera).
- Pokazywanie adresu IP hosta, żeby łatwiej było go podać znajomym.
- Limit czasu na dołączenie do gry (żeby aplikacja nie "wisiała" bez
  końca, gdy coś pójdzie nie tak z połączeniem).

---

## 2026-07-22 — Gra przez internet (multiplayer)

### Dodano
- Możliwość grania przez internet/sieć lokalną — jedna osoba zakłada
  grę (host), reszta dołącza po adresie IP i kodzie.
- Kolorowy Chaos działa już online — każdy gracz steruje swoim misiem
  z własnego komputera.
- Przygotowania pod Steam (na razie gra przez zwykłą sieć, obsługa
  Steama dojdzie później).

### Ograniczenia (na razie)
- W trakcie meczu odłączenie się gracza kończy sesję dla wszystkich
  (obsługa "doproszenia się" gracza z powrotem jest zaplanowana na
  później).
- Online działa na razie tylko z minigrą Kolorowy Chaos.

---

## 2026-07-22 — Plansza żyje: przedmioty i budynki

### Dodano
- Ptaki, chmury i motyle nad planszą, wodospad spływający do rzeki i
  stawu — plansza wygląda żywiej.
- Misie dostały dodatki (czapka / okulary / kokarda / kwiatek), rumieńce
  i dymki z emocjami (radość, smutek, złość, szok, moneta, gwiazdka).
- Pływające napisy "+10 / -5 / TROFEUM!" nad głową gracza, gdy coś się
  wydarzy.
- Pierwsze przedmioty do kupienia w sklepie: Extra Roll, Tarcza (Shield),
  Loaded Dice, Zamiana miejsc (Swap), Pułapka (Trap), Rakieta (Rocket),
  Magnes.
- Budynki — można postawić budynek ekonomiczny na wolnej działce, który
  co turę przynosi trochę monet; da się go rozbudować (poziomy 1-3).

---

## 2026-07-22 — Trofea, wybór kości, nowe minigry

### Dodano
- Główne Trofeum na planszy — widać je jako pulsującą złotą gwiazdę.
  Stanięcie na jego polu pozwala je kupić; po zakupie trofeum pojawia
  się w innym miejscu planszy.
- Wygrywa gracz z największą liczbą trofeów (przy remisie liczą się
  monety).
- Wybór kości przed każdym rzutem: Zwykła (1-8), Pewna (3-6), Ryzykowna
  (0 albo 10).
- Nowa minigra: Gorący Ziemniak — trzeba podawać sobie "ziemniaka",
  zanim wybuchnie.
- Nowa minigra: Kradzież Korony — noś koronę na głowie jak najdłużej,
  ale uważaj, bo inni mogą ci ją ukraść dotykiem.

---

## 2026-07-22 — Plansza i misie (oprawa graficzna)

### Dodano
- Tło planszy: niebo, słońce, ośnieżone góry, łąka z pagórkami, staw,
  drzewa, kwiatki, chmury.
- Ścieżka na planszy wygląda jak prawdziwa droga (pobocze, przerywana
  linia na środku).
- Misie zamiast zwykłych kropek jako pionki graczy — kołyszą się,
  mrugają, podskakują przy ruchu, a aktywny gracz ma złotą obwódkę.

---

## 2026-07-22 — Pierwsza grywalna wersja (Etap 1)

### Dodano
- Pierwsza wersja gry: 2-4 graczy przy jednym komputerze (tryb hotseat),
  tury, rzut kością, poruszanie się po planszy.
- Plansza testowa Kasyno: pętla 20 pól + ryzykowny skrót na 4 polach.
- Rozwidlenie na planszy z wyborem drogi; +20 monet za przejście przez
  START.
- Ekonomia: monety, które nigdy nie spadają poniżej zera.
- Pierwsza minigra: Kolorowy Chaos (stań na polu w podanym kolorze,
  zanim czas się skończy — kto się pomyli, odpada).
- Pełna pętla rozgrywki: plansza → minigra → wyniki → dalsza gra, bez
  restartowania aplikacji.

---

## 2026-06-16 — Plan produkcji i zasady gry wieloosobowej

### Ustalono
- Zasady lobby: gospodarz gry ustawia opcje meczu (długość: 10 / 15 /
  20 / 30 tur), wybór wyglądu postaci jest tylko kosmetyczny.
- Styl graficzny gry: kreskówkowy, low-poly 3D (inspiracje: Fall Guys,
  Mario Party, Pummel Party, Stumble Guys).
- System budowy postaci z wymiennych części (głowa, ciało, strój,
  nakrycie głowy, dodatki na plecach).
- Plan sieciowy gry wieloosobowej: jeden gospodarz gry, reszta graczy
  się łączy; docelowo przez Steam.
- Kolejność prac nad grą: najpierw sama rozgrywka, potem tryb
  wieloosobowy, potem minigry, interfejs, efekty specjalne, na końcu
  grafika 3D.

---

## 2026-06-13 — System przedmiotów i kości

### Ustalono
- Kości do gry to osobny system od przedmiotów — można ich zbierać bez
  ograniczeń.
- Kość Jackpot: najczęściej mały bonus, rzadziej średni, bardzo rzadko
  duża nagroda.
- System rzadkości przedmiotów: pospolite, niepospolite, rzadkie,
  legendarne — im rzadszy przedmiot, tym drożej i tym rzadziej pojawia
  się w sklepie.
- Pierwsza lista planowanych przedmiotów (część z nich jest już w grze,
  reszta czeka na wdrożenie), np. Apteczka, Klucz VIP, Przeklęte Kości,
  Szczęściarz.

---

## 2026-06-12 — Fundamenty gry

### Ustalono
- Budynki stawia się na stałe — nie da się ich sprzedać ani przenieść.
- Towary z budynków produkcyjnych dostarcza kurier (widoczny na
  planszy, a nie "znikające" zasoby).
- Każde trofeum jest warte dokładnie tyle samo — nie ma trofeów
  "lepszych" od innych.
- Ruletka jako główny mechanizm planszy Kasyno.
- Powstała pierwsza wersja dokumentacji projektu (GDD) opisująca
  wszystkie systemy gry.
