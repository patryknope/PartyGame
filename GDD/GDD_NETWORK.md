# GDD\_NETWORK

## Overview

PartyGame jest projektowane jako gra dla znajomych grających razem przez Discord lub podobny komunikator.

Nie projektujemy pod:

* matchmaking z losowymi graczami
* środowisko turniejowe
* publiczne lobby na dużą skalę

Typowy scenariusz:

* 2-6 znajomych
* wspólny voice chat
* sesja około 15 tur
* długość meczu około 15-30 minut

## Model Sieciowy

Peer-to-peer z hostem.

Host:

* jest autorytetem stanu gry
* jednocześnie normalnie gra
* jest single point of failure

Infrastruktura:

* Steam Networking
* Steam Lobby
* Steamworks

## Brak Host Migration

Wypadnięcie hosta nie przenosi roli hosta na innego gracza.

Powody:

* bardzo wysoki koszt implementacji
* nieproporcjonalna komplikacja dla pierwszego projektu multiplayer
* sesje są krótkie więc utrata hosta jest akceptowalna

## Grace Period i Timeout

Grace Period: 5 sekund

Działanie:

* gracz traci połączenie
* gra czeka cicho 5 sekund
* jeśli wrócił — nikt nic nie zauważył
* jeśli nie wrócił po 5 sekundach — pauza i komunikat dla pozostałych

Timeout: 60 sekund

Dotyczy wszystkich graczy włącznie z hostem.

## Disconnect Zwykłego Gracza

* Grace period 5 sekund
* Jeśli nie wrócił — pauza i głosowanie pozostałych graczy
* Jeśli timeout — gracz wypada z meczu
* Gra toczy się dalej dla pozostałych graczy
* Brak AI zastępującego gracza

## Disconnect Hosta

* Grace period 5 sekund
* Gra zostaje zamrożona — nikt nic nie może robić
* Jeśli host wrócił — gra toczy się dalej
* Jeśli timeout — sesja kończy się dla wszystkich

## Reconnect

Wspierany zarówno na planszy jak i podczas minigier.

Podczas minigry:

* Grace period 5 sekund działa tak samo
* Pauza jeśli gracz nie wrócił po 5 sekundach
* Gra czeka na reconnect

## Lobby Quality Check (LQC)

Przed startem meczu lobby wykonuje test jakości połączenia.

Informacje:

* ping do hosta
* stabilność połączenia
* ostrzeżenia dla słabego hosta

Cel:

* uniknięcie sytuacji gdzie osoba z niestabilnym internetem hostuje mecz

## Synchronizacja Stanu Gry

Największe wyzwanie techniczne projektu.

Elementy do synchronizacji:

* pozycje graczy
* wynik rzutu kostką
* stan planszy
* budynki
* przedmioty
* wydarzenia ruletki
* wyniki minigier

## Testy Sieciowe

Priorytet podczas fazy prototypu.

Scenariusze testowe:

* wysoki ping hosta
* utrata pakietów
* chwilowe rozłączenia
* reconnect hosta
* reconnect zwykłego gracza
* disconnect podczas planszy
* disconnect podczas minigry

## Canon Decisions

* Model sieciowy: peer-to-peer z hostem.
* Infrastruktura: Steam Networking.
* Brak host migration.
* Grace period: 5 sekund.
* Timeout: 60 sekund dla wszystkich.
* Zwykły gracz po timeoucie wypada, gra toczy się dalej.
* Host po timeoucie — koniec sesji dla wszystkich.
* Reconnect wspierany na planszy i podczas minigier.
* LQC wymagane przed startem sesji.
* Głosowanie graczy gdy ktoś wypada po timeoucie.
* Brak AI zastępującego gracza.

## Open Questions

* Dokładny przebieg głosowania graczy
* Szczegóły implementacji LQC
* Obsługa reconnectu w minigierach real-time

## Playtest Required

* Freeze gry podczas problemów hosta
* Grace period — czy 5 sekund to odpowiedni czas
* Timeout — czy 60 sekund to odpowiedni czas
* Reconnect podczas minigier real-time

