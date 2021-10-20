# chart-library

This is a public repository holding the helm libraries

It has Github pages hosted on the branch `gh-pages`. The helm charts available on <https://aruba-uxi.github.io/chart-library> (see [Usage](#usage) for more info)

For further information see the [wiki](https://github.com/Aruba-UXI/knowledge/wiki/Chart-Library).

## Usage

To use a chart defined in this library it must be added as a dependency in the service `Chart.yaml`.

```yaml
dependencies:
  - name: aruba-uxi
    version: "x.x.x"
    repository: https://aruba-uxi.github.io/chart-library
```

The [examples](examples) folder contains examples of how to use the charts

## Templating Examples (Manual)

To run an example:

1. `cd` into the example directory:

   `cd examples/aruba-uxi-example`

2. Update the dependencies:

   `helm dependency update aruba-uxi-example`

3. Build the template:

   `helm template --debug aruba-uxi-example`

## Templating Examples (Justfile)

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

## Version Control

This repo follows the [SemVer 2](https://semver.org/) version format.

Given a version number `MAJOR.MINOR.PATCH`, increment the:

- `MAJOR` version when you make incompatible API changes,
- `MINOR` version when you add functionality in a backwards compatible manner, and
- `PATCH` version when you make backwards compatible bug fixes.
