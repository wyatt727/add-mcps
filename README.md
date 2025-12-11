# add-mcps Installation and Usage

## Quick Start

1. **Install the system:**
   ```bash
   ./install.sh
   ```
   This will:
   - Create `~/.add-mcps/` with all necessary files
   - Automatically add `~/.add-mcps` to your PATH (in `.zshrc`, `.bashrc`, etc.)
   - Make the script executable

2. **Activate the PATH change:**
   ```bash
   # Reload your shell config (or start a new terminal)
   source ~/.zshrc  # or ~/.bashrc depending on your shell
   ```

3. **Run from any project directory:**
   ```bash
   cd /path/to/your/project
   add-mcps
   ```

**Note:** If you prefer a symlink instead of PATH, you can still use:
```bash
sudo ln -s ~/.add-mcps/add-mcps /usr/local/bin/add-mcps
```

## What Gets Installed

Running `install.sh` creates `~/.add-mcps/` with:
- `add-mcps` - The main script
- `TOOL_USAGE.md` - Tool usage documentation (copied to project's docs/TOOL_USAGE.md)
- `AGENTS.md` - Agent system documentation
- `agents/` - Directory containing all agent files:
  - `diagnostic-agent.md`
  - `planning-agent.md`
  - `fixer-agent.md`
  - `ideator-agent.md`
  - `assigner-agent.md`
  - `engineer-agent.md`
  - `verifier-agent.md`

## What add-mcps Does

When run from a project directory, `add-mcps`:

1. **Installs MCP servers** to `.claude/settings.local.json`
2. **Optionally copies documentation** (use `--add-agents` and/or `--add-tools` flags):
   - Copies `TOOL_USAGE.md` to project's `docs/TOOL_USAGE.md` (if not already present)
   - Copies `AGENTS.md` to project root (if not already present)
   - Copies agent files to `.claude/agents/` (if not already present)

**Default behavior:** Installs servers only, skips documentation and agents (use flags to opt-in)

## Content Detection

The script intelligently detects if content already exists:

- **CLAUDE.md**: Checks for marker `## 🔍 OPTIMAL TOOL USAGE - RIPGREP & SERENA MCP`
- **AGENTS.md**: Checks for marker `# Universal Dual-Workflow Agent System`

If these markers are found, the content is skipped to avoid duplicates.

## Usage

```bash
add-mcps [options]

Options:
  -h, --help                   # Show help message
  --disable server1,server2    # Skip specific servers
  --only server1,server2       # Install only these servers
  --diagnose                   # Run diagnostics and fix issues
  --force                      # Force reinstallation of all servers
  --add-agents                 # Copy agents and AGENTS.md to project
  --add-claude                 # Append CLAUDE.md content to project
```

## Examples

```bash
# Install all servers (default - skips docs/agents)
add-mcps

# Install servers and copy docs/agents
add-mcps --add-agents --add-claude

# Install only specific servers
add-mcps --only exa,context7

# Skip serena and playwright
add-mcps --disable serena,playwright

# Install servers and copy agents only (no CLAUDE.md)
add-mcps --add-agents

# Install servers and copy CLAUDE.md only (no agents)
add-mcps --add-claude

# Force reinstall all servers
add-mcps --force

# Force reinstall and copy documentation
add-mcps --force --add-claude --add-agents

# Run diagnostics
add-mcps --diagnose
```

## Updating

To update the system:

1. Pull latest changes to the add-mcps repository
2. Run `./install.sh` again (it will overwrite existing files)

## Troubleshooting

If you see "add-mcps installation not found":
- Make sure you've run `./install.sh` first
- Check that `~/.add-mcps/` directory exists

If source files are missing:
- Ensure you're in the add-mcps repository directory when running `install.sh`
- Check that `CLAUDE.md`, `AGENTS.md`, and `.claude/agents/` exist in the repo

