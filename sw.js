self.addEventListener('install',()=>self.skipWaiting());
self.addEventListener('activate',e=>e.waitUntil(self.clients.claim()));
self.addEventListener('push',e=>{
  let d={};
  try{d=e.data.json()}catch(_){d={title:"Homestay D'Hutan",body:e.data?e.data.text():''}}
  e.waitUntil(self.clients.matchAll({type:'window',includeUncontrolled:true}).then(cs=>{
    // Jika web sedang dibuka dan kelihatan, pop-up dalam web sudah memaklumkan
    if(cs.some(c=>c.visibilityState==='visible'))return;
    return self.registration.showNotification(d.title||"Homestay D'Hutan",{body:d.body||'',icon:'icon-192.png',badge:'icon-192.png',data:{url:d.url||'./'}});
  }));
});
self.addEventListener('notificationclick',e=>{
  e.notification.close();
  const u=(e.notification.data&&e.notification.data.url)||'./';
  e.waitUntil(self.clients.matchAll({type:'window',includeUncontrolled:true}).then(cs=>{
    for(const c of cs){if('focus' in c)return c.focus()}
    return self.clients.openWindow(u);
  }));
});
