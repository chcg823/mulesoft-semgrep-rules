# MuleSoft Semgrep Rules

This repository contains a comprehensive suite of [Semgrep](https://semgrep.dev/) rules designed to scan **MuleSoft** applications (Mule 4) for security vulnerabilities, reliability issues, performance bottlenecks, and maintainability best practices.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Using Makefile](#using-makefile-recommended)
  - [Using Semgrep CLI](#using-semgrep-cli-directly)
  - [CI/CD Integration](#cicd-integration)
- [Rule Categories](#rule-categories)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)

## Prerequisites

- **Semgrep** must be installed on your system.
  - [Installation Guide](https://semgrep.dev/docs/getting-started/)

## Installation

Clone this repository to your local machine:

```bash
git clone https://github.com/chcg823/mulesoft-semgrep-rules
cd mulesoft-semgrep-rules
```

## Usage

You can run scans against your MuleSoft projects using the provided `Makefile` or by invoking `semgrep` directly.

### Using Makefile (Recommended)

The `Makefile` simplifies running tailored scans. Replace `path/to/mule-project` with the actual path to the Mule application you want to scan.

| Command | Description |
| :--- | :--- |
| `make scan PROJECT=...` | Run **all** rules (Security, Reliability, Performance, Maintainability). |
| `make scan-sec PROJECT=...` | Run **Security** rules only. |
| `make scan-rel PROJECT=...` | Run **Reliability** rules only. |
| `make scan-perf PROJECT=...` | Run **Performance** rules only. |
| `make scan-maint PROJECT=...` | Run **Maintainability** rules only. |
| `make effective PROJECT=...` | Generates an `effective-pom.xml` in the target project and scans it for dependency issues. |
| `make ci PROJECT=...` | Run generic Security gate. Fails on ERRORs and WARNINGs (useful for CI/CD). |

**Example:**
```bash
make scan PROJECT=../my-mule-app
```

### Using Semgrep CLI Directly

If you prefer using the raw CLI, you can point Semgrep to the specific rule directories:

```bash
# Run all rules
semgrep --config rules/ path/to/mule-project

# Run specific category
semgrep --config rules/security/ path/to/mule-project
```

### CI/CD Integration

To fail a build pipeline on security findings, use the `ci` target or the following command:

```bash
semgrep --config rules/security/ --severity ERROR --severity WARNING --error path/to/mule-project
```

## Rule Categories

The rules are organized into four main pillars:

### 🛡️ Security
Focuses on preventing vulnerabilities and exposure of sensitive data.
- **Credentials:** Hardcoded passwords, secrets, tokens, and API keys.
- **Network:** Insecure HTTP usage, weak TLS versions, missing certificate validations.
- **Injection:** Unsafe DataWeave `eval`, SSRF risks, and script injection flaws.

### ⚙️ Reliability
Ensures application stability and robust error management.
- **Error Handling:** Missing error handlers, swallowing errors silently, improper APIKit mappings.
- **Timeouts:** Missing or unsafe timeouts in HTTP requests, VM queues, Scatter-Gathers, and DB queries.

### 🚀 Performance
Optimizes resource usage and throughput.
- **Batch Processing:** Recommendations for `batch:job` vs `foreach`, block sizes, and failure thresholds.
- **DataWeave:** Inline script detection (recommends external files), correct output directives, efficient lookups.

### 🧹 Maintainability
Enforces coding standards and project structure consistency.
- **Naming Conventions:** camelCase for variables, kebab-case for flows/configs.
- **Architecture:** Configuration file locations, property externalization, folder structure.
- **API Standards:** Autodiscovery configuration, APIKit specs, correlation ID usage.
- **POM:** Maven dependency and plugin best practices.

## Directory Structure

```plaintext
.
├── Makefile             # Helper commands for running scans
├── mule-config.yaml     # Entry point documentation
└── rules/               # Rule definitions
    ├── maintainability/
    ├── performance/
    ├── reliability/
    └── security/
```

## Contributing

Contributions are welcome! If you have ideas for new rules or improvements:

1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature/amazing-rule`).
3. Add your rule `.yaml` file to the appropriate category in `rules/`.
4. Commit your changes.
5. Push to the branch and open a Pull Request.

---
*Generated for MuleSoft Semgrep Config*
