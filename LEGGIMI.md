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

### Provare il foglio in locale
Aprendo `index.html` col doppio clic (`file://`) il browser **blocca la lettura del foglio Google** ("Collegamento al foglio non riuscito"). Non è un errore tuo: online funziona. Per provare in locale fai doppio clic su **`avvia-sito.bat`**: apre il sito su `http://localhost:8765`, dove il foglio si carica normalmente. (Non caricare `avvia-sito.bat` e `serve.ps1` quando pubblichi: servono solo in locale.)

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

### Cerca la tua squadra
Sopra i tabelloni c'è un campo di ricerca: scrivendo almeno 2 lettere del nome, il sito evidenzia in giallo tutte le partite della squadra (tabelloni, gironi e programma), passa automaticamente all'evento giusto e mostra un riquadro con la **prossima partita** (avversario, orario e campo, se pubblicati) o "in campo ora" se sta giocando. Funziona con i nomi reali che inserirai in `SQUADRE`.

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
- `icon-192.png`, `icon-512.png` — icone con il drago (favicon e app)
- `copertina.jpg` — anteprima social 1200×630 (drago + titolo)
- `grafica-*.jpg` — immagini dello shop · `mappa_belt.png` — mappa della location

L'anteprima social (link condiviso su WhatsApp) usa `copertina.jpg` via i meta tag `og:` in cima a `index.html`. **Quando il sito è online**, cambia il valore di `og:image` nell'URL assoluto (es. `https://tuonome.github.io/nomerepo/copertina.jpg`): molte app non caricano le anteprime con percorso relativo.

## 6. Grafiche dello shop

Le 5 card dello shop mostrano le grafiche di stampa dei kit (`grafica-*.jpg`, estratte da `grafiche_pantaloncini_top_belt.pdf`): tre pantaloncini (Drago, Onda, Fenice) e due top (Onda, Sakura). Se cambi una grafica, sostituisci il file jpg corrispondente mantenendo lo stesso nome.

I file `tessuti-3d.js` e `pantaloncino.jpeg` non sono più usati dal sito: puoi cancellarli (e non serve caricarli online).

## 7. Pubblicazione gratuita

Il modo più semplice è **GitHub Pages**:
1. Crea un repository e carica tutti i file della cartella (`index.html`, `manifest.webmanifest`, `sw.js`, icone).
2. Settings → Pages → Deploy from branch → `main` → salva.
3. Il sito sarà su `https://tuonome.github.io/nomerepo/`.

Alternativa: Netlify Drop (trascini la cartella e ottieni un link). Su entrambi l'aggiornamento via Google Sheets funziona senza toccare il codice.
