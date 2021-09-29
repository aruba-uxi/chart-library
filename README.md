# chart-library

This is a public repository holding the helm libraries

It has Github pages hosted on the branch `gh-pages`

For further information see the [wiki](https://github.com/Asimmetric/onboarding/wiki/Chart-Library).

## Usage

To use a chart defined in this library it must be added as a dependency in the service `Chart.yaml`.

```yaml
dependencies:
  - name: asimmetric
    version: "x.x.x"
    repository: https://asimmetric.github.io/chart-library
```

Examples on how to use these charts in your own repo can be seen in:

- [asimmetric-example](examples/asimmetric-example)

## Templating Examples (Manual)

To run an example:

1. `cd` into the example directory:

   `cd charts/asimmetric-example`

2. Update the dependencies:

   `helm dependency update asimmetric-example`

3. Build the template:

   `helm template --debug asimmetric-example`

## Templating Examples (Justfile)

The Justfile defines commands to template the various examples.

To template the `asimmetric-example` without any arguments:

```bash
just template-asimmetric
```

To template for a specific environment (e.g. local):

```bash
just template-asimmetric -f charts/asimmetric-example/values-staging.yaml
```

The Justfile commands accept helm flags after the command:

> \*\***NOTE:** run `helm template --help` for possible arguments

```bash
just template-asimmetric [flags]
```

## Vault Sealed Secrets

There are two types of sealed secrets, standard secrets and image pull secrets. For more info on kubeseal and getting the cert.pem see [Kape](https://github.com/Asimmetric/kape#secrets)

### Standard Secrets

1. Generate the sealed secret name using kubeseal as described in [Kape](https://github.com/Asimmetric/kape#secrets)
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
