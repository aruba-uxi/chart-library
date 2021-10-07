# Asimmetric Chart

A helm chart for Asimmetric kubernetes resources

1. [Helm](#helm)
2. [Developing Notes](#developing-notes)

## Helm

Helm is used to build this library. These charts will be used the build the helm charts for a specific service.

### Value Files

Typically the `values.yaml` file defines the base values used by helm, and then additional values files are created based on the environment specific configs.

When using this chart library its best to leave the `values.yaml` files empty and define separate values for each environment.

> **__NOTE:__** Yes this does go against helm convention but its the best way we can do that does not cause duplicate data. Environment variables proved to be a bit tricky because in the local environment DATABASE_URL for example, could be defined in `.env` then in the staging environment it moves to `.envSealedSecrets`. It proved too hard to remove the duplicate values, so its best not to define any environment variables in the `values.yaml`.

It is possible to define some values in the `values.yaml` file. You are welcome to experiment with defining the some values in the `values.yaml` file and overriding them in the environment values file.

### Sealed Secrets

```yaml
asimmetric:
  sealedSecrets:
    ...
```

Sealed secrets are defined with the `.sealedSecrets` object. A `SealedSecret` kubernetes object is created using the data defined in this map.

| Parameter | Description | Default | Optional |
|-----|------|---------|---|
| sealedSecrets.imagePullSecret | The sealed version of the base64 encoded `dockerconfigjson` file used to provide access to our image repository | "" | Yes |
| sealedSecrets.sentryDsn | Creates a sealed secret with the sentry DSN from the provided sealed version of the base64 encoded sentry DSN value | | Yes |
| sealedSecrets.env | Sealed secrets used to populate environment variables in the applications and containers. A sealed secret is created for each key in the dictionary. See [values.example.yaml](https://github.com/Asimmetric/chart-library/blob/main/examples/asimmetric-example/values.example.yaml) for usage| {} | Yes |

### Global Values

```yaml
asimmetric:
  global:
    ...
```

Global values used by all kubernetes objects. The `Can Override` column in the table identifies which values can be overridden by the applications or cronjobs.

| Parameter | Description | Default | Optional | Can Override |
|-----|------|---------|---|---|
| global.repository | The repository that this chart is kept in | | No | No |
| global.environment | The environment that the service is being deployed to. Values are converted to lowercase when used. Validation is also done on the values. Valid environments are (`DEV`, `STAGING`, `PRODUCTION`) | | No | No |
| global.image.repository | The image repository to use for images. | | No | Yes |
| global.image.imagePullPolicy | The image pull policy to use. | `"IfNotPresent"` | Yes | Yes |
| global.image.tag | The image tag to use. | | No | Yes |
| global.env | Basic environment variables. Precedence is given to the overridden values | `{}` | Yes | Yes |
| global.envFields | Environment variables that pull information from kubernetss object fields. Precedence is given to the overridden values | `{}` | Yes |  Yes |
| global.envSealedSecrets | Environment variables from sealed secrets. Precedence is given to the overridden values. | `{}` | Yes | Yes |
| global.labels | Extra labels to apply to all k8s objects (excluding `sealedSecrets.imagePullSecret` and `sealedSecrets.sentryDsn`). | `{}` | Yes | Yes |

> **__NOTE:__** The `.global.image.tag` is required in the `values.yaml` file but is option in all overlays.

### Application Values

```yaml
asimmetric:
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
| application.sentry.enabled | Enables sentry on the application. Setting to true will create the necessary environment variables. You need to add the `.sealedSecrets.sentryDsn` value to create the sentry-dsn sealed secret | `false` | Yes |
| application.labels | Extra labels to apply to all k8s objects. Includes any extra labels defined in the global object. | `{}` | Yes |

### Cronjob Values

```yaml
asimmetric:
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
| cronjob.image.repository | A specific image that the cronjob should use | `globals.image.repository` | Yes |
| cronjob.image.tag | The image to use for this specific cronjob | `globals.image.tag` | Yes |
| cronjob.image.pullPolicy | The image pull policy to use for this cronjob | `globals.image.pullPOlicy` | Yes |
| cronjob.command | The command that the pod must run. Overrides the docker image command | `""` | Yes |
| cronjob.serviceAccount.create | Creates a service account and adds it to the cronjob. If no name is provided the application name will be used | `false` | Yes |
| cronjob.serviceAccount.name | The name of the service account to attach to this cronjob| | Yes |
| cronjob.serviceAccount.annotations | Any annotations to add the service account that is created | | Yes |
| cronjob.env | Basic environment variables specific for this cronjob. Can override the global.env values | `{}` | Yes |
| cronjob.envFields | Environment variables that pull information from kubernetss object fields for this cronjob. Can override the global.envField values | `{}` | Yes |
| cronjob.envSealedSecrets | Environment variables from sealed secrets specific to this cronjob. Can override the global.envSealedSecrets values | `{}` | Yes |
| cronjob.datadog.enabled | Enables datadog metrics. Setting to true will create the necessary environment variables | `false` | Yes |
| cronjob.datadog.traceEnabled | Enables datadog tracing. | `false` | Yes |
| cronjob.sentry.enabled | Enables sentry on the cronjob. Setting to true will create the necessary environment variables. You need to add the `.sealedSecrets.sentryDsn` value to create the sentry-dsn sealed secret | `false` | Yes |
| cronjob.labels | Extra labels to apply to all k8s objects. Includes any extra labels defined in the global object. | `{}` | Yes |

## Developing Notes

When contributing to this library certain approaches or concepts can be considered to make you life easier.

### Value Files

Helm works by using a default `values.yaml` file and overlaying additional values files provided with the `-f` tag to the helm command.

When using this library the values file is left largely empty except for the `asimmetric.global.image.tag`. The `asimmetric.global.image.tag` is used as the default image tag. This tag can be overridden in other value files but it has to be present in the base `values.yaml` file.

For example, the `values.yaml` file defines the default tag:

```yaml
# values.yaml
asimmetric:
  global:
    image:
      tag: 1.0.0
```

The staging environment overrides the tag to a development tag

```yaml
# values-staging.yaml
asimmetric:
  global:
    image:
      tag: 1.0.0-dev
```

The production environment uses the default latest tag

```yaml
# values-production.yaml
asimmetric:
  global:
    image:
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
