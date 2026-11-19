# Homestay HQ

Web tempahan homestay: kalendar, deposit, bayaran penuh, penyewa, baki tertunggak, WhatsApp pantas, export CSV.

- **Lihat** tempahan: tanpa log masuk.
- **Tambah / edit / padam**: log masuk dengan emel yang ada dalam jadual `allowed_emails`.
- Data disimpan di Supabase (projek `homestay-hq`), kemas kini langsung untuk kedua-dua pengguna.

## Tambah emel yang dibenarkan
Supabase > SQL Editor:
```sql
insert into public.allowed_emails (email) values ('saya@gmail.com'), ('partner@gmail.com');
```
Kemudian buka web, tekan **Log masuk untuk edit** > **Daftar akaun** (guna emel yang sama). Selepas itu matikan pendaftaran baharu di Supabase > Authentication > Sign In / Providers jika mahu.

## Hos di GitHub Pages
Push folder ini ke repo, Settings > Pages > Deploy from branch (main / root).

## Nota privasi
Kerana paparan terbuka, sesiapa yang ada pautan boleh baca tempahan (termasuk telefon / KP). Elakkan isi No. KP jika tak perlu.
