# chart-library

This is a public repository holding the helm libraries

It has Github pages hosted on the branch `gh-pages`. The helm charts available on <https://aruba-uxi.github.io/chart-library> (see [Usage](#usage) for more info)

For further information see the [wiki](https://github.com/Aruba-UXI/onboarding/wiki/Chart-Library).

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

## Vault Sealed Secrets

There are two types of sealed secrets, standard secrets and image pull secrets. For more info on kubeseal and getting the cert.pem see [Kape](https://github.com/Aruba-UXI/kape#secrets)

### Standard Secrets

1. Generate the sealed secret name using kubeseal as described in [Kape](https://github.com/Aruba-UXI/kape#secrets)
2. Copy the secret into `values.yaml`. NB: be sure to use the correct `namespace` and `secret name` (in this example `"database-url"` and `"redis"`)

```yaml
envSealedSecrets:
  database-url:
    USERNAME: AgCIdNV/y8BhcHBt2DJ4qcj...
    PASSWORD: AgCIdNV/y8BhcHBt2DJ4qcj...
  redis:
    PASSWORD: AgCIdNV/y8BhcHBt2DJ4qcj...
```

### Image Pull Secret

1. Generate the sealed secret name using kubeseal

   `pullsecret.yaml`

   ```yaml
   apiVersion: v1
   data:
     .dockerconfigjson: ewogICJhdXR...
   kind: Secret
   metadata:
     name: sealed-image-pull-secret
     namespace: device-gateway
   type: kubernetes.io/dockerconfigjson
   ```

   command:

   ```sh
   kubeseal < pullsecret.yaml --cert cert.pem --format yaml > sealedsecret.yaml
   ```

2. Copy the sealed secret from `sealedsecret.yaml` into the `values.yaml` as seen below:

   ```yaml
   global:
    sealedImagePullSecret: AgA/ae/EwlywYuzCRFAFDQEYJ9y2Jy4I...
   ```
