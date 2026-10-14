# Shell redirection and pipelines

A CWL tool can preserve standard streams in its definition and still hide them inside a shell script. Inspect both layers when reviewing an application package.

The examples on this page use Bash. Ordinary CWL `baseCommand` and `arguments` are command arguments, not shell syntax: a literal `>` does not become a redirection unless a shell interprets it. An explicit script, as used in the [CWL examples](cwl-patterns.md), makes that behavior easier to inspect.

## Understand the destination

| Bash syntax | Effect |
| --- | --- |
| `command > result.txt` | Replace `result.txt` with stdout from the command. |
| `command >> result.txt` | Append stdout to the file. |
| `command 2> errors.txt` | Write stderr to a file. |
| `command > combined.log 2>&1` | Send stdout and stderr to the same file. |
| `command > /dev/null 2>&1` | Discard both streams. |
| `printf '%s\n' 'Processing' >&2` | Send a message to stderr. |

Use file redirection deliberately for data products. Avoid blanket suppression or capture of diagnostics in production wrappers unless another mechanism provides the required visibility.

## Redirection order matters

Bash processes redirections from left to right:

```bash
command > combined.log 2>&1
```

First stdout is pointed at the file, then stderr is pointed at stdout's current destination. Both streams reach the file.

```bash
command 2>&1 > result.txt
```

Here stderr is first pointed at stdout's original destination. Only stdout is subsequently moved to the file. The two forms have different behavior.

## Duplicate diagnostics with tee

If an application needs a file copy and visible diagnostics, `tee` can duplicate a stream. For a command whose stdout and stderr are both human-readable logs:

```bash
set -o pipefail
command 2>&1 | tee processing.log
```

This merges the two streams and writes their combined contents both to `processing.log` and to the pipeline's stdout. It loses the distinction between stdout and stderr. Do not use this pattern when stdout contains CSV, JSON, or another data product.

`tee` does not bypass CWL redirection. If the enclosing CWL tool captures stdout, the duplicated messages still go to that capture destination. Also decide whether the log file needs to be declared as an output and how failed-run logs will be retained.

## Preserve failure through pipelines

Without `pipefail`, Bash normally reports the exit status of the last command in a pipeline. A failed processor followed by a successful `tee` can therefore appear successful.

Try this small demonstration:

```bash
bash -c 'exit 7' | tee demonstration.log
```

Then repeat with pipeline failure propagation enabled:

```bash
set -o pipefail
bash -c 'exit 7' | tee demonstration.log
```

With `pipefail`, a failing pipeline returns the status of its rightmost failing command. In a script, handle that nonzero result or let an appropriate error policy stop execution. `set -euo pipefail` is a useful starting point for simple Bash wrappers, but `-e` has exceptions in conditionals and other contexts; review the actual control flow rather than treating it as a complete error-handling strategy.

## Buffering can delay visible messages

A process may buffer output differently when writing to a pipe or file instead of a terminal. Missing immediate progress does not necessarily mean messages were redirected away. Use the application's flushing or unbuffered-output options when available, and test with the same runner and container setup used in deployment.

For shell semantics, consult the [GNU Bash manual](https://www.gnu.org/software/bash/manual/), especially its sections on redirections, pipelines, and the `set` builtin.
