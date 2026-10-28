# College Event Management System

A full-stack campus event app for browsing events and registering students. Organizers can publish events and view registrations.

## Features
- Responsive event listing with search and category filtering
- Student registration with server-side validation
- Duplicate email/roll-number protection per event
- Event capacity check
- Admin event creation and registration listing
- Supabase PostgreSQL storage

## Technology
HTML5, CSS3, Vanilla JavaScript, Node.js, Express.js, Supabase PostgreSQL.

## Folder structure
```text
college-event-management-system/
├── frontend/ (index.html, styles.css, app.js)
├── backend/.env.example
├── backend/src/server.js
├── database/schema.sql
├── package.json
├── .gitignore
└── README.md
```

## Setup
1. Install [Node.js LTS](https://nodejs.org/), [VS Code](https://code.visualstudio.com/) and optionally [Git](https://git-scm.com/).
2. Create a project at [Supabase](https://supabase.com/).
3. In Supabase SQL Editor, run all of `database/schema.sql`.
4. Copy `backend/.env.example` to `backend/.env`.
5. Replace the placeholders with your real Supabase project URL, private service-role key, and an admin secret. Generate a random secret with `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`.
6. From this folder, run:
```bash
npm install
npm start
```
7. Open http://localhost:3000. Keep the terminal open.
8. Click Admin and enter the `ADMIN_API_KEY` value from `backend/.env` to create events or review registrations.

## Environment variables
`PORT` chooses the local port. `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` connect the server to Supabase. `ADMIN_API_KEY` protects admin routes. The service-role key must remain on the server; never put it in frontend code or upload `backend/.env` to GitHub.

## API
| Method | Path | Purpose | Access |
|---|---|---|---|
| GET | `/api/health` | Health/config check | Public |
| GET | `/api/events` | List events; supports `search` and `category` query parameters | Public |
| GET | `/api/events/:id` | Event details | Public |
| POST | `/api/events/:id/register` | Student registration | Public, validated |
| POST | `/api/admin/events` | Create event | `x-admin-key` header |
| PUT | `/api/admin/events/:id` | Update event | `x-admin-key` header |
| DELETE | `/api/admin/events/:id` | Delete event and registrations | `x-admin-key` header |
| GET | `/api/admin/registrations` | List registrations | `x-admin-key` header |

## Testing checklist
- Open the home page and check that sample events display.
- Search for `code`, then filter by Workshop.
- Register a test student; try the same email/roll number again for that event.
- Use the Admin dialog to create an event with a future date.
- View registrations.
- Check `http://localhost:3000/api/health`.

## Troubleshooting
- **Database not configured:** ensure the file is named `backend/.env`, values are real, and restart the server.
- **Events do not load:** run `database/schema.sql` in the matching Supabase project and check terminal errors.
- **Admin key fails:** compare it exactly with `ADMIN_API_KEY` and restart after changing `.env`.
- **Port conflict:** set `PORT=3001` in `.env`, restart, and visit `http://localhost:3001`.

## Security and limitations
This is a student-project MVP, not a production authentication system. Admin key authentication is intentionally simple; production use should replace it with proper accounts/roles and audit logging. The service-role key bypasses RLS, so server-side authorization checks are critical. Capacity is checked before insert and is not transactionally locked under heavy concurrent registration. Public registration does not verify college email ownership. Replace the demo events with real college events.

## GitHub upload
Create an empty repository on GitHub, then from the project root:
```bash
git init
git add .
git status
git commit -m "Build College Event Management System"
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL
git push -u origin main
```
Do not commit `backend/.env` or share any secret keys.
