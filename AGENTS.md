# Omakub_by_Szamski Developer Guide for Agents

This repository contains the source code for Omakub_by_Szamski, a personalized Ubuntu development environment setup framework.
It primarily uses **Bash** for orchestration and **Rust** for the theme switcher application.

## 1. Build, Lint, and Test Commands

### Bash Scripts (Core)
There is no centralized "build" for the Bash scripts. Testing is primarily done via dry-runs and linting.

*   **Dry-Run Installation:**
    Always verify changes to the installation logic using the dry-run mode. This checks script syntax and logic without modifying the system.
    ```bash
    # Run from root
    ./install.sh --dry-run
    # OR
    OMAKUB_SZAMSKI_DRY_RUN=1 ./install.sh
    ```

*   **Linting:**
    Use `shellcheck` to lint new or modified shell scripts.
    ```bash
    shellcheck install/your-script.sh
    ```
    *Note: Some scripts verify syntax implicitly during the dry-run phase.*

### Rust App (Theme Switcher)
Located in `apps/theme-switcher`.

*   **Build (Release):**
    ```bash
    cd apps/theme-switcher
    cargo build --release
    ```
    Binary output: `target/release/omakub-theme-switcher`

*   **Test:**
    ```bash
    cd apps/theme-switcher
    cargo test
    ```

*   **Format:**
    ```bash
    cd apps/theme-switcher
    cargo fmt
    ```

*   **Lint:**
    ```bash
    cd apps/theme-switcher
    cargo clippy
    ```

## 2. Code Style & Guidelines

### Bash Scripting
*   **Shebang:** Always use `#!/bin/bash`.
*   **Safety:** Start scripts with `set -e` where appropriate to fail on errors, unless manual error handling is required.
*   **Paths:**
    *   Do NOT hardcode absolute paths like `/home/user`.
    *   Use `$OMAKUB_SZAMSKI_PATH` (defaults to `~/.local/share/omakub-szamski`) for repository-relative paths.
    *   Use `$HOME` for user directories.
*   **Sourcing:**
    *   Use `source` to include other scripts.
    *   Example: `source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"`
*   **Variables:**
    *   **Environment/Global:** `UPPER_CASE` (e.g., `OMAKUB_THEME`).
    *   **Local:** `snake_case` (e.g., `local app_name="git"`).
    *   **Quoting:** Always quote variables involving paths or user input: `"$VAR"`.
*   **Functions:**
    *   Use `snake_case` for function names.
    *   Declare local variables with `local`.
    *   Example:
        ```bash
        install_app() {
            local app=$1
            sudo apt install -y "$app"
        }
        ```
*   **Output/Logging:**
    *   Use the `run_step` function (if available via sourcing `install.sh` context) for tracked progress.
    *   Use `log_info` for informational messages.
*   **Idempotency:** Scripts should be safe to run multiple times. Check if an app is installed before attempting installation if the package manager doesn't handle it gracefully.
*   **Dry-Run Compliance:** Check `$DRY_RUN` variable. If `true`, print what would happen instead of executing destructive commands.

### Rust (Theme Switcher)
*   Follow standard Rust idioms.
*   Use `rustfmt` for formatting.
*   Use `clippy` for linting.
*   Keep dependencies minimal in `Cargo.toml`.

### Configuration Files
*   **JSON (VS Code):** Standard JSON, allow comments if supported by the parser, otherwise strict JSON.
*   **TOML (Ghostty):** Standard TOML formatting.
*   **Lua (Neovim):** Standard Lua formatting.

### Directory Structure Conventions
*   **`install/`:** Main installation scripts.
    *   `terminal/`: CLI tools.
    *   `desktop/`: GUI apps and GNOME settings.
        *   `optional/`: Apps that are not installed by default (selectable in menu).
*   **`themes/`:** Theme definitions.
    *   New themes must strictly follow the folder structure: `<theme_name>/{gnome.sh,ghostty.toml,neovim.lua,btop.theme,vscode.json}`.
*   **`bin/`:** Executable binaries and CLI entry points.

## 3. Workflow for Agents

1.  **Understand Context:** Before editing, run `ls -R` or `glob` to locate relevant files. The structure is specific (e.g., `install/desktop/optional/`).
2.  **Verify Environment:** Check `CLAUDE.md` for project-specific commands.
3.  **Implement:**
    *   If adding an app, create a new `.sh` file in the appropriate `install/` subdirectory.
    *   If modifying the installer, ensure `source` paths use the `$OMAKUB_SZAMSKI_PATH` variable.
4.  **Test:**
    *   For Bash: Run `./install.sh --dry-run` to ensure syntax is correct and the flow is logical.
    *   For Rust: Run `cargo test`.
5.  **Refactor:** Ensure no hardcoded paths exist.

## 4. Specific File Patterns

*   **`install/terminal/required/app-*.sh`**: Core dependencies (like `gum`).
*   **`install/first-run-choices.sh`**: Gum-based menu logic. Add new optional apps here.
*   **`themes/apply-theme.sh`**: The orchestrator for theme switching.

## 5. Error Handling
*   **Bash:** Use `|| true` if a command failure is acceptable (e.g., cleaning up a temp file that might not exist).
*   **Rust:** Use `Result<T, E>` and propagate errors; avoid `unwrap()` in production code.
