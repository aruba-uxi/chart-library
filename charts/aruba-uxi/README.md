# Aruba UXI Chart

A helm chart for Aruba UXI kubernetes resources

1. [Helm](#helm)
2. [Developing Notes](#developing-notes)
3. [Sealed Secrets](#sealed-secrets)

## Helm

Helm is used to build this library. These charts will be used the build the helm charts for a specific service.

### Value Files

Typically the `values.yaml` file defines the base values used by helm, and then additional values files are created based on the environment specific configs.

When using this chart library its best to leave the `values.yaml` files empty and define separate values for each environment.

> **__NOTE:__** Yes this does go against helm convention but its the best way we can do that does not cause duplicate data. Environment variables proved to be a bit tricky because in the local environment DATABASE_URL for example, could be defined in `.env` then in the staging environment it moves to `.envSealedSecrets`. It proved too hard to remove the duplicate values, so its best not to define any environment variables in the `values.yaml`.

It is possible to define some values in the `values.yaml` file. You are welcome to experiment with defining the some values in the `values.yaml` file and overriding them in the environment values file.

### Sealed Secrets

```yaml
aruba-uxi:
  sealedSecrets:
    ...
```

Sealed secrets are defined with the `.sealedSecrets` object. A `SealedSecret` kubernetes object is created using the data defined in this map.

| Parameter | Description | Default | Optional |
|-----|------|---------|---|
| sealedSecrets.imagePullSecret | The sealed version of the base64 encoded `dockerconfigjson` file used to provide access to our image repository | "" | Yes |
| sealedSecrets.env | Sealed secrets used to populate environment variables in the applications and containers. A sealed secret is created for each key in the dictionary. See [values.example.yaml](https://github.com/Aruba-UXI/chart-library/blob/main/examples/aruba-uxi-example/values.example.yaml) for usage| {} | Yes |

Follow the instructions in the [Sealed Secrets Wiki](https://github.com/aruba-uxi/knowledge/wiki/Sealed-Secrets) to create a `SealedSecret`.

When naming a sealed secret you need to ensure that the name you use to create the sealed secret and the name you give in the values file is the same.

> **__NOTE:__** The `sealedSecrets.imagePullSecret` name should be called `uxi-sealed-image-pull-secret`

Once you have created a `SealedSecret` you will need to copy the encoded value for each key defined.

For example, to create a sealed secret called `database-url` with the key `DATABASE_URL`, you need to follow the instructions in the link above to create a sealed secret with the following values:

- name: `database-url`
- key `DATABASE_URL`
- value: The value is the URL taken from wherever the database is hosted
- namespace: The namespace should be the name of the github repo, unless there are reasons for it to

The output should be a sealed secret with an encoded string for the `DATABASE_URL` value. Copy this value and paste it into the values file in the correct section.

```yaml
aruba-uxi:
  sealedSecrets:
    env:
      database-url:
        DATABASE_URL: sealed_version_of_the_base64_encoded_database_url
```

### Global Values

```yaml
aruba-uxi:
  global:
    ...
```

Global values used by all kubernetes objects. The `Can Override` column in the table identifies which values can be overridden by the applications or cronjobs.

| Parameter | Description | Default | Optional | Can Override |
|-----|------|---------|---|---|
| global.repository | The github repository that these charts are kept in | | No | No |
| global.environment | The environment that the service is being deployed to. Values are converted to lowercase when used. Validation is also done on the values. Valid environments are (`DEV`, `STAGING`, `PRODUCTION`) | | No | No |
| global.image.repository | The image repository to use for images. | | No | Yes |
| global.image.tag | The image tag to use. | | No | Yes |
| global.image.imagePullPolicy | The image pull policy to use. | `"IfNotPresent"` | Yes | Yes |
| global.env | Basic environment variables. Precedence is given to the overridden values | `{}` | Yes | Yes |
| global.envFields | Environment variables that pull information from kubernetss object fields. Precedence is given to the overridden values | `{}` | Yes |  Yes |
| global.envSealedSecrets | Environment variables from sealed secrets. Precedence is given to the overridden values. | `{}` | Yes | Yes |
| global.labels | Extra labels to apply to all k8s objects (excluding `sealedSecrets.imagePullSecret` and `sealedSecrets.sentryDsn`). | `{}` | Yes | Yes |

> **__NOTE:__** The `.global.image.tag` is required in the `values.yaml` file but is option in all overlays.

### Application Values

```yaml
aruba-uxi:
  applications:
    example-webapp:
      ...
    example-worker:
      ...
```

In this table `application` refers to each application defined under `applications`

| Parameter | Description | Default | Optional |
|-----|------|---------|--------|
| application.role | The role that this application will serve. Validation is done to make sure the correct role is provided. Valid roles are (`webapp`, `worker`) | | No |
| application.revisionHistoryLimit | The number of old ReplicaSets to be retained | `3` | Yes |
| application.replicaCount | The number of pod replicas to create | `1` | Yes |
| application.image.repository | A specific image that the application should use | `globals.image.repository` | Yes |
| application.image.tag | The image to use for this specific application | `globals.image.tag` | Yes |
| application.image.pullPolicy | The image pull policy to use for this application | `globals.image.pullPOlicy` | Yes |
| application.serviceAccount.create | Creates a service account and adds it to the application. If no name is provided the application name will be used | `false` | Yes |
| application.serviceAccount.name | The name of the service account to attach to this application| | Yes |
| application.serviceAccount.annotations | Any annotations to add the service account that is created | | Yes |
| application.command | The command that the pod must run. Overrides the docker image command | `""` | Yes |
| application.port | The port that must be exposed on the pod. Also used when adding a service to the webapp. Can be excluded when defining a worker | | No |
| application.service | Configures the service created for webapps | `ClusterIP` | Yes |
| application.service.type | Configures the service type that is created for webapps | `ClusterIP` | Yes |
| application.service.port | Configures the service port to expose | `80` | Yes |
| application.livenessProbe.path | The API path to query for liveness tests | `/livez` | Yes |
| application.readinessProbe.path | The API path to query for readiness tests | `/readyz` | Yes |
| application.resources | Resource limits and requests to set on the pod. See [link](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the structure | `{}` | Yes |
| application.nodeSelector | Node selector specifications to set on the pod. See [link](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) for more details on the structure | `{}` | Yes |
| application.tolerations | Tolerations to set on the pod. See [link](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the structure | `{}` | Yes |
| application.affinity | Affinity to set on the pod. See [link](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) for more details on the structure | `{}` | Yes |
| application.securityContext | Sets the security contextfor the pods. See [link](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details on the structure | `{}` | Yes |
| application.configMap | A config map to create and apply to the application | | Yes |
| application.configMap.annotations | Annotations to add to the config map | `{}` | Yes |
| application.configMap.readOnly | Whether the configmap is mapped as readonly or not | `true` | Yes |
| application.configMap.path | The path to map the config map to in the pod | `{}` | Yes |
| application.configMap.data | The data to add to the config map | `{}` | Yes |
| application.env | Basic environment variables specific for this application. Can override the global.env values | `{}` | Yes |
| application.envFields | Environment variables that pull information from kubernetss object fields for this application. Can override the global.envField values | `{}` | Yes |
| application.envSealedSecrets | Environment variables from sealed secrets specific to this application. Can override the global.envSealedSecrets values | `{}` | Yes |
| application.datadog.enabled | Enables datadog metrics. Setting to true will create the necessary environment variables | `false` | Yes |
| application.datadog.traceEnabled | Enables datadog tracing. | `false` | Yes |
| application.sentry.enabled | Enables sentry on the application. Setting to true will create the necessary environment variables. You need to add the `.sentry.dsn` value to create the sentry DSN sealed secret | `false` | Yes |
| application.sentry.dsn | Creates a sealed secret with the sentry DSN from the provided sealed version of the base64 encoded sentry DSN value. The sealed secret name takes the format `<application-name>-sentry-dsn` | | Yes |
| application.labels | Extra labels to apply to all k8s objects. Includes any extra labels defined in the global object. | `{}` | Yes |
| application.ingress | Configures the legacy ingress added to an application | `{}` | Yes |
| application.ingress.enabled | Enables the legacy ingress on the application. Setting to true will create a new legacy ingress manifest. | `false` | Yes |
| application.ingress.hosts | A list of hosts to add to the legacy ingress. | `[]` | Yes |
| application.ingress.hosts[].paths | A list of paths for each legacy ingress hosts | `[]` | Yes |
| application.ingress.hosts[].paths.path | The path | `/` | Yes |
| application.ingress.hosts[].paths.pathType | The path type | `ImplementationSpecific` | Yes |
| application.ingress.hosts[].paths.backend.serviceName | The service name that the path talks to. | `application.name` | Yes |
| application.ingress.hosts[].paths.backend.servicePort | The service port that the path talks to. | `application.port` | Yes |
| application.ingress.tls | A set of TLS configuration settings to add to the lagacy ingress. | `[]` | Yes |
| application.ingress.tls.secretName | The secret that contains the TLS certs. | | Yes |
| application.ingress.tls.hosts | The hosts which use the TLS certs contained in the respective secret. | | Yes |

### Cronjob Values

```yaml
aruba-uxi:
  cronjobs:
    example-cronjob-consumer:
      ...
    example-cronjob-producer:
      ...
```

In this table `cronjob` refers to each cronjob defined under `cronjobs`

| Parameter | Description | Default | Optional |
|-----|------|---------|--------|
| cronjob.schedule | The schedule to set for the cronjob to run on | | No |
| cronjob.suspend | Suspends the cronjob | `false` | Yes |
| cronjob.image.repository | A specific image that the cronjob should use | `globals.image.repository` | Yes |
| cronjob.image.tag | The image to use for this specific cronjob | `globals.image.tag` | Yes |
| cronjob.image.pullPolicy | The image pull policy to use for this cronjob | `globals.image.pullPOlicy` | Yes |
| cronjob.command | The command that the pod must run. Overrides the docker image command | `""` | Yes |
| cronjob.serviceAccount.create | Creates a service account and adds it to the cronjob. If no name is provided the application name will be used | `false` | Yes |
| cronjob.serviceAccount.name | The name of the service account to attach to this cronjob| | Yes |
| cronjob.serviceAccount.annotations | Any annotations to add the service account that is created | | Yes |
| cronjob.restartPolicy| Whether the cronjob should restart if a job fails | `OnFailure` | Yes |
| cronjob.env | Basic environment variables specific for this cronjob. Can override the global.env values | `{}` | Yes |
| cronjob.envFields | Environment variables that pull information from kubernetss object fields for this cronjob. Can override the global.envField values | `{}` | Yes |
| cronjob.envSealedSecrets | Environment variables from sealed secrets specific to this cronjob. Can override the global.envSealedSecrets values | `{}` | Yes |
| cronjob.datadog.enabled | Enables datadog metrics. Setting to true will create the necessary environment variables | `false` | Yes |
| cronjob.datadog.traceEnabled | Enables datadog tracing. | `false` | Yes |
| cronjob.sentry.enabled | Enables sentry on the cronjob. Setting to true will create the necessary environment variables. You need to add the `.sentry.dsn` value to create the sentry DSN sealed secret | `false` | Yes |
| cronjob.sentry.dsn | Creates a sealed secret with the sentry DSN from the provided sealed version of the base64 encoded sentry DSN value. The sealed secret name takes the format `<cronjob-name>-sentry-dsn` | | Yes |
| cronjob.labels | Extra labels to apply to all k8s objects. Includes any extra labels defined in the global object. | `{}` | Yes |

## Developing Notes

When contributing to this library certain approaches or concepts can be considered to make you life easier.

### Value Files

Helm works by using a default `values.yaml` file and overlaying additional values files provided with the `-f` tag to the helm command.

When using this library the values file is left largely empty except for the following values:

- `aruba-uxi.global.image.repository`
- `aruba-uxi.global.image.tag`
- `aruba-uxi.global.repository`

The `aruba-uxi.global.image.repository` and `aruba-uxi.global.image.tag` values are used as the default image. These can be overridden in other value files but it has to be present in the base `values.yaml` file.

The `aruba-uxi.global.repository` is only needed once and should not be overridden. It makes sense to add it here.

For example, the `values.yaml` file defines the default tag:

```yaml
# values.yaml
aruba-uxi:
  global:
    repoistory: example-service
    image:
      repository: example-service
      tag: 1.0.0
```

The staging environment overrides the tag to a development tag

```yaml
# values-staging.yaml
aruba-uxi:
  global:
    image:
      repository: quay.io/uxi/example-service
      tag: 1.0.0-dev
```

The production environment uses the default latest tag

```yaml
# values-production.yaml
aruba-uxi:
  global:
    image:
      repository: quay.io/uxi/example-service
      tag: 1.0.0
```

### _helpers.tpl

The `_helpers.tpl` file is used to assist in creating values used in the chart files.

### Include Function

Using `{{ include ... }}` refers to a template defined in the `_helpers.tpl` file.

### Range function

A template may refer to `.Values` and `.Chart` etc. When calling the template you will normally do it like `{{ include template.name . }}`. However, inside the `range` function `.` refers to the object within the range and not the root object. You will needs to call it with a `$` instead of `.`. For example, `{{ include template.name $ }}`.

### Passing Data to Include Function

We can pass our own object through to templates with the following pattern `{{ include template.name (dict "key1" value1 "key2" value2)}}` to include more than the `.` object.

This lets us provide more that one object (`.` and the data from within the `range` function) by calling the template like this `{{ include template.name (dict "context" $ "data" $data)}}`. Where `context` refers to the root object and `data` refers to the object within the range. This allows us to refer to multiple objects within the template. For example, `.context.Chart.Name` gives us access to the `name` value from `Chart.yaml` and `.data.name` gives us access to the `name` of the object in the range iteration.
