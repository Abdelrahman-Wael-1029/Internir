'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "060f61d5c2143284e4aeb9bb9c1325f8",
"assets/AssetManifest.bin.json": "7dfa3112f8c9a69148e89a94594b4204",
"assets/AssetManifest.json": "d26f322cc6bc73951b3859c8457d5f07",
"assets/assets/icons/delete.svg": "6a2774eb1ed9ca8750cb450761a9c5da",
"assets/assets/icons/edit.svg": "9ee11aec7f5e373c19ed58b2759ec112",
"assets/assets/icons/File.svg": "e3880db147b40b8b541350ff197a640b",
"assets/assets/icons/home-open.svg": "5d1287097e6e05fb4074878a9a82b8e3",
"assets/assets/icons/home.svg": "d54eab4ded6798da8cf51e757d9dbf8c",
"assets/assets/images/apply-list-open.png": "2465a5dae485555f6e5a003633885c63",
"assets/assets/images/apply-list.png": "b92454a2911ef530da4e788d2b44bfe5",
"assets/assets/images/apply.png": "c4b78dbb86f33050466132419c9ebcf5",
"assets/assets/images/expires.png": "62a6e4894df9569d3f4d42ced757c88a",
"assets/assets/images/home-image.png": "2aeb1f33c023c0aa669e263a069a58e3",
"assets/assets/images/Internir.jpg": "8e40440d2675f02b9d3958f3580f57db",
"assets/assets/images/no-profile.png": "f20150d81d196943889719ab7ba5f292",
"assets/assets/images/onboarding1.jpg": "fba17d4099128a625cccdaa8646ddf0a",
"assets/assets/images/onboarding2.jpg": "1f6339780ba2a9045cdc5c745aa5644c",
"assets/assets/images/pdf.png": "03e5963f379d76d23869675aac774ba8",
"assets/assets/images/profile-open.png": "a52c7f974e7101f0cad48c0e7cf83b35",
"assets/assets/images/profile.png": "84827ca0388354aaa2f53d064ff1c806",
"assets/assets/images/profile_pic.png": "f45a09f04215e6ffdbd0634547862b9e",
"assets/assets/images/saved-open.png": "d5520d4cf029782685dbc8a38962e32f",
"assets/assets/images/saved.png": "0e0d27380c441b0e427ca571bd0cc4d8",
"assets/FontManifest.json": "8a8374247b079ff81e04ed80870be061",
"assets/fonts/MaterialIcons-Regular.otf": "0d58340f64d791839d6a492003d12b39",
"assets/fonts/NotoSans/NotoSans-Black.ttf": "45e579d4c5952595df0d5b0dfe75d53e",
"assets/fonts/NotoSans/NotoSans-Bold.ttf": "ef4b39fb4d49db8beed2966debc0f477",
"assets/fonts/NotoSans/NotoSans-ExtraBold.ttf": "d46a62701edeada8a839b0be13da8406",
"assets/fonts/NotoSans/NotoSans-ExtraLight.ttf": "457f3e71429cfa0fb7fc7e79d2505389",
"assets/fonts/NotoSans/NotoSans-Light.ttf": "9f45a3e1e6aa474995ba423d6137e5c7",
"assets/fonts/NotoSans/NotoSans-Medium.ttf": "09dc02dbe8133545806d275a2fec2ca7",
"assets/fonts/NotoSans/NotoSans-Regular.ttf": "c8e58befd2433eb89589dd1d23225c4e",
"assets/fonts/NotoSans/NotoSans-SemiBold.ttf": "dfad8b708bc7b6911ed49a6f35680b10",
"assets/fonts/NotoSans/NotoSans-Thin.ttf": "1cf299dc471a137219ca9570173f53a1",
"assets/NOTICES": "745cd245896678c860e50baf7a31ffe0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/quill_native_bridge_linux/assets/xclip": "d37b0dbbc8341839cde83d351f96279e",
"assets/packages/syncfusion_flutter_pdfviewer/assets/fonts/RobotoMono-Regular.ttf": "5b04fdfec4c8c36e8ca574e40b7148bb",
"assets/packages/syncfusion_flutter_pdfviewer/assets/highlight.png": "7384946432b51b56b0990dca1a735169",
"assets/packages/syncfusion_flutter_pdfviewer/assets/squiggly.png": "c9602bfd4aa99590ca66ce212099885f",
"assets/packages/syncfusion_flutter_pdfviewer/assets/strikethrough.png": "cb39da11cd936bd01d1c5a911e429799",
"assets/packages/syncfusion_flutter_pdfviewer/assets/underline.png": "c94a4441e753e4744e2857f0c4359bf0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "b2935ae73e4f0081ab7ae432a33e2e7c",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "f672d1a56ffc32a3e3bbe486a5389457",
"icons/Icon-192.png": "831e1ad7f946cb7df2e370ca47fed1fe",
"icons/Icon-512.png": "571d31f1cf39e67245348b533720e1de",
"icons/Icon-maskable-192.png": "831e1ad7f946cb7df2e370ca47fed1fe",
"icons/Icon-maskable-512.png": "571d31f1cf39e67245348b533720e1de",
"index.html": "5430b3393e15d5cce8cb15eaf4ed41a8",
"/": "5430b3393e15d5cce8cb15eaf4ed41a8",
"main.dart.js": "66e637779a0896e618a7ae1f5115be51",
"manifest.json": "d842318b8fe8c2b2543506faa4654113",
"version.json": "046d197a849fd67467b7bc6e69216f3e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
