cwlVersion: v1.2
class: CommandLineTool
baseCommand: [bash, run.sh]
stdout: result.txt
stderr: errors.txt
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: run.sh
        entry: |
          #!/usr/bin/env bash
          printf '%s\n' 'Starting processing'
          printf '%s\n' 'Warning: demonstration only' >&2
inputs: []
outputs:
  result:
    type: File
    outputBinding:
      glob: result.txt
  errors:
    type: File
    outputBinding:
      glob: errors.txt
