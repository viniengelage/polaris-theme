# Changelog

All notable changes to Polar Dark are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-09-17

First release.

### Added

- `Polar Dark` for VS Code — UI chrome, semantic tokens, TextMate scopes, Git/diff states and the full 16-colour terminal ANSI ramp.
- `Polar Dark` for Zed — 150 style keys, 50 tree-sitter captures, full terminal ANSI ramp with `dim`
  and `bright` steps.
- Brand mark as vector (`assets/icon.svg`) plus 512/128/32 raster exports and a reproducible
  render script.
- Preview rendered from the theme's own colour values, so it cannot drift from the JSON.

### Notes on the palette

- Types and functions intentionally share `#60A5FA`. `#88BCFB` is available in the terminal ramp
  for anyone who wants to separate them.
- JSX and HTML attributes share `#E8B368` with numbers and constants.
- `#6D28D9` is reserved for the active-line veil and AI ghost text and is used by no syntax
  token, so inline completions can never be confused with existing code.
- Italics are limited to comments, function parameters and ghost text.

[1.0.0]: https://github.com/viniengelage/polaris-theme/releases/tag/v1.0.0
