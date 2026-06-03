# Mensajasser

Although publicly accessible, the Mensajasser-Project is not meant for wide distribution but for a single use. It is the Statistic-System for a group of friends playing the swiss popular game "Jass" (namely the "Offener Differenzler"). It consists of: 

* A very rudimentary Authentification System (User-Controller), controlling who can enter and change results. 
* The Model with a Round (or Tableau or Ris), Consisting of 4 differenz Jassers (Players) and their results in this round. 
* The Statistics, which are presented in the Ranking-Controller. 



## System dependencies & Configuration
To run this project, you need: 
- Ruby 3.3.5 (I use mise for keeping track of ruby versions)
- Rails 8 (installed via `bundle install`)
- Bundler (gem install bundler)
- MariaDB (MySQL-compatible; the app talks to it via the Trilogy adapter)
everything else should get installed when running "bundle install"

## Database 
The app reads its connection from `DATABASE_URL` (see `config/database.yml`), kept
in a local, uncommitted `.env` file:
```
DATABASE_URL=trilogy://user:pass@127.0.0.1/mensajasser_development
```
Create the development and test databases in MariaDB, then run `rails db:schema:load`.

## Testing
Testing is rudimentary, but running  
`rails test` 
should produce no errors. 

## History
v0.01: Spahni started tracking our games in the Mensa Hauptgebäude in an Excel-Sheet 2002  
v0.1:  mensajasser.mullzk.ch as a PHP-Code-Monster, starting in 2003  
v1.0:  Ported to jasser.mullzk.ch in 2010, as a Rails 2.3-project on Ruby 1.8.7. After Release, the code was not touched anymore, as Updates would have been more and more punitive because of Upgrade to Rails and Ruby  
v1.1  Built in 2018 as a new project on current, stable versions of Rails and Ruby, developed with github and heroku. No new features compared to v1.0, in some cases improved code, more tests.  
v2.0  (2018): 
- Improved Code, especially an improved model. 
- Berseker, Schädlings- und Angstgegner-Statistiken
- Grafiken
- Mobilefriendly layout
- Improved Form for adding new rounds
- Favicon
- Encoding Email-Adresses
v2.1 (2019);
- Graph for overall-Average
- Tables for worst Games
v2.2 (2026, this version): New Deployment, cleaner environment

## Todo
- A better form for adding new rounds (multi-page-form?)
- Graphs with comparisons with other jassers
- Testing of graph-controller
- System-Tests
- per-jasser-Statistik

## Maintenance

### What happens automatically

- **Tests & linting** run on every push and every pull request (GitHub Actions: Rails test suite, Brakeman, bundler-audit).
- **Deploy to integration** happens automatically when a push or merged PR lands on `main`.
- **Dependabot** opens pull requests for outdated gems; CI runs on those PRs as well.

### Code changes by the developer

1. Work on a feature branch, push to GitHub.
2. Open a pull request against `main` — CI runs tests and linting automatically.
3. Merge the PR. CI deploys the new code to integration automatically.
4. Review the change on integration, then deploy to production manually:
   ```
   bundle exec cap production deploy
   ```

### Dependabot gem updates

1. Dependabot opens a PR; CI runs tests automatically.
2. Review the diff and the test results in GitHub.
3. Merge if green — integration is deployed automatically.
4. Deploy to production manually (see above) once you've verified integration.

For major version bumps, test locally first:
```
bundle update <gemname>
rails test
```

### Adding a new deployment server

1. **Create a stage file** by copying an existing one as a template:
   ```
   cp config/deploy/integration.rb config/deploy/<stage>.rb
   ```
   Edit the new file: set `application_instance`, `deploy_to`, and the `server` block with the correct host/user env vars (e.g. `DEPLOY_<STAGE>_HOST` / `DEPLOY_<STAGE>_USER`).

2. **Add env vars** to your local `.env` and to `.env.example`:
   ```
   DEPLOY_<STAGE>_HOST=hostname
   DEPLOY_<STAGE>_USER=username
   ```

3. **Register the stage in `db_sync.rake`** so `db:pull`/`db:push` work with it — add an entry to `DbSync::DEPLOY_PATHS`:
   ```ruby
   "<stage>" => "/var/www/<appdir>"
   ```

4. **Set up the server** (once, manually): create the deploy user, shared directory structure, and `shared/config/env` with `DATABASE_URL` and other required env vars. Run `cap <stage> deploy` for the first deploy (may require `cap <stage> deploy:check` to create shared dirs).

5. **For CI auto-deploy** (optional): add `DEPLOY_<STAGE>_HOST` and `DEPLOY_<STAGE>_USER` as GitHub repository secrets, and add a `deploy_<stage>` job to `.github/workflows/rubyonrails.yml` following the pattern of `deploy_integration`.

### DB sync — moving data between environments

The `db:pull` and `db:push` rake tasks copy **data rows only** (no schema) between the local development database and a remote stage (`integration` or `production`). They use SSH + mysqldump/mariadb-dump and clean up temp files automatically.

**Prerequisites** — a local `.env` file (not committed) containing:
```
DATABASE_URL=mysql2://user:pass@127.0.0.1/mensajasser_development
DEPLOY_INTEGRATION_HOST=<host>
DEPLOY_INTEGRATION_USER=<user>
DEPLOY_PRODUCTION_HOST=<host>
DEPLOY_PRODUCTION_USER=<user>
```

**Pull remote data into local DB:**
```
STAGE=integration rails db:pull
STAGE=production  rails db:pull
```

**Push local data to a remote stage:**
```
STAGE=integration rails db:push
```
Pushing to `production` requires typing `yes` at the confirmation prompt.

**Behaviour note:** The sync uses `REPLACE INTO` semantics — existing rows at the destination are updated, missing rows are inserted. Rows that were *deleted at the source* are **not** deleted at the destination; they remain as orphans. This is intentional: a full "delete-on-destination" sync would require either truncating the target table (risky if the import fails mid-way) or computing the set difference of primary keys (complex, slow). For this app, a few surplus old rounds in the integration DB are harmless.

**Schema and migrations:** `db:pull`/`db:push` transfer data only — they do not apply schema changes. `cap deploy` runs `rails db:migrate` on the remote automatically. Always deploy first, then sync data if needed. In particular, never `db:push` after adding a new migration locally but before deploying: the dump will contain data for columns that don't yet exist on the remote, causing the import to fail.


## Logging
Puma does not log to shared/log, but to the system. Get it with `sudo journalctl -u puma-{instance} -f`
