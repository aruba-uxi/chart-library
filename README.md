# chart-library

This is a public repository holding the helm libraries

It has Github pages hosted on the branch `gh-pages`

## Usage

To use a chart defined in this library it must be added as a dependency in the service `Chart.yaml`.

```yaml
dependencies:
- name: deploymentlib
  version: "x.x.x"
  repository: https://asimmetric.github.io/chart-library
```

Examples on how to use these charts in your own repo can be seen in:

- [deploymentexample](charts/deploymentexample)
- [ingressexample](charts/ingressexample)
- [serviceexample](charts/serviceexample)

## Templating Examples (Manual)

To run an example:

1. `cd` into the example directory:

   `cd charts/deploymentexample`

2. Update the dependencies:

   `helm dependency update deploymentexample`

3. Build the template:

   `helm template --debug deploymentexample`

## Templating Examples (Justfile)

The Justfile defines commands to template the various examples.

To template the `deploymentexample` without any arguments:

```bash
just template-ingress
```

To template for a specific environment (e.g. local):

```bash
just template-ingress -f charts/ingressexample/values-production.yaml
```

The Justfile commands accept helm flags after the command:
> **__NOTE:__ run `helm template --help` for possible arguments

```bash
just template-ingress [flags]
```
