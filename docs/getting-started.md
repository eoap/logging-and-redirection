# Getting started

Run a small tool locally to see how diagnostics and a data product travel through a CWL runner. These examples require Python 3, a virtual environment, and Bash. They have no container requirements, external data inputs, or processing-library dependencies. Installing the Python tools requires network access.

## Prepare the environment

Clone the repository and enter its root:

```bash
git clone https://github.com/eoap/logging-and-redirection.git
cd logging-and-redirection
python3 -m venv .venv
source .venv/bin/activate
python -m pip install cwltool
```

On Windows, use an environment with Bash available, such as WSL, for these tools. The commands above assume a Unix shell.

Check the runner and shell:

```bash
cwltool --version
bash --version
```

`cwltool` is unpinned here. Record its version when comparing results across environments.

## Validate and run a first tool

From the repository root:

```bash
cwltool --validate examples/explicit-file.cwl
cwltool --outdir out/explicit examples/explicit-file.cwl
```

Expect the diagnostic messages `Starting processing` and `Report written` in the terminal, alongside runner messages. The tool creates `out/explicit/report.json`:

```json
{"status":"complete","items":3}
```

Inspect the file:

```bash
cat out/explicit/report.json
```

The runner also prints a CWL output description containing information about the collected file. That description is separate from the JSON data inside `report.json`.

## Understand the result

The tool writes the report explicitly and leaves stderr available to the runner. Its output binding collects the report after execution. This separates data collection from progress reporting.

Local terminal visibility does not establish how a remote platform displays or retains logs. Repeat a representative run in the target environment and check its task logging interface.

Continue with the [worked comparison](logging-example.md) to contrast this behavior with captured stdout and captured diagnostics. See [troubleshooting](troubleshooting.md) if execution fails.
