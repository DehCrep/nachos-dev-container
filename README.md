# Nachos Dev Container

An automated, cross-platform development environment for the Nachos (Not Another Completely Heuristic Operating System) educational OS codebase. Pre-configured with a 32-bit x86 C++ build chain, cross-compilation tools for MIPS user-level programs (mipsel-linux-gnu), and GDB debugging support for VS Code.

## Quick Start

### Prerequisites
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) [^1]

[^1]: Visual Studio Code can directly install docker on the underlying WSL2 instance of your Windows machine. If you're on MacOS, users can directly use the first party [container](https://github.com/apple/container) tool with a visual studio extention such as [this one](https://marketplace.visualstudio.com/items?itemName=Awei-Sumaho.apple-container-manager).

### Installation into Your Nachos Project
1. Go to the Releases page of this repository.
2. Download `environment.zip` from the latest release.
3. Extract the archive at the root of your existing Nachos repository:
    ```
    code/
    ├── .devcontainer/
    │   ├── devcontainer.json
    │   └── Dockerfile
    ├── .vscode/
    │   └── launch.json
    ├── threads/
    ├── userprog/
    ├── test/
    ├── .gitignore
    ├── Makefile
    └── ...
    ```
4. Open your project folder in VS Code.
5. When prompted by VS Code, click `Reopen in Container` (or open the Command Palette with `Ctrl`/`Cmd`+`Shift`+`P` and select `Dev Containers: Reopen in Container`).
6. VS Code will automatically pull launch your development environment. You should see a blue strip labeled **Dev Container : Nachos Dev Environment**

## Compiling & Testing Nachos
Open a new Dev Container terminal (`Terminal/New Terminal` or `Ctrl`/`Cmd`+`Shift`+`è`) and do as such:
```bash
# Make sure you're in the root directory with the root Makefile
cd code

# Clean and compile the kernel and MIPS user programs
make clean
make

# Navigate to any module directory (e.g., userprog)
cd userprog

# Run the Nachos kernel simulation with a MIPS test binary
./nachos -x ../test/halt
```

## VS Code Debugging Setup
Press `F5` and pick the relative path to your workspace to the program you want NachOS to execute. You can then start stepping through the C++ kernel code with breakpoints, variable inspection, and call stacks.

## What's Inside the Container

- Base System: Debian 12 (Bookworm) configured for multi-architecture compatibility (x86_64 host / Rosetta 2 on Apple Silicon).

- 32-Bit Host Toolchain: libc6-dev-i386, lib32stdc++, and lib32gcc so Nachos builds seamlessly with -m32 without modifying source pointer casts.

- MIPS Cross-Compiler: mipsel-linux-gnu-gcc with symlinks aliased to mips-linux-gcc, mips-linux-ld, mips-linux-as, and mips-linux-ar as required by standard Nachos Makefiles.

- Debugging Tools: gdb-multiarch, build-essential, and C++ extensions pre-configured for VS Code.

- Non-Root User: Runs as a dedicated developer user account with correct workspace directory permissions.

## CI/CD Automation
This repository automatically maintains its image registry and release assets:

- Image Registry: Multi-arch Docker images (`amd64` and `arm64`) are built and pushed to GHCR on every commit to `main`.

- Bundled Assets: The CI workflow dynamically pins `devcontainer.json` to the release tag, compresses `.devcontainer/` and `.vscode/` into `environment.zip`, and attaches it directly to the GitHub Release.
