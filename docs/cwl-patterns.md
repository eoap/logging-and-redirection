# CWL patterns for logs and outputs

These complete CWL v1.2 tools have no inputs. The definitions below are included directly from the checked-in files under `examples/`, so the guide and runnable tools share one source. They require Bash on the execution host; they do not declare a container image.

## Write a data file and keep logs visible

Source: `examples/explicit-file.cwl`:

```yaml
--8<-- "examples/explicit-file.cwl"
```

The command writes JSON directly to `report.json`. CWL collects the file through `glob`; the output declaration does not create it. Both progress messages remain on `stderr`, where the runner can handle them as logs.

There is no need for `stdout: report.json` here. Adding it would capture unrelated standard output into the same filename used by the script.

## Capture stdout when it is the data product

Source: `examples/stdout-data.cwl`:

```yaml
--8<-- "examples/stdout-data.cwl"
```

Here the CSV belongs on `stdout`, so CWL redirects that stream to `result.csv`. Diagnostics remain on `stderr`. Do not merge `stderr` into `stdout`: a progress message would become an invalid CSV row.

CWL also supports the output shortcut `type: stdout`. The explicit filename and `File` binding above make the capture destination visible to readers.

## Recognize a pattern that hides diagnostics

Source: `examples/captured-logs.cwl`. Run it to compare its behavior:

```yaml
--8<-- "examples/captured-logs.cwl"
```

Both messages go to files rather than remaining on the command's standard streams. The filenames do not make these messages data products. A runner may expose the files separately, but platform stream collection cannot be assumed to show their contents.

If this tool fails, do not assume its declared log artifacts will still be published. Failure handling and access to working directories depend on the runner and deployment.

## Validate and compare locally

Install `cwltool` in a Python virtual environment, then validate the checked-in examples from the repository root:

```bash
python -m pip install cwltool
cwltool --validate examples/explicit-file.cwl
cwltool --validate examples/stdout-data.cwl
cwltool --validate examples/captured-logs.cwl
```

Run each tool with a separate output directory:

```bash
cwltool --outdir out/explicit examples/explicit-file.cwl
cwltool --outdir out/csv examples/stdout-data.cwl
cwltool --outdir out/captured examples/captured-logs.cwl
```

Check that:

- `out/explicit/report.json` contains JSON and no progress messages.
- `out/csv/result.csv` contains only the header and two data rows.
- The first two tools expose diagnostics through the runner's log handling.
- The third tool puts its messages in `result.txt` and `errors.txt`.

The runner's own final output description is separate from the tool's captured stream. Do not confuse `cwltool`'s output JSON with `report.json` or `result.csv`.

## Failure is part of the contract

By default, CWL treats exit code zero as success. A diagnostic printed to `stderr` can be a warning from a successful command; it is not a failure signal by itself. Return nonzero for failures and use CWL's `successCodes`, `temporaryFailCodes`, or `permanentFailCodes` only when the underlying CLI's exit-code contract requires them.

A required output file must also exist for output collection to succeed. Avoid producing a success-shaped placeholder after processing fails.

See the [CWL specification](https://www.commonwl.org/v1.2/CommandLineTool.html) for `stdout`, `stderr`, output bindings, and exit-code handling.
