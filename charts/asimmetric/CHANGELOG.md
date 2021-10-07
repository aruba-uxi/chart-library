# Asimmetric Chart Library Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - yyyy-mm-dd

### Added

- what is new

### Changed

- what has been changed

### Fixed

- what has been fixed

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

> **__NOTE__** There is no logic to catch if you enabled sentry and forgot to provide the `.sealedSecrets.sentryDsn` value.

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
- See [README.md](https://github.com/Asimmetric/chart-library/blob/main/charts/asimmetric/README.md) and [MIGRATION_NOTES.md](https://github.com/Asimmetric/chart-library/blob/main/MIGRATION_NOTES.md) for information
- See [WiKi](https://github.com/Asimmetric/onboarding/wiki/Chart-Library) for a history of the change
