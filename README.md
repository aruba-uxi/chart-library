# chart-library

- [chart-library](#chart-library)
  - [Development](#development)
    - [Version Control](#version-control)
    - [Pull Requests](#pull-requests)
  - [Usage](#usage)
  - [Templating Examples](#templating-examples)
    - [Manual](#manual)
    - [Justfile](#justfile)

This is a public repository holding the helm libraries

It has Github pages hosted on the branch `gh-pages`. The helm charts available on <https://aruba-uxi.github.io/chart-library> (see [Usage](#usage) for more info)

For further information see the [wiki](https://github.com/aruba-uxi/knowledge/wiki/Chart-Library).

## Development

### Version Control

This repo follows the [SemVer 2](https://semver.org/) version format.

Given a version number `MAJOR.MINOR.PATCH`, increment the:

- `MAJOR` version when you make incompatible API changes,
- `MINOR` version when you add functionality in a backwards compatible manner, and
- `PATCH` version when you make backwards compatible bug fixes.

### Pull Requests

This repo enforces the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style through the use of [Semantic Pull Requests](https://github.com/zeke/semantic-pull-requests) github app.

A commit message or PR title should take the form

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)
```

## Usage

To use a chart defined in this library it must be added as a dependency in the service `Chart.yaml`.

```yaml
dependencies:
  - name: aruba-uxi
    version: "x.x.x"
    repository: https://aruba-uxi.github.io/chart-library
```

The [examples](examples) folder contains examples of how to use the charts

## Templating Examples

Templating helps view the final kubernetes manifests that are rendered based on the values provided to the helm charts.

### Manual

To run an example:

1. `cd` into the example directory:

   `cd examples/aruba-uxi-example`

2. Update the dependencies:

   `helm dependency update aruba-uxi-example`

3. Build the template:

   `helm template --debug aruba-uxi-example`

### Justfile

The Justfile defines commands to template the various examples.

To template the `aruba-uxi-example` without any arguments:

```bash
just template-aruba-uxi
```

To template for a specific environment (e.g. local):

```bash
just template-aruba-uxi -f examples/aruba-uxi-example/values-staging.yaml
```

The Justfile commands accept helm flags after the command:

> \*\***NOTE:** run `helm template --help` for possible arguments

```bash
just template-aruba-uxi [flags]
```
