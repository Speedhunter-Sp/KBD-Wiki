# Keeb Wiki

A little personal wiki for your mechanical keyboard collection: a photo grid
homepage, a spec-sheet article page per keyboard, and a 2–4 way comparison
tool. Only you can add/edit/delete — everyone else just browses.

## 1. Install into XAMPP

1. Start **Apache** and **MySQL** from the XAMPP control panel.
2. Copy the whole `keeb-wiki` folder into your XAMPP `htdocs` directory, e.g.
   `C:\xampp\htdocs\keeb-wiki` (Windows) or `/Applications/XAMPP/htdocs/keeb-wiki` (Mac).
3. Open **phpMyAdmin** (`http://localhost/phpmyadmin`), click **Import**, and
   import `schema.sql`. This creates the `keeb_wiki` database and its tables
   (`users`, `keyboards`, `keyboard_photos`, `tags`, `keyboard_tags`).

   > Already imported the original `schema.sql` before this update? Import
   > `migration_gallery_tags.sql` instead — it only adds the two new tables
   > without touching your existing keyboards.
4. Open `http://localhost/keeb-wiki/` in your browser. Since no admin account
   exists yet, it'll send you to the one-time setup page — pick a username
   and password there. That's your only login; there's no public sign-up.
5. Log in and start adding keyboards.

If your MySQL uses a different host/user/password than the XAMPP default
(root, no password), edit the values at the top of `config.php`.

## 2. Using it

- **Homepage** — a grid of your keyboards (photo, name, model). Click one to
  open its page.
- **Keyboard page** — hero photo, tags, the full spec grid (model, layout,
  frame, plate, PCB, mounting, switches, keycaps, connection, battery,
  hotswap, special features), a "Formerly known as" link if this build is a
  rebuild of an earlier one, an intro paragraph, a **Gallery** of extra
  photos (click one to view it full-size), then Description / Build
  timeline / Personal review / Future build plans sections.
- **Compare** — pick 2–4 keyboards from the dropdowns to see their specs
  side by side.
- **Search & tags** — the homepage has a search box (matches name/model) and
  a tag cloud built from whatever tags you've used. Click a tag to filter
  the grid to just that tag; combine it with a search term too. Click a tag
  on a keyboard's own page to jump straight to everything else with that tag.
- **Edit/Delete** — only visible when you're logged in, at the bottom of a
  keyboard's page. Editing also lets you add more gallery photos, remove
  existing ones, and retype the tag list.

### Tags

Add tags when creating or editing a keyboard — comma-separated, e.g.
`65%, tri-mode, gasket mount`. Use them however's useful: layout, connection
type, switch family, whatever helps you find things later. New tag names are
created automatically; there's nothing to set up in advance.

### "Formerly known as"

When adding or editing a keyboard, the form has a "Formerly known as"
dropdown — point it at an earlier build this one replaced/evolved from.
That earlier build still exists as its own full wiki page with its own
specs; the newer one just links back to it.

## 3. Putting it online later

The app already separates "logged in" (can edit) from "everyone" (can view),
CSRF-protects the add/edit/delete forms, escapes all output, validates
uploads by real content (not just file extension), and hardens the session
cookie automatically once it detects HTTPS — so it's reasonably safe to host
publicly. Before you do, work through this checklist:

- [ ] In `config.php`, change `APP_ENV` to `'production'`. This hides PHP
      error details from visitors instead of printing them on-screen.
- [ ] In `config.php`, point `DB_HOST`/`DB_NAME`/`DB_USER`/`DB_PASS` at your
      host's database. **Don't use a root account** — create a dedicated
      MySQL user in Hostinger's hPanel that only has access to this one
      database, with a strong, unique password.
- [ ] Re-import `schema.sql` on the host's database (or migrate your local
      data over), and copy your `uploads/` folder across so photos come
      with it.
- [ ] Make sure the site is served over **HTTPS** (Hostinger includes free
      SSL — turn it on in hPanel and force HTTPS redirects). The session
      cookie automatically locks itself to HTTPS-only once it detects the
      site is running on it.
- [ ] Set a real, strong password for your admin account — the setup page
      enforces 8 characters minimum, but longer/random is better since this
      login will be reachable by anyone who finds the URL.
- [ ] Make sure `uploads/` stays writable by PHP after upload (most hosts
      handle this automatically; if uploads fail, check folder permissions
      in hPanel's file manager).

None of this is exotic — it's the same handful of things you'd do for any
small PHP app before making it public.

## 4. File map

```
keeb-wiki/
├── config.php          Database + upload settings
├── schema.sql           Import this into phpMyAdmin once
├── migration_gallery_tags.sql  Only if you already had the DB set up
├── setup.php            One-time admin account creation
├── login.php / logout.php
├── index.php             Homepage grid
├── keyboard.php          Single keyboard wiki page
├── compare.php            Comparison tool
├── admin/
│   ├── add.php            Add a keyboard
│   ├── edit.php           Edit a keyboard
│   └── delete.php         Delete (with confirmation)
├── includes/
│   ├── db.php, auth.php, functions.php
│   ├── header.php, footer.php
│   └── kb-form.php         Shared add/edit form fields
├── assets/css/style.css
└── uploads/                Where photos are stored
```
