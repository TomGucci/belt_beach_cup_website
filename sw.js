/* BELT Beach Cup — service worker
   Strategia "prima la rete": i risultati live arrivano sempre freschi,
   ma se al campo manca la connessione il sito si apre dall'ultima copia salvata. */
const CACHE = 'belt-v1';

self.addEventListener('install', e => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(clients.claim()));

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  e.respondWith(
    fetch(e.request)
      .then(risposta => {
        const copia = risposta.clone();
        caches.open(CACHE).then(c => c.put(e.request, copia)).catch(() => {});
        return risposta;
      })
      .catch(() => caches.match(e.request))
  );
});
