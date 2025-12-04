# Logging & Redirection in EOAP

This repository contains reference material and examples illustrating best practices for handling stdout and stderr in EO Application Packages (EOAPs).

Correct management of logs is essential for EOAP tools and workflows, especially when executed on platforms such as Kubernetes, Calrissian, workflow engines, or OGC API Processes. When stdout or stderr streams are incorrectly redirected, execution platforms cannot surface logs to users, making debugging and monitoring difficult.

This repository demonstrates:

- common pitfalls (bad redirection patterns)
- recommended EOAP-aligned practices
- minimal examples using CWL + simple shell scripts
- structured-output handling without hiding logs

## Documentation

The webpage of the documentation is https://eoap.github.io/logging-and-redirection/

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)