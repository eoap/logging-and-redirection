# Troubleshooting logging and outputs

Investigate the command, the CWL runner, and the execution platform separately. A local run confirms tool behavior, while a deployed run confirms collection, access, and retention in the target environment.

## Logs are missing

1. Check whether the application emitted messages at all. Run a small representative job locally and inspect stdout, stderr, and its exit status.
2. Inspect the CWL tool for `stdout` and `stderr` capture fields.
3. Inspect scripts and wrappers for `>`, `2>`, `2>&1`, `/dev/null`, or application options that write logs only to a file.
4. Determine how the runner routes subprocess streams. Messages may be available in runner logs even when they do not appear in the expected task view.
5. Check the target platform's task or container selection, access permissions, collection configuration, and retention period.

If logs were intentionally captured as files, find out whether the runner retains those files after failures. Declaring a CWL output alone does not establish a failed-job log retrieval policy.

## Logs arrive late

Check application buffering and whether the platform batches messages before displaying them. Test a command that emits periodic messages with explicit flushing to distinguish application buffering from collection delay. Avoid changing the data-output format just to make progress visible.

## JSON or CSV contains log messages

Inspect the CLI's stdout contract. Look for diagnostics printed to stdout and wrappers that merge stderr into stdout.

Send progress and diagnostics to stderr when stdout is reserved for data, or write the result to an explicit file. Check the captured product with a parser; a filename extension does not prove the contents are valid.

## A failed command appears successful

Check the command's exit code, shell conditionals, pipelines, and CWL exit-code overrides. A wrapper may print an error and then return zero, or a successful `tee` may hide an earlier failure when `pipefail` is disabled.

Add a deliberate failure during testing and verify that the runner marks the job as failed. Confirm that useful diagnostic messages remain accessible for that failed run.

## An expected output is missing

Confirm that the command creates the file in the working directory and that the CWL `glob` matches its name. Keep progress messages separate from data generation so a redirected message cannot accidentally create a misleading output artifact.

Inspect the original processing error before assuming output binding is the root cause. A missing file can be a consequence of an earlier failure.

## Review before deployment

| Check | Evidence to collect |
| --- | --- |
| Stream contract | Identify which streams contain data and which contain diagnostics. |
| Successful execution | Parse the output product and confirm required files exist. |
| Failed execution | Trigger a controlled failure and confirm the job fails with accessible diagnostics. |
| Pipeline behavior | Verify a failed upstream command is not masked by a later command. |
| Remote visibility | Find messages for the correct job and task on the target platform. |
| Retention | Establish how long logs and failed-job artifacts remain accessible. |
| Message content | Include useful task context without printing credentials or sensitive inputs. |

For concurrent workflows, use task identifiers and timestamps when practical. Logs from separate streams or tasks may be interleaved; do not rely on display order alone to reconstruct causality.

## Further reading

- [CWL v1.2 Command Line Tool specification](https://www.commonwl.org/v1.2/CommandLineTool.html): execution, output capture, and file collection.
- [Kubernetes logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/): container streams and cluster logging mechanisms.
- [GNU Bash manual](https://www.gnu.org/software/bash/manual/): shell redirection and pipeline behavior.
