# Roadmap

## Deployment auf neue Infrastruktur (Hetzner VPS)

Deployment per Capistrano, MySQL in allen Environments, Ansible für Server-Setup.

### Phase A — Lokale Umgebung
- mise installieren, MariaDB absichern, lokale DBs anlegen

### Phase B — App-Konfiguration
- sqlite3→mysql2, database.yml, puma.rb (Socket-Support), production.rb absichern, dotenv-rails

### Phase C — Capistrano Setup
- Capfile, deploy.rb (mise-Integration), integration.rb (jasserdev.mullzk.ch)

### Phase D — Branch & GitHub
- `main` als Default-Branch, SSH-Keypair, GitHub Secrets

### Phase E — Webinfra/Ansible
- Server-Infrastruktur für jasserdev (Phase 9 im webinfra-Plan)

### Phase F — Erstes Deploy
- `cap integration deploy` → jasserdev.mullzk.ch live

### Phase G — GitHub Actions
- Push auf `main` → automatisches Deploy auf Integration
