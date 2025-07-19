# latex-libs

A shared LaTeX styles library for course materials.

## Available Libraries

- **betterFrames**
- **dominos**
- **stateMachines**
- **themeNantes**

Each library has the following structure:

```
<library>/
├── tex/    ← `.sty` / `.cls` files to install under `~/texmf/tex/latex/<library>/`
└── doc/    ← PDF documentation to install under `~/texmf/doc/latex/<library>/`
```

## Installation

Clone the repository and run the installer script:

```bash
git clone https://github.com/MatthieuPerrin/Latex-libs.git
cd Latex-libs
chmod +x install.sh
./install.sh [LIB1 LIB2 …]
```

- **Without arguments**, `install.sh` will detect and install **all** libraries (`betterFrames`, `dominos`, `stateMachines`, `themeNantes`).
- **With arguments**, it installs **only** the specified libraries. For example:

```bash
./install.sh themeNantes stateMachines
```

The script will:

1. Copy `tex/` contents to `~/texmf/tex/latex/<library>/`
2. Copy `doc/` contents to `~/texmf/doc/latex/<library>/`
3. Update the TeX file database (`mktexlsr`)

> **Note:** Ensure your TeX distribution uses `~/texmf` as `TEXMFHOME`.
> For a system-wide install, modify `install.sh` to target `/usr/local/texlive/texmf-local`.

## Usage

After installation, include the styles in your LaTeX preamble:

```latex
\usetheme{Nantes}
\usepackage{dominos}
\usepackage{stateMachines}
```

The classes and style files will be loaded from your local TeX tree.

## License

This project is licensed under the **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)**.
See [`LICENSE.txt`](LICENSE.txt) for full license text.

## Contributing

Contributions are welcome!

1. Fork this repository and create your branch.
2. Add or update a library folder (`<library>/tex/` and `<library>/doc/`).
3. Verify that `install.sh` installs your changes correctly.
4. Open a pull request with a clear description of your updates.
