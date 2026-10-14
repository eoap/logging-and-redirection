# Worked logging example

The three tools under `examples/` isolate different stream contracts. They use tiny synthetic outputs so you can inspect the difference without downloading satellite data or container images.

Run the commands from the repository root after completing [getting started](getting-started.md). Their definitions and explanations appear in [CWL patterns](cwl-patterns.md).

## Compare the tools

| Tool | Data destination | Diagnostic destination | Expected result |
| --- | --- | --- | --- |
| `examples/explicit-file.cwl` | Explicit `report.json` file | stderr, handled by the runner | JSON report and visible progress |
| `examples/stdout-data.cwl` | stdout captured as `result.csv` | stderr, handled by the runner | Clean CSV and visible progress |
| `examples/captured-logs.cwl` | No processing data product | stdout and stderr captured into files | Messages in artifacts rather than the command's live streams |

## Explicit file output

```bash
cwltool --outdir out/explicit examples/explicit-file.cwl
cat out/explicit/report.json
```

The report contains the status and item count. `Starting processing` and `Report written` are diagnostics, so the script sends them to stderr. Neither appears inside the report.

## Stdout as data

```bash
cwltool --outdir out/csv examples/stdout-data.cwl
cat out/csv/result.csv
```

Expected file contents:

```csv
id,value
1,42
2,84
```

The messages `Generating CSV` and `CSV complete` remain on stderr. Capturing stdout is correct because the CLI's stdout is the data product. Merging stderr into stdout would corrupt this contract.

## Captured diagnostics

```bash
cwltool --outdir out/captured examples/captured-logs.cwl
cat out/captured/result.txt
cat out/captured/errors.txt
```

`result.txt` contains `Starting processing`; `errors.txt` contains `Warning: demonstration only`. Both are logs, despite being declared as file outputs. Runner status messages may still appear in the terminal, and a runner may choose to display captured logs, but the command no longer leaves these messages on its original streams.

This is an intentional demonstration of a problematic logging pattern. Both messages are produced by a successful command: the warning does not cause the example to fail.

## What this comparison establishes

These runs demonstrate tool-level stream destinations and output collection on your local runner. They do not establish remote log retention, access through an OGC API Processes service, or retrieval of captured files after failed jobs.

For deployment, also exercise a controlled failure and confirm that the platform reports failure and exposes the diagnostics you need. Use the [troubleshooting checklist](troubleshooting.md) to investigate gaps.
