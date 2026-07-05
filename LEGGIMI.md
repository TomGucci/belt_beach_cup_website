# BELT Beach Cup — guida al sito

Tutto il sito è in un solo file: `index.html`. Nessuna dipendenza, nessun backend: lo apri col browser e funziona.

## 1. Cose da personalizzare subito

Cerca il simbolo 🔧 dentro `index.html`: segna tutti i punti da sistemare.

- **Nomi squadre** → oggetto `SQUADRE` in cima allo `<script>`. Sostituisci i segnaposto (`Coppia M1`, `Coppia FA1`, ...) con i nomi reali. Nel 2×2 maschile e misto **l'ordine della lista determina gli accoppiamenti** del primo turno (1ª vs 2ª, 3ª vs 4ª, ...): usalo per fare il seeding.
- **Shop** → le 5 grafiche ufficiali sono già inserite (drago, onda top+pantaloncino, fenice, sakura); controlla prezzi e taglie.
- **Location** → mappa (`mappa_belt.png`) e indirizzo Playa Solero già inseriti; la mappa cliccata apre Google Maps.
- **Contatti e sponsor** → link Instagram/WhatsApp/email e loghi.
- **Regolamento** → i testi sono una base ragionevole (set a 21, finali 2 su 3): controlla che rispecchino le tue regole vere.

## 2. Come inserire i risultati

Ogni partita ha un **codice** visibile sul sito (es. `MV1-3` = Maschile, tabellone Vincenti, turno 1, partita 3; `FA-7` = girone Femminile A, partita 7; `XP4-2` = misto (X), tabellone Perdenti, turno 4).

Tu inserisci **solo il punteggio**: il vincitore viene dedotto dai set e il sito propaga tutto da solo (avanzamenti nel tabellone, discesa nel tabellone perdenti, classifiche gironi, qualificate alla fase finale, migliori terze del 4×4).

Formato punteggio: set separati da spazio, punti squadra A - punti squadra B.
Esempi: `21-15` · `21-15 21-18` · `21-19 15-21 15-9`

### Modo A — modifica locale (prima del torneo, o per prova)
Nell'oggetto `RISULTATI` dentro `index.html`:

```js
let RISULTATI = {
  'MV1-1': { p:'21-15 21-18', o:'SAB 09:00', c:'Campo 1' },  // conclusa
  'MV1-2': { p:'LIVE 15-12',  o:'SAB 09:00', c:'Campo 2' },  // in corso
  'MV1-3': { o:'SAB 10:30', c:'Campo 1' },                   // solo programmata
};
```

### Partite in corso (LIVE)
Scrivi `LIVE` nel punteggio, con eventuale parziale: `LIVE` oppure `LIVE 15-12`.
La partita si evidenzia in corallo con pallino pulsante, sia nel tabellone che nel programma, senza assegnare il vincitore. Quando finisce, sostituisci con il punteggio definitivo.

### Orario e campo
Ogni partita può avere un orario e un campo (facoltativi): compaiono sulla chip nel tabellone e alimentano il tab **🕐 Programma**, che elenca le partite dell'evento in ordine di gioco. Formato orario: `10:30` oppure con giorno `SAB 10:30` / `DOM 09:00` (l'ordinamento riconosce VEN/SAB/DOM/LUN/MAR/MER/GIO).

### Modo B — Google Sheets (consigliato durante il torneo)
1. Crea un foglio Google con colonne intestate: `id` | `punteggio` | `orario` | `campo` (le ultime due facoltative)
2. Menu **File → Condividi → Pubblica sul web**, scegli il foglio e il formato **CSV**, copia l'URL.
3. Incolla l'URL nella costante `FOGLIO_GOOGLE` in cima allo script.

Da quel momento aggiorni i punteggi **dal telefono** direttamente sul foglio e il sito si rilegge da solo ogni 60 secondi (modificabile con `AGGIORNA_OGNI_SECONDI`). Se il foglio non è raggiungibile, il sito mostra gli ultimi dati e lo segnala nella barra "live".

Esempio di foglio:

| id     | punteggio    | orario    | campo   |
|--------|--------------|-----------|---------|
| MV1-1  | 21-15 21-18  | SAB 09:00 | Campo 1 |
| MV1-2  | LIVE 15-12   | SAB 09:00 | Campo 2 |
| MV1-3  |              | SAB 10:30 | Campo 1 |

## 3. Formule implementate

- **2×2 Maschile e Misto (32 coppie)**: doppia eliminazione completa — vincenti (16-8-4-2-1), perdenti (8-8-4-4-2-2-1), finalissima. 61 partite per evento.
- **2×2 Femminile (20 coppie)**: 4 gironi da 5 all'italiana → quarti (1A-2B, 1C-2D, 1B-2A, 1D-2C) → semifinali → finale 1°/2° e 3°/4°.
- **4×4 Maschile (12 squadre)**: 3 gironi da 4 → prime due + 2 migliori terze → quarti → semifinali → finali.
- Classifica gironi: vittorie → differenza set → differenza punti → ordine alfabetico. (Lo scontro diretto citato nel regolamento va gestito a mano nei rarissimi casi: basta l'ordine delle squadre.)

Gli accoppiamenti della fase finale sono modificabili nell'array `EVENTI` se preferisci incroci diversi.

## 4. Albo d'oro

La sezione **Albo d'oro** si compila da sola: appena inserisci il risultato delle finali compaiono 🥇🥈🥉 per ogni evento (nella doppia eliminazione il bronzo è il perdente della finale perdenti; nei gironi è il vincitore della finale 3°/4°). Prima di allora mostra "Da assegnare".

## 5. PWA e file del sito

Il sito è installabile come app sul telefono ("Aggiungi a schermata Home"): serve che sia pubblicato su **https** (GitHub Pages va benissimo). File coinvolti, da tenere nella stessa cartella di `index.html`:

- `manifest.webmanifest` — nome, colori e icone dell'app
- `sw.js` — service worker "prima la rete": risultati sempre freschi, ma il sito si apre anche senza connessione mostrando l'ultima copia
- `icon-192.png`, `icon-512.png` — icone (sostituibili con il vostro logo, stesse dimensioni)
- `grafica-*.jpg` — immagini dello shop · `tessuti-3d.js` — texture dei pantaloncini 3D · `mappa_belt.png` — mappa della location

L'anteprima social (link condiviso su WhatsApp) usa i meta tag `og:` in cima a `index.html`: quando il sito è online, sostituisci `og:image` con l'URL assoluto di una foto orizzontale del torneo.

## 6. Pantaloncini 3D nello shop

Le tre card dei pantaloncini (Drago, Onda, Fenice) mostrano un **modello 3D girevole** costruito dalle grafiche di stampa: pannello grafico sulla gamba destra, pannello sponsor sulla sinistra, elastico in vita scuro. Si trascina col dito/mouse per ruotare (rotazione automatica finché non si tocca). I top (Onda, Sakura) restano come immagini.

Note pratiche:
- Le texture 3D sono **incorporate in `tessuti-3d.js`** (base64): il 3D funziona anche aprendo `index.html` con doppio clic, senza server. Tieni il file nella stessa cartella di `index.html`.
- Three.js arriva da CDN: se irraggiungibile (o se manca `tessuti-3d.js`), le card mostrano semplicemente la foto. Nessun errore.
- Le immagini dello shop sono i file `grafica-*.jpg`, estratti da `grafiche_pantaloncini_top_belt.pdf`. Se cambi le grafiche, rigenera sia le immagini sia `tessuti-3d.js` (due jpeg per pantaloncino — pannello destro e sinistro — come data-URI base64 nell'oggetto `TESSUTI_3D`). Se fronte e retro risultano invertiti, scambia i segni in `FRONTE_AVANTI`.

## 7. Pubblicazione gratuita

Il modo più semplice è **GitHub Pages**:
1. Crea un repository e carica tutti i file della cartella (`index.html`, `manifest.webmanifest`, `sw.js`, icone).
2. Settings → Pages → Deploy from branch → `main` → salva.
3. Il sito sarà su `https://tuonome.github.io/nomerepo/`.

Alternativa: Netlify Drop (trascini la cartella e ottieni un link). Su entrambi l'aggiornamento via Google Sheets funziona senza toccare il codice.
