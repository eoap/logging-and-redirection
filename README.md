# Logging & Redirection in EOAP

This repository provides guidance and examples for handling standard output (`stdout`) and standard error (`stderr`) in Earth Observation Application Packages (EOAPs). It is intended for developers writing Common Workflow Language (CWL) tools and workflows, and for operators who need to collect their logs.

Execution environments such as Kubernetes, Calrissian, workflow engines, and platforms exposing OGC API Processes use these streams to make progress messages, warnings, and errors visible. Capturing logs exclusively in files can prevent the execution platform from collecting them through its normal logging mechanism, making debugging and monitoring harder.

The repository contains a documentation site and three runnable CWL examples under `examples/`. The guide includes these tool definitions directly from their source files. There is no automated CWL test suite.

## Documentation

[Read the documentation](https://eoap.github.io/logging-and-redirection/) or browse the [guide source](docs/index.md).

The guide covers:

- Common redirection patterns that hide logs from execution platforms.
- When capturing `stdout` or `stderr` is appropriate.
- How to keep structured data outputs separate from logs.
- Minimal CWL examples with embedded shell scripts.

## Logging principles

- **Keep logs visible.** Omit the CWL `stdout` and `stderr` fields when those streams contain logs, so the execution environment can collect them.
- **Distinguish logs from data.** A CLI may intentionally emit its data product on `stdout`, or structured diagnostics on `stderr`. Capturing that stream as a declared output can be appropriate.
- **Write explicit output files when possible.** Produce files such as `report.json` directly and declare them in the CWL `outputs` section, leaving log streams available for progress and diagnostics.

For example, a tool that writes `report.json` can expose it with:

```yaml
outputs:
  report:
    type: File
    outputBinding:
      glob: report.json
```

This is a fragment of a CWL tool definition. The command itself must create `report.json`; the output declaration only collects the file. See the guide for complete minimal tool examples.

## Repository layout

| Path | Purpose |
| --- | --- |
| `docs/` | Overview, getting started, worked comparison, patterns, and troubleshooting. |
| `examples/` | Runnable CWL tools demonstrating stream handling. |
| `docs/imgs/icon-eoap.png` | Documentation site logo. |
| `mkdocs.yml` | MkDocs theme, navigation, plugins, and Markdown configuration. |
| `.github/workflows/docs.yaml` | GitHub Actions workflow that builds and deploys the documentation. |
| `README.md` | Project overview and local development instructions. |

## Run a first example

With Python 3 and Bash available, create and activate a virtual environment as described below, then run:

```bash
python -m pip install cwltool
cwltool --validate examples/explicit-file.cwl
cwltool --outdir out/explicit examples/explicit-file.cwl
```

The tool writes `out/explicit/report.json` and emits progress messages on stderr. No container runtime is required for these examples. Follow [getting started](docs/getting-started.md) and the [worked comparison](docs/logging-example.md) to run all three patterns.

## Preview the documentation locally

You need Python 3 with `pip` and support for virtual environments. From the repository root, create an isolated environment and install the documentation dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install mkdocs-material mkdocs-mermaid2-plugin
```

On Windows, activate the environment with `.venv\Scripts\Activate.ps1` in PowerShell instead.

Start the preview server:

```bash
mkdocs serve
```

Open the local address printed by MkDocs, normally `http://127.0.0.1:8000`. The preview updates as you edit the documentation.

To generate the static site without starting a server:

```bash
mkdocs build
```

The generated files are written to `site/`. Keep generated files and the local virtual environment out of commits.

## Publishing

The [documentation workflow](.github/workflows/docs.yaml) runs on pushes to `main` and `develop` when files under `docs/`, `examples/`, `mkdocs.yml`, or `.github/` change. It installs the documentation dependencies and runs `mkdocs gh-deploy --force` to publish the site through the `gh-pages` branch.

A change to `README.md` alone does not trigger this workflow.

## Contributing

Update the relevant page under `docs/` to improve the guidance. Edit runnable tools under `examples/`; the CWL patterns page includes those files automatically. Update `mkdocs.yml` when changing navigation or site presentation.

Before opening a pull request:

1. Preview the affected pages with `mkdocs serve`.
2. Run `mkdocs build` and review any warnings.
3. Check that examples clearly distinguish log streams from data outputs. If you change executable examples, validate and run them with a suitable CWL runner.

## License

The documentation is licensed under [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)
