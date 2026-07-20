const CACHE_NAME = 'catas-tf-v2';
const ARCHIVOS = ['./', './index.html', './manifest.json', './icon-192.png', './icon-512.png'];

self.addEventListener('install', function(event){
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache){ return cache.addAll(ARCHIVOS); })
  );
  self.skipWaiting();
});

self.addEventListener('activate', function(event){
  event.waitUntil(
    caches.keys().then(function(keys){
      return Promise.all(keys.filter(function(k){ return k!==CACHE_NAME; }).map(function(k){ return caches.delete(k); }));
    })
  );
  self.clients.claim();
});

// Estrategia "red primero": siempre intenta traer la version mas nueva de
// internet. Solo usa la copia guardada si no hay conexion. Asi, cada vez
// que se sube una actualizacion de la app, llega sola al movil la
// siguiente vez que se abra (no hace falta borrar cache a mano).
self.addEventListener('fetch', function(event){
  const url = event.request.url;
  if(url.includes('/rest/v1/') || url.includes('api.anthropic.com')){
    return;
  }
  event.respondWith(
    fetch(event.request).then(function(res){
      const copia = res.clone();
      caches.open(CACHE_NAME).then(function(cache){ cache.put(event.request, copia); });
      return res;
    }).catch(function(){
      return caches.match(event.request);
    })
  );
});
