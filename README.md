# Hjemmeserver – kort prosjektkontekst

Sist oppdatert: 2026-08-09

## Server
- Ubuntu-server, bruker `espenhoh`
- LAN-IP: `10.0.0.20`
- Hovedlagring: ca. 18 TB under `/srv/storage`
- Gammel 1,5 TB WD-disk: `/mnt/olddisk`
  - skal behandles som READ-ONLY original inntil videre
- Windows-PC på LAN: `10.0.0.10`
- Server bruker 5 GHz Wi-Fi, ca. 245 Mbit/s målt med iperf

## Media
- Plex kjører i Docker
- qBittorrent kjører bak Gluetun + PIA
- PIA port forwarding fungerer
- Downloads: `/srv/storage/downloads`
- Plex-filmer: `/srv/storage/media/Movies`

## Immich
- Immich kjører i Docker Compose
- Web: `http://10.0.0.20:2283`
- PostgreSQL-data: `/srv/docker/immich/postgres`
- Målet er at Immich blir familiens sentrale bildeløsning
- Hvert familiemedlem skal etter oppryddingen kunne bruke egen Immich-bruker og automatisk mobilbackup

## Fotoarkiv – prinsipp
- `archive/` = komplette kildearkiver/originalkopier
- `photos/` = bilder/videoer som skal eksponeres read-only til Immich
- Ikke slett originaldata før hele fotoarkivet er verifisert

Aktuelle områder:

```text
/srv/storage/archive/
/srv/storage/photos/
```

## Gammel OneDrive-konto
rclone-remote:
```text
onedrive_huahua:
```

Komplett verifisert OneDrive-kopi:
```text
/srv/storage/archive/OneDrive
```

- 143.599 GiB
- 20 322 filer
- `rclone check`: 0 differences
- Personal Vault (`个人保管库`) var eneste problem og ble ekskludert

Mediefiler er trukket ut til:
```text
/srv/storage/photos/OneDrive
```

- 14 192 bilder/videoer
- ca. 133 GB
- 14 190 var identiske ved full `cmp`-sjekk
- 2 avvikende MP4-filer ble kopiert på nytt og kontrollert OK
- Denne mappen skal brukes read-only som Immich External Library

## Nyere OneDrive-konto
rclone-remote:
```text
onedrive_espen:
```

Arkivmål:
```text
/srv/storage/archive/onedrive_espen
```

Denne kopieringen pågår / skal verifiseres før bilder og videoer trekkes ut til:
```text
/srv/storage/photos/onedrive_espen
```

## Andre gamle kilder
Personlige data er allerede kopiert fra gammel disk, blant annet:
```text
/srv/storage/archive/Tryms bilde
/srv/storage/archive/Jottacloud
```

Disse skal ikke slettes før samlet fotoarkiv er kontrollert.

## Backupmål
Når oppryddingen er ferdig:
- Immich/server er primær lagring
- plan: to eksterne ca. 2 TB-disker for uerstattelige personlige data
- én lokal backup + én offsite/rotasjonsbackup
- Plex/torrents trenger ikke nødvendigvis samme backupnivå

## Arbeidsmåte
- Gi konkrete Linux-kommandoer steg for steg
- Hold oppsettet så enkelt som mulig
- Foretrekk verifisering før sletting eller omstrukturering
- Ikke foreslå sletting av originale fotoarkiver før helheten er kontrollert
