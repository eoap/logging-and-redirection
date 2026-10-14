cwlVersion: v1.2
class: CommandLineTool
baseCommand: [bash, run.sh]
stdout: result.csv
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: run.sh
        entry: |
          #!/usr/bin/env bash
          set -euo pipefail
          printf '%s\n' 'Generating CSV' >&2
          printf '%s\n' 'id,value' '1,42' '2,84'
          printf '%s\n' 'CSV complete' >&2
inputs: []
outputs:
  result:
    type: File
    outputBinding:
      glob: result.csv
