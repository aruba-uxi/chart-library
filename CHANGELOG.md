# Aruba UXI Chart Library Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - yyyy-mm-dd

### Added

- what is new

### Changed

- what changed


## [6.0.1] - 2022-05-30

### Changed

- added `datadog.useSocat` which switches from using the node HostIP to using a locally deployed socat sidecar. The sidecar will listen on the UDP port and forward statsd traffic to the dogstatsd unix socket which is mounted into the sidecar container.

## [6.0.0] - 2022-05-20

### Changed

- Liveness and Readiness probes now default to using `/health/live` and `/health/ready`.

## [5.0.9] - 2022-05-20

### Added

- the ability to configure the deployment update strategy

```yaml
  updateStrategy:
    maxSurge: 50%
    maxUnavailable: 50%
```

### Changed

- Updated docs and values example file

## [5.0.8] - 2022-05-15

### Added

- Ability to add extra datadog and sentry environment variables by setting the `env` value in `.Values.application.datadog` and `.Values.application.sentry` respectively.

```yaml
datadog:
  env:
    - DD_SOME_KEY: some-value
```

```yaml
sentry:
  env:
    - SENTRY_SOME_KEY: some-value
```

## [5.0.7] - 2022-04-29

### Added

The ability to set `DD_SERVICE` env variable through the `datadog.serviceName` value

## [5.0.6] - 2022-04-27

### Changed

Replicas being set to 0 were defaulting to 1 because of the way the deployment chart evaluated `replicaCount: 0`. It was returning false and using the default value instead of the actual value of `0`

## [5.0.5] - 2022-4-19

### Changed

If some DD_* env variables are not set it will result in ddtrace or datadog trying to push traces. This PR sets some datadog env variables to always be set.

## [5.0.4] - 2022-04-12

- Ingress className must be provided always. A message prompts for this

## [5.0.3] - 2022-04-12

- Ingress className must be provided always. A bug was in the charts that allowed it to be excluded

## [5.0.2] - 2022-03-30

### Added

- added the application version in an environment variable (`APPLICATION_VERSION`). This is built with the image tag.

### Changed

- what has been changed

## [5.0.1] - 2022-03-31

### Changed

- Fix bug where example config map was being generated unwantedly

## [5.0.0] - 2022-03-31

### Changed

- We can now create multiple configMaps per application
- ConfigMaps have new field `create` which defines whether the ConfigMap must be created or not
- ConfigMaps have new field `name` which affects the ConfigMap name field that the deployment links to
- Fix logic bug where false values are defaulting to true

## [4.1.1] - 2022-03-18

### Changed

- update default replicas to 1

## [4.1.0] - 2022-03-10

### Added

- Provide the ability for the client to control ingress annotations through the `ingress.annotations` key

## [4.0.2] - 2022-03-04

### Added

Added an environment variable `APPLICATION_NAME` for each application (Service, Worker and Cronjob) where `APPLICATION_NAME={.Values.applications.name}`

## [4.0.1] - 2022-03-04

### Changed

- `.Values.replicaCount` set to 0 was treated as false and not `0`. This is fixed in this PR. The `replicaCount` value can be set to 0 now.

## [4.0.0] - 2022-03-02

### Changed

- Liveness and readiness probes can be toggled with the `enabled`variable. This allows them to be turned on and off without creating a new PR.
- Removed the liveness and readiness `command` in favour of only using the `path`.

## [3.1.0] - 2022-02-22

### Changed

The ability to use a legacy `apiVersion` for the ingress object. This is to cater for production using an outdate version of kubernetes.
Staging and Production can not use the same ingress object.

## [3.0.3] - 2022-02-15

### Changed

- Use extensions/v1beta1 for ingresses because networking.k8s.io/v1 is incompatible with prod
- Update ingress config to align with extensions/v1beta1
- Remove pathType from ingress

## [3.0.2] - 2022-02-15

### Changed

- Use networking.k8s.io/v1 instead of networking.k8s.io/v1beta1 (deprecated) for ingresses
- Update github actions to expect changelog to be out of charts folder

## [3.0.1] - 2022-02-09

### Changed

- updated typo in changelog and moved changelog out of charts folder

## [3.0.0] - 2022-02-08

### Changed

The allow for multiple repos to be deployed to the same namespace, the image pull secret name needed to be changed to something unique to the repo.
An error was occurring in ArgoCD when an application was trys to create an image pull secret but it already exists from another repo.

The image pull secret name has been changed from `sealed-image-pull-secret` to `<repository-name>-image-pull-secret` where repository name is taken from `.Values.global.repository`.

## [2.4.6] - 2022-01-19

### Added

Added the ability to set the ingress class name. Defaults to `nginx`

```yaml
ingress:
  class: nginx
```

## [2.4.5] - yyyy-mm-dd

### Fixed

- sentry-dsn sealed secrets were incorrectly being created

## [2.4.4] - 2022-01-21

### Changed

- updated worker commands

## [2.4.3] - 2021-12-22

### Changed

Ability to send args for container command

```yaml
args: ["-d", "--doSomething"]
```

## [2.4.2] - 2021-12-14

### Added

Ability to use commands to do liveness and readiness checks. This is especially handy for workers.

```yaml
livenessProbe:
  command: ["ls -a"]
readinessProbe:
  command: ["ls -a"]
```

## [2.3.2] - 2021-11-10

### Added

Ability to mount secrets on the pod as a file in the app or other directory which then could be accessed by code to read service accounts or secret URLs. For example, `firebase-service-account` is a JSON file that is accessed by code in `firebase-config-sender` and needs to be passed as secret when the service is deployed.

Volumes will be mounted like this under `spec.template.spec.containers` in deployment

```yaml
volumeMounts:
- name: config
  mountPath: /app/config
  readOnly: true
- name: firebase-service-account
  mountPath: /app/resources
  readOnly: true
```

And the volume definition is done like this under `spec.template.spec` in deployment

```yaml
volumes:
- name: config
  configMap:
    name: example-service
- name: firebase-service-account
  secret:
    secretName: firebase-service-account
```

The `values-staging.yaml` to add secret mounts would look like this

```yaml
secretMount:
- name: firebase-service-account
  readOnly: true
  path: /app/resources
```

The secrets that are to be mounted as files should be placed under `.Values.sealedSecrets.secretMount` like this

```yaml
sealedSecrets:
  imagePullSecret: sealed_version_of_the_base64_encoded_dockerconfigjson
  secretMount:
    firebase-service-account:
      firebase-service-account.json:
        sealed_version_of_the_base64_encoded_service_account
```

## [2.3.1] - 2021-11-05

### Changed

The `application-sentry-dsn.yaml` and `cronjob-sentry-dsn.yaml` files needed to be renamed(interchanged) because the `application-sentry-dsn.yaml` has logic to add sentry-dsn for a cronjob and vice versa for `cronjob-sentry-dsn.yaml`. Files have been renamed now to correctly generate sealedsecrets.

## [2.3.0] - 2021-11-05

### Changed

Each application needs to use its own sentry DSN value. Previously the sentry DSN was shared across all applications which caused incorrect data in sentry.

Now the sentry DSN has been moved into the application level under the `application[n].sentry` key.

When enabling sentry, you have to also provide the encoded sentry DSN. The charts will fail if you have not provided the DSN.

The `sentryDsn` has been removed from the `sealedSecrets` section

```yaml
aruba-uxi:
  sealedSecrets:
    sentryDsn: ...
```

and moved into the application section

```yaml
aruba-uxi:
  applications:
    example-service:
      ...
      sentry:
        enabled: true
        dsn: AgA/ae/EwlywYuzCRFAFDQEYJ9y2Jy4I...
```

## [2.2.0] - 2021-10-20

### Added

Checks have been added to the environment variables to restrict users from controlling datadog and sentry using environment variables. Controlling datadog and sentry should be done through the values file, i.e `datadog.enabled` or `sentry.enabled`. Setting either of these values to true will add additional environment variables that are relevant. It still allows adding additional environment variables that are not automatically set.

Setting `datadog.enabled: true` will add:

```yaml
env:
- name: DD_ENABLED
  value: true
- name: DD_ENV
  value: "lowercase value from ".global.environment'"
- name: DD_SERVICE
  value: "the name of the application or cronjob"
- name: DD_TRACE_ENABLED
  value: "value from '.datadog.traceEnabled' (default: false)"
- name: DD_AGENT_HOST
  valueFrom:
  fieldRef:
    fieldPath: status.hostIP
- name: DD_ENTITY_ID
  valueFrom:
  fieldRef:
    fieldPath: metadata.uid
```

Setting `sentry.enabled: true` will add:

```yaml
env:
- name: SENTRY_ENVIRONMENT
  value: "lowercase value from '.global.environment'"
- name: SENTRY_DSN
  valueFrom:
    secretKeyRef:
      name: sentry-dsn
      key: SENTRY_DSN
```

## [2.1.5] - 2021-10-21

### Changed

- Service uses port 80 by default and the ingress tries to talk to Service on Pod port. This is not allowing Service and Ingress to communicate.
- To fix the above mentioned issue, the ingress will now use port 80 by default if `.service.port` is not defined.

## [2.1.4] - 2021-10-21

### Changed

- removed `SENTRY_ENABLED` env variable that is not needed
- documentation updates

## [2.1.3] - 2021-10-20

### Fixed

- Fixed indentation in sentry env keys
- updated documentation

## [2.1.2] - 2021-10-20

### Fixed

The `suspend` value for a `CronJob` should not be quoted

## [2.1.1] - 2021-10-20

### Fixed

K8s 1.18 does not support cronjob `batch/v1`. I had to change it to `batch/v1beta1`

## [2.1.0] - 2021-10-20

### Added

Added a legacy ingress to the applications. The legacy ingress can be added by setting `ingress.enabled` option to `true`

```yaml
ingress:
enabled: true
hosts:
- host: example-service.local
  paths:
  - path: /
    pathType: ImplementationSpecific
    backend:
      serviceName: example-service
      servicePort: 8000
tls:
 - secretName: chart-example-tls
   hosts:
   - example-service.local
```

## [2.0.1] - 2021-10-19

### Added

Add the ability to create a cronjob in suspended mode by setting the `suspend` key. Default is `false`

```yaml
cronjobs:
  example-cronjob:
    ...
    suspend: true
    ...
```

## [2.0.0] - 2021-10-15

### Changed

- Moved `values.example.yaml` into the `charts/aruba-uxi`
- Renamed `asimmetric` to `aruba-uxi`. This includes the root key in the yaml file.

```yaml
aruba-uxi:
  sealed-secrets: {}
  global: {}
  applications: {}
  cronjobs: {}
```

## [1.1.6] - 2021-10-07

### Changed

The following values are required in the `values.yaml` file:

- `asimmetric.global.image.repository`
- `asimmetric.global.image.tag`
- `asimmetric.global.repository`

The `image.repository` and `image.tag` can be overridden in the overlay value files but it has to be set in the base values. Helm will fail with an error if it can not find an image tag

## [1.1.5] - 2021-10-06

### Added

In Deployment, `spec.revisionHistoryLimit` to define number of old ReplicaSets to be retained. Rest are garbage collected in the background.

Example Usage

```yaml
# values-staging.yaml
example-service:
  role: webapp
  revisionHistoryLimit: 4
```

## [1.1.4] - 2021-10-06

### Added

Added the ability to set whether datadog tracing is enabled.

```yaml
example-service:
  datadog:
    enabled: true
    traceEnabled: true
```

## [1.1.3] - 2021-10-06

### Fixed

Sealed secrets were using the wrong name. Deployments and Cronjobs were still searching for sealed secrets using the pre v 1.1.x name.

## [1.1.2] - 2021-10-05

### Added

Ability to define global labels that are added to the existing labels (see `asimmetric.labels` template)

```yaml
asimmetric:
  global:
    labels:
      global-label: value
```

Added ability to define labels for each application or cronjob. Merged with the `.globals.labels`

```yaml
asimmetric:
  application:
    labels:
      extra-label: value
```

or

```yaml
asimmetric:
  cronjobs:
    labels:
      extra-label: value
```

## [1.1.1] - 2021-10-05

### Added

Ability to control sentry for each application or cronjob with `sentry.enabled: true | false`. Enabling sentry will create the necessary environment variables.

```yaml
- name: SENTRY_ENABLED
  value: "true"
- name: SENTRY_ENVIRONMENT
  value: "staging"
- name: SENTRY_DSN
  valueFrom:
    secretKeyRef:
      name: sentry-dsn
      key: SENTRY_DSN
```

Added the `.sealedSecrets.sentryDsn` value which (if present) will create a `sentry-dsn` sealed secret. This value will be used to populate the `SENTRY_DSN` environment variable.

> ****NOTE**** There is no logic to catch if you enabled sentry and forgot to provide the `.sealedSecrets.sentryDsn` value.

## [1.1.0] - 2021-10-05

### Changed - Sealed Secrets

Sealed secrets were defined globally with the option of overriding them on a per application or cronjob basis. Each global sealed secret was added to all applications and cronjobs. This proved abit complicated because sealed secrets are dependent on the name and namespace. Previously the name was automatically generated based on where its being used.

To simplify the sealed secret process this change includes:

- Sealed secrets have been moved out of `.global` into their own object `.sealedSecrets`
- Sealed secrets used as environment variables must be defined within `.sealedSecrets.env`
- It is only possible to define the sealed secret data in this `.sealedSecrets.env` object. Applications and cronjobs can only set what ENV variables they want to use from the sealed secrets defined in `.sealedSecrets`

#### Example Usage

```yaml
# values-staging.yaml
asimmetric:
  sealedSecrets:
    env:
      database-url:
        DATABASE_URL: AgA/ae/EwlywYuzCRFAFDQEYJ9y2Jy4I...
...
applications:
  example-service:
    envSealedSecrets:
      database-url:
      - DATABASE_URL
```

### Changed - Image Pull Sealed Secrets

In addition to the above change, `sealedImagePullSecret` has been moved out of `.global` into `.sealedSecrets`

#### Example Usage

```yaml
# values-staging.yaml
asimmetric:
  sealedSecrets:
    imagePullSecret: AgA/ae/EwlywYuzCRFAFDQEYJ9y2Jy4I...
```

## [1.0.2] - 2021-10-05

### Changed

- renamed files in the template folder

## [1.0.1] - 2021-09-29

### Added

- Higher level of abstraction of kubernetes objects
- The Asimmetric chart library provides a template for deploying, webapps, workers and cronjobs
- See [README.md](https://github.com/aruba-uxi/chart-library/blob/main/charts/aruba-uxi/README.md) and [MIGRATION_NOTES.md](https://github.com/aruba-uxi/chart-library/blob/main/MIGRATION_NOTES.md) for information
- See [WiKi](https://github.com/aruba-uxi/knowledge/wiki/Chart-Library) for a history of the change
