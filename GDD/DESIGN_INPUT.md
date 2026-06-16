# DESIGN_INPUT

## Data: 2026-06-16

## Temat: Lobby & Match Rules — podsumowanie sesji

## Kontekst

Dzisiaj ustaliliśmy system Lobby i ustawień meczu.
Poniżej znajdziesz wszystkie przyjęte decyzje.
Zapoznaj się z nimi i podziel się swoimi przemyśleniami.
Szczegóły każdego systemu znajdziesz w plikach GDD projektu.

---

## Decyzje przyjęte dziś

### Lobby

- Host tworzy pokój i kontroluje wszystkie ustawienia meczu.
- Gracze wybierają wygląd pionka (kosmetyka, brak wpływu na rozgrywkę).
- Early Access: tylko plansza Casino.
- Nowe plansze będą dodawane w przyszłości.

### Ustawienia meczu (konfigurowane przez hosta)

- Długość meczu: 10 / 15 (domyślnie) / 20 / 30 tur
- Startowe Coins: konfigurowalne (wartość domyślna do ustalenia)
- Dodatkowe opcje ekonomiczne: planowane (szczegóły otwarte)
- Trofea: włącz/wyłącz kategorie, zmiana liczby

### Kolejność graczy

- Domyślnie: losowa na starcie meczu

### Kości startowe

- Każdy gracz startuje z Basic Dice
- Brak wyboru kości w lobby
- Dodatkowe kości zdobywa się podczas gry

---

## Otwarte pytania do przemyślenia

1. Jaka powinna być domyślna liczba startowych Coins?
   Bierz pod uwagę że gracze będą chcieli kupować budynki, przedmioty i trofea.
   Ekonomia powinna tworzyć napięcie — gracze nie powinni móc kupić wszystkiego.

2. Jakie dodatkowe opcje ekonomiczne warto dać hostowi do konfiguracji?
   Przykłady: mnożnik dochodów, koszt trofeów, koszt budynków?

3. Czy głosowanie graczy nad konfiguracją trofeów to dobry pomysł?
   Obecnie host decyduje sam. Czy warto dodać opcję głosowania?

4. Czy kolejność graczy powinna być powiązana z wynikami poprzednich meczów?
   Inspiracja: Pummel Party — przegrany zaczyna następny mecz pierwszy.

5. Czy masz inne pomysły na ustawienia lobby które mogłyby być interesujące?

---

## Relevantne pliki GDD

- GDD_LOBBY.md
- GDD_MATCH.md
- GDD_ECONOMY.md
- GDD_TROPHIES.md
