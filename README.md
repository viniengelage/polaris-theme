<div align="center">
  <img src="assets/icon-128.png" width="112" height="112" alt="Polar Dark" />
  <h1>Polar Dark</h1>
  <p><strong>A dark theme for VS Code and Zed with a violet north star.</strong></p>
  <p>Syntax colours derived from a working design system — not picked in isolation.</p>
</div>

<img src="assets/preview.png" alt="Polar Dark rendering a TSX component" width="100%" />

## VS Code

### Install from the Marketplace

Search for **Polar Dark** in the Extensions view, then select **Install**. Alternatively:

```sh
code --install-extension viniengelage.polar-dark
```

### Install the packaged extension locally

```sh
bunx --yes @vscode/vsce package
code --install-extension polar-dark-1.0.0.vsix
```

Then open the Color Theme picker with `cmd+K cmd+T` and select **Polar Dark**.

### Development

In VS Code, run **Extensions: Install from VSIX...** and select the generated `.vsix` package. The
VS Code source is `themes/Polar Dark-color-theme.json`; it uses TextMate scopes and semantic tokens
to preserve the Zed theme's syntax intent across TypeScript/TSX, HTML, CSS, JSON, Markdown and Git.

## Zed

The Zed theme lives in `themes/polar-dark.json`.

### Manually

```sh
mkdir -p ~/.config/zed/themes
curl -o ~/.config/zed/themes/polar-dark.json \
  https://raw.githubusercontent.com/viniengelage/polaris-theme/main/themes/polar-dark.json
```

Then `cmd+K cmd+T` → **Polar Dark**. Zed picks up new theme files immediately — no restart.

### As a dev extension

Clone this repository, then in Zed: `zed: extensions` → **Install Dev Extension** → select the
cloned folder. Edits to `themes/polar-dark.json` hot-reload.

## Palette

### Syntax

| Colour | Hex | Carries | Origin |
| --- | --- | --- | --- |
| Violet | `#C084FC` | keywords, JSX/HTML tags, markdown inline code, preprocessor | brand accent |
| Light violet | `#D8B4FE` | built-in types (`string`, `boolean`), enums, namespaces, CSS selectors | brand accent, lighter step |
| Blue | `#60A5FA` | types, functions, methods, labels, link text | product accent |
| Teal | `#2DD4BF` | strings, link URIs | product accent |
| Amber | `#E8B368` | numbers, booleans, constants, JSX/HTML attributes, escapes, interpolation | product accent |
| Grey | `#837C98` | comments *(italic)*, punctuation, inlay hints | ink 400 |
| Light grey | `#C7C2D6` | editor foreground, object properties, attributes | ink 200 |
| White | `#EDEAF5` | variables, parameters *(italic)*, markdown titles | ink 100 |
| Lime | `#BEF264` | diff added, git created | — |
| Rose | `#FB7185` | diff removed, errors | — |
| Deep violet | `#6D28D9` | active-line veil, focus, AI ghost text | brand accent, deepest step |

### Surfaces

| Hex | Used for |
| --- | --- |
| `#08070C` | editor and terminal background |
| `#0E0D14` | panels, tabs, title bar, status bar |
| `#13111B` | menus, popovers, completions |
| `#1F1C2B` | borders |
| `#322C46` | line numbers, indent guides |

`#08070C` rather than `#000`: pure black smears on OLED panels. The elevation ladder runs
**inwards**, not outwards — the editor is the deepest surface and the chrome sits above it.

## Publishing to the VS Code Marketplace

The extension publisher is [`viniengelage`](https://marketplace.visualstudio.com/manage/publishers/).

1. In Azure DevOps, create a Personal Access Token scoped to **Marketplace → Manage** for **All accessible organizations**. Store it in a password manager; do not commit it.
2. Authenticate and publish:

   ```sh
   bunx --yes @vscode/vsce login viniengelage
   bunx --yes @vscode/vsce publish
   ```

3. For a release update, increment `version` according to SemVer, update `CHANGELOG.md`, then run:

   ```sh
   bunx --yes @vscode/vsce publish patch
   ```

The Marketplace rejects SVG icons and non-HTTPS images in `README.md`/`CHANGELOG.md`; this package
uses `assets/icon-128.png` and only ships the required PNG assets. For automated releases, prefer
Microsoft Entra workload identity (`vsce publish --azure-credential`) over a long-lived PAT.

## Asset development

The brand mark and preview live as vector (`assets/icon.svg`, `assets/preview.svg`). Regenerate
the raster exports with:

```sh
./scripts/render-assets.sh
```

## Licence

[MIT](LICENSE) © Vinicios Engelage
