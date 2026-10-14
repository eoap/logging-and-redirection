cwlVersion: v1.2
class: CommandLineTool
baseCommand: [bash, run.sh]
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: run.sh
        entry: |
          #!/usr/bin/env bash
          set -euo pipefail
          printf '%s\n' 'Starting processing' >&2
          printf '%s\n' '{"status":"complete","items":3}' > report.json
          printf '%s\n' 'Report written' >&2
inputs: []
outputs:
  report:
    type: File
    outputBinding:
      glob: report.json
