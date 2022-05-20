# Aruba UXI Chart

A helm chart for Aruba UXI kubernetes services. These charts will be used the build the helm charts for a specific service.

- [Auto Populated Environment Variables](#auto-populated-environment-variables)
- [Sealed Secrets](#sealed-secrets)
- [Value Files](#value-files)
- [Global Values](#global-values)
- [Application Values](#application-values)
- [Cronjob Values](#cronjob-values)
- [Developing Notes](#developing-notes)

## Auto Populated Environment Variables

The chart library defines a set of automatically populated environment variables.

- `APPLICATION_NAME`: The name of the application, taken from `.Values.application`
- `APPLICATION_VERSION`: The version of the application, taken from `.Values.image.tag`
- `DD_AGENT_HOST`: The hostname of the datadog agent. This is set to the `status.hostIP`.
- `DD_ENABLED`: A boolean that can be used to control datadog (see `.Values.application.datadog.enabled`).
- `DD_ENTITY_ID`: A value taken from pod metadata "metadata.uid".
- `DD_ENV`: The environment name that datadog will use, taken from `Values.global.environment`.
- `DD_SERVICE`: The service name that datadog will use (see `.Values.application.datadog` for more).
- `DD_TRACE_ENABLED`: A boolean that can be used to control datadog trace (see `.Values.application.datadog.traceEnabled`).
- `ENVIRONMENT`: The environment, taken from `.Values.global.environment`
- `SENTRY_DSN`: If `.Values.application.sentry.enabled`) this variable is populate from the `.Values.application.sentry.dsn`.
- `SENTRY_ENVIRONMENT`: If `.Values.application.sentry.enabled`) this variable is set the application name.

## Sealed Secrets

```yaml
aruba-uxi:
  sealedSecrets:
    ...
```

Sealed secrets are defined with the `.Values.aruba-uxi.sealedSecrets` section. A `SealedSecret` kubernetes object is created using the data defined in this map.
Follow the instructions in the [Sealed Secrets Wiki](https://github.com/aruba-uxi/knowledge/wiki/Sealed-Secrets) to create a `SealedSecret`.

> **NOTE:** When naming a sealed secret you need to ensure that the name you use to create the sealed secret and the name you give in the values file is the same.

### Image Pull Secrets

The `sealedSecrets.imagePullSecret` is created with the name `<repository-name>-image-pull-secret`.

#### Example

Once you have created a `SealedSecret` you will need to copy the encoded value for each key defined.

To create a sealed secret called `database-url` with the key `DATABASE_URL`, you need to follow the instructions in the link above to create a sealed secret with the following values:

- name: `database-url`
- namespace: The namespace should be the name of the github repo, unless there are reasons for it to
- key:`DATABASE_URL`
- value: The value is the URL taken from wherever the database is hosted

The output should be a sealed secret with an encoded string for the `DATABASE_URL` value. Copy this value and paste it into the values file in the correct section.

```yaml
aruba-uxi:
  sealedSecrets:
    env:
      database-url:
        DATABASE_URL: sealed_version_of_the_base64_encoded_database_url
```

## Value Files

Helm works by using a default `values.yaml` file and overlaying additional values files provided with the `-f` tag to the helm command.

> **NOTE:** Yes this does go against helm convention but its the best way we can do that does not cause duplicate data. Environment variables proved to be a bit tricky because in the local environment DATABASE_URL for example, could be defined in `.env` then in the staging environment it moves to `.envSealedSecrets`. It proved too hard to remove the duplicate values, so its best not to define any environment variables in the `values.yaml`.

When using this chart library its best to leave the `values.yaml` files empty except for the following values:

- `aruba-uxi.global.image.repository`
- `aruba-uxi.global.image.tag`
- `aruba-uxi.global.repository`

The `aruba-uxi.global.image.repository` and `aruba-uxi.global.image.tag` values are used as the default image. These can be overridden in other value files but it has to be present in the base `values.yaml` file.

The `aruba-uxi.global.repository` is only needed once and should not be overridden. It makes sense to add it here.

### Base Values File

It is possible to define some values in the `values.yaml` file. You are welcome to experiment with defining the some values in the `values.yaml` file and overriding them in the environment values file.

```yaml
# values.yaml
aruba-uxi:
  global:
    repoistory: example-service
    image:
      repository: example-service
      tag: 1.0.0
```

## Global Values

```yaml
aruba-uxi:
  global:
    ...
```

Global values used by all kubernetes objects. Some of these values can be overridden (see `values.example.yaml`). If overridden, in the application or cronjob, precedence is given to the overridden values.

## Application Values

```yaml
aruba-uxi:
  applications:
    example-webapp:
      ...
    example-worker:
      ...
```

Creates one or more applications unique by their name. Applications are defined as keys in the applications map.
The key is used as the name of the application and subsequent objects created. Some of these values can be overridden (see `values.example.yaml`).

## Cronjob Values

```yaml
aruba-uxi:
  cronjobs:
    example-cronjob-consumer:
      ...
    example-cronjob-producer:
      ...
```

Creates one or more cronjobs unique by their name. Cronjobs are defined as keys in the cronjob map.
The key is used as the name of the cronjob and subsequent objects created. Some of these values can be overridden (see `values.example.yaml`).

## Developing Notes

When contributing to this library certain approaches or concepts can be considered to make you life easier.

### _helpers.tpl

The `_helpers.tpl` file is used to assist in creating values used in the chart files.

### Include Function

Using `{{ include ... }}` refers to a template defined in the `_helpers.tpl` file.

### Range function

A template may refer to `.Values` and `.Chart` etc. When calling the template you will normally do it like `{{ include template.name . }}`. However, inside the `range` function `.` refers to the object within the range and not the root object. You will needs to call it with a `$` instead of `.`. For example, `{{ include template.name $ }}`.

### Passing Data to Include Function

We can pass our own object through to templates with the following pattern `{{ include template.name (dict "key1" value1 "key2" value2)}}` to include more than the `.` object.

This lets us provide more that one object (`.` and the data from within the `range` function) by calling the template like this `{{ include template.name (dict "context" $ "data" $data)}}`. Where `context` refers to the root object and `data` refers to the object within the range. This allows us to refer to multiple objects within the template. For example, `.context.Chart.Name` gives us access to the `name` value from `Chart.yaml` and `.data.name` gives us access to the `name` of the object in the range iteration.
