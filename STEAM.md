# PartyGame — przygotowanie do Steam

Stan: gra ma warstwę multiplayer host-authoritative na godotowym High-Level
Multiplayer API. Dziala dzis po LAN (ENet). Podmiana transportu na Steam
wymaga TYLKO krokow ponizej — logika gry, lobby i synchronizacja zostaja
bez zmian.

## Krok 1 — Konto Steamworks (robi Michal)

1. Zaloz konto na https://partner.steamgames.com
2. Oplac Steam Direct Fee (100 USD za aplikacje; wraca po 1000 USD przychodu)
3. Wypelnij dane podatkowe/bankowe (W-8BEN dla osoby z Polski)
4. Utworz aplikacje — dostaniesz **App ID** (zapisz go!)

Do momentu otrzymania App ID rozwijamy sie na testowym App ID **480**
(Spacewar) — plik `steam_appid.txt` w repo juz go zawiera.

## Krok 2 — GodotSteam (robi Claude Code po otrzymaniu App ID lub od razu na 480)

1. Pobierz **GodotSteam GDExtension** (wersja dla Godot 4.x):
   https://github.com/GodotSteam/GodotSteam/releases
2. Wypakuj do `addons/godotsteam/` w repo
3. Pobierz tez **SteamMultiplayerPeer**:
   https://github.com/GodotSteam/MultiplayerPeer/releases
4. W `autoload/network_manager.gd` podmien dwie funkcje:
   - `_create_host_peer()` -> `SteamMultiplayerPeer` + `Steam.createLobby(...)`
   - `_create_client_peer()` -> `SteamMultiplayerPeer.connect_lobby(lobby_id)`
5. Lobby UI w `ui/main_menu.gd`: zamiast pola IP — lista lobby znajomych
   (`Steam.requestLobbyList()`) i zaproszenia (`Steam.activateGameOverlayInviteDialog`)
6. `steam_appid.txt` musi lezec obok exe podczas developmentu
   (NIE dolaczaj go do buildu wysylanego na Steam)

## Krok 3 — Export buildu

1. W edytorze Godot: Editor -> Manage Export Templates -> Download and Install
2. Preset "Windows" jest juz skonfigurowany w `export_presets.cfg`
   (embed PCK, dolacza pliki .json z data/)
3. Project -> Export -> Windows -> Export Project -> `build/PartyGame.exe`

## Krok 4 — Wrzucenie buildu na Steam (SteamPipe)

1. W Steamworks: App Admin -> SteamPipe -> Depots — utworz depot (Windows 64-bit)
2. Pobierz Steamworks SDK, uzyj `tools/ContentBuilder`:
   - `app_build.vdf` z App ID i sciezka do `build/`
   - `steamcmd +login <konto> +run_app_build app_build.vdf`
3. W Steamworks ustaw build jako default na branchu `default` (lub `beta`)

## Krok 5 — Strona sklepu (robi Michal, grafiki mozna zlecic/wygenerowac)

Wymagane materialy:
- Capsule: 231x87, 467x181, 616x353, 1232x706 px (header/main capsule)
- Min. 5 screenshotow 1920x1080 (tryb `godot -- screenshots` robi 1280x720 —
  do fina lnych screenow uruchom gre w 1920x1080)
- Krotki opis + opis pelny (PL + EN)
- Trailer (opcjonalny, ale mocno zalecany)
- Oznaczenie Early Access + opis planu rozwoju (mamy go w GDD_PRODUCTION)

## Krok 6 — Przed premiera Early Access

- [ ] Steam Networking zamiast ENet (krok 2)
- [ ] Grace period 5 s / timeout 60 s przy rozlaczeniach (GDD_PHASE2 — TODO)
- [ ] Reconnect (GDD_PHASE2 — TODO)
- [ ] Lobby Quality Check (GDD_PHASE2 — TODO)
- [ ] Achievements (opcjonalnie na start)
- [ ] Playtest z realnymi ludzmi przez Steam Remote Play / beta branch

## Ograniczenia obecnej wersji multiplayer (v1, udokumentowane)

- Transport: ENet po LAN/IP (Steam P2P po kroku 2)
- Rozlaczenie w trakcie meczu przerywa sesje (brak grace period)
- Online dziala minigra Kolorowy Chaos; Goracy Ziemniak i Kradziez Korony
  sa na razie tylko w hotseat (filtr w MinigameManager)
- Itemy Extra Roll i Loaded Dice wylaczone online (wymagaja prywatnej
  odpowiedzi hosta — zadanie na Etap 2.1)
