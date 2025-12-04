# Logging & Redirection in EOAP

Proper handling of stdout and stderr is essential for EO Application Packages (EOAPs).
Execution environments such as Kubernetes, Calrissian, workflow engines, and OGC API Processes rely on these streams to surface logs to users, operators, and monitoring systems.

This page describes how EOAP developers should treat logging, when redirection is appropriate, and common mistakes to avoid.

## Why Logging Matters

When a CWL tool runs inside a platform:

- `stdout` is where normal program output goes
- `stderr` is where warnings and diagnostics go
- logs on these streams are sent live to the platform
- users see progress, warnings, and errors
- operators can diagnose failures
- execution environments can expose logs via API or CLI

If a tool redirects these streams into files, the platform loses log visibility.

## What Not to Do

Avoid redirecting logs inside the CWL tool:

```yaml
cwlVersion: v1.2
class: CommandLineTool

baseCommand: ["bash", "run.sh"]

stdout: result.txt
stderr: errors.txt

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: |
          #!/bin/bash
          echo "Starting…"          # stdout
          echo "Warning message" >&2 # stderr
          echo "Work…"              
        entryname: run.sh
inputs: []
outputs:
  result:
    type: File
    outputBinding: { glob: result.txt }
  errors:
    type: File
    outputBinding: { glob: errors.txt }
```

This captures all logs inside files, preventing:

- kubectl logs
- calrissian log streaming
- workflow engine log collection
- OGC API Processes log exposure

Unless `stdout` or `stderr` are actual data outputs, this breaks observability.

## When Redirection Is Acceptable

Redirection may be used when stdout or stderr are part of the formal output of the tool:

- tools that naturally print their result to stdout
- tools that emit structured diagnostic output intentionally on `stderr`
- simple data outputs such as GeoJSON or CSV printed to `stdout`
- cases where `stdout` is the data product, not a log

In these cases, the redirection reflects the design of the underlying CLI tool.

## Recommended Pattern

✔️ Leave `stdout`/`stderr` unmodified

Unless they are real outputs, do not redirect them and let them flow naturally so platforms can collect and display logs.

This is the default behaviour when these fields are omitted.

## How to Capture Structured Output Correctly

If you need structured output:

```yaml
outputs:
  report:
    type: File
    outputBinding:
      glob: report.json
```

Write the file explicitly from your code, instead of sending it to stdout/stderr.

This keeps logs separate from data.

## Minimal Example (Good Practice)

```yaml
cwlVersion: v1.2
class: CommandLineTool

baseCommand: ["bash", "run.sh"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: |
          #!/bin/bash
          echo "Starting…"          # stdout
          echo "Warning message" >&2 # stderr
          echo "Work…"              
        entryname: run.sh
inputs: []
outputs: []
```

This tool behaves well in all EOAP environments.

## Summary

| Scenario | Redirect stdout/stderr? | 
| ---------------------------------- | -------------------------------- |
| Logs, warnings, debug output | **No** | 
| Stdout/stderr as real data outputs | **Yes** | 
| Structured output (JSON, metadata) | **Write explicit files instead** | 
| Testing scenarios | Optional redirection |

## Conclusion

Proper logging is essential for EOAP portability, maintainability, and operational visibility.
By following these principles, developers ensure that EO Application Packages behave predictably across all supported execution environments.