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

## Templating Examples

> **_NOTE_** The Justfile defines recipes for building examples

To run an example:

1. `cd` into the example directory:

   `cd charts/deploymentexample`

2. Update the dependencies:

   `helm dependency update deploymentexample`

3. Build the template:

   `helm template --debug deploymentexample`
