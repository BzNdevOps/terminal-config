# Win-WezTerm--Zellij-config

Port Windows + WSL2 du projet parent [`terminal-config`](../README.md).

**Philosophie :**
- **WezTerm tourne sur Windows** (native, GPU direct, pas de latence WSLg)
- **Zellij, tmux, scripts et agents tournent dans WSL Ubuntu**
- Les configs communes (Zellij, tmux, scripts de monitoring) sont **synchronisées depuis le source**

---

## Structure

```
Win-WezTerm--Zellij-config/
├── wezterm.lua              → Config WezTerm Windows (WSL-ready)
├── config/zellij/           → Configs Zellij (copiées du source)
├── config/tmux/             → tmux.conf (copié du source)
├── bin/                     → Scripts helpers (copiés du source)
├── install-wsl.sh           → Déploie tout (WSL + côté Windows)
└── sync-from-source.sh      → Recopie les fichiers communs depuis le source
```

---

## Installation

### 1. Installer WezTerm sur Windows

```powershell
winget install wez.wezterm
# ou télécharger le .exe depuis https://github.com/wez/wezterm/releases
```

### 2. Dans WSL Ubuntu

```bash
cd /chemin/vers/terminal-config/Win-WezTerm--Zellij-config
./install-wsl.sh
```

Ce script :
- installe les configs Zellij/tmux dans `~/.config/` (WSL)
- copie les `bin/` dans `~/bin`
- remplace `/home/bz` par ton `$HOME` WSL
- copie `wezterm.lua` dans `C:\Users\<Toi>\.config\wezterm\wezterm.lua` (Windows)

### 3. Lancer

Ouvre WezTerm depuis Windows. Il démarre directement dans WSL.

Puis dans WSL :
```bash
terminal-ai
```

---

## Synchronisation depuis le source

Quand tu modifies le projet parent (`terminal-config`), relance :

```bash
cd /chemin/vers/terminal-config/Win-WezTerm--Zellij-config
./sync-from-source.sh
./install-wsl.sh
```

`sync-from-source.sh` recopie :
- `config/zellij/*`
- `config/tmux/*`
- `bin/*`

Puis `install-wsl.sh` redéploie.

> **Note :** `wezterm.lua` n'est PAS écrasé automatiquement car il contient la logique Windows/WSL spécifique. Si les couleurs changent dans le source, reporte-les manuellement dans `Win-WezTerm--Zellij-config/wezterm.lua`.

---

## Ce qui est différent du source

| Élément | Source Linux natif | Sous-projet Windows/WSL |
|---------|-------------------|------------------------|
| WezTerm | natif Linux | natif Windows, lance `wsl.exe` |
| Chemins scripts | `/home/bz/...` | adaptés à `$HOME` WSL |
| Screenshot paste | natif | non inclus (Windows gère le clipboard) |
| Installation | `./install.sh` | `./install-wsl.sh` dans WSL |

---

## Raccourcis WezTerm (Windows)

| Raccourci | Action |
|-----------|--------|
| `Ctrl + Shift + F9` | Ouvre le cockpit AI (maximisé) |
| `Ctrl + Shift + F10` | Ouvre une session Codex seul |
| `Ctrl + Shift + F11` | Ouvre une session Claude seul |
| `Ctrl + Shift + Flèches` | Scroll |
| `Ctrl + Shift + F` | Recherche dans le terminal |
