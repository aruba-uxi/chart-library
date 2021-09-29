# Asimmetric Chart

A helm chart for Asimmetric kubernetes resources

## Global Values

```yaml
asimmetric:
  global:
    ...
```

Global values used by all kubernetes objects. Some can be overridden.

| Parameter | Description | Default | Can Override |
|-----|------|---------|--------|
| global.repository | The repository that this chart is kept in | | No |
| global.environment | The environment that the service is being deployed to. | `DEV` | No |
| global.image.imagePullPolicy | The image pull policy to use. | `"IfNotPresent"` | Yes |
| global.image.repository | The image repository to use for images. | | Yes |
| global.image.tag | The image tag to use. | `"2.0.5"` | Yes |
| global.env | Basic environment variables. Precedence is given to the overridden values | `{}` | Yes |
| global.envFields | Environment variables that pull information from kubernetss object fields. Precedence is given to the overridden values | `{}` | Yes |
| global.envSealedSecrets | Environment variables from sealed secrets. Precedence is given to the overridden values. | `{}` | Yes |

## Application Values

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
| application.role | The role that this application will serve (webapp / worker) | | No |
| application.replicaCount | The number of pod replicas to create | `1` | Yes |
| application.image.repository | A specific image that the application should use | `globals.image.repository` | Yes |
| application.image.tag | The image to use for this specific application | `globals.image.tag` | Yes |
| application.image.pullPolicy | The image pull policy to use for this application | `globals.image.pullPOlicy` | Yes |
| application.serviceAccount.create | Creates a service account and adds it to the application. If no name is provided the application name will be used | `false` | Yes |
| application.serviceAccount.name | The name of the service account to attach to this application| | Yes |
| application.serviceAccount.annotations | Any annotations to add the service account that is created | | Yes |
| application.command | The command that the pod must run. Overrides the docker image command | `""` | Yes |
| application.port | The port that must be exposed on the pod. Also used when adding a service to the webapp | | No |
| application.service | Configures the service created for webapps | `ClusterIP` | Yes |
| application.service.type | Configures the service type that is created for webapps | `ClusterIP` | Yes |
| application.service.port | Configures the service port to expose | `80` | Yes |
| application.livenessProbe.path | The API path to query for liveness tests | `/livez` | Yes |
| application.readinessProbe.path | The API path to query for readiness tests | `/readyz` | Yes |
| application.resources | Resource limits and requests to set on the pod. See [link](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the structure | `{}` | Yes |
| application.nodeSelector | Node selector specifications to set on the pod. See [link](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) for more details on the structure | `{}` | Yes |
| application.tolerations | Tolerations to set on the pod. See [link](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the structure | `{}` | Yes |
| application.affinity | Affinity to set on the pod. See [link](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) for more details on the structure | `{}` | Yes |
| application.configMap | A config map to create and apply to the application | | Yes |
| application.configMap.annotations | Annotations to add to the config map | `{}` | Yes |
| application.configMap.readOnly | Whether the configmap is mapped as readonly or not | `true` | Yes |
| application.configMap.path | The path to map the config map to in the pod | `{}` | Yes |
| application.configMap.data | The data to add to the config map | `{}` | Yes |
| application.env | Basic environment variables specific for this application. Can override the global.env values | `{}` | Yes |
| application.envFields | Environment variables that pull information from kubernetss object fields for this application. Can override the global.envField values | `{}` | Yes |
| application.envSealedSecrets | Environment variables from sealed secrets specific to this application. Can override the global.envSealedSecrets values | `{}` | Yes |

## Cronjob Values

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
| cronjob.image.repository | A specific image that the application should use | `globals.image.repository` | Yes |
| cronjob.image.tag | The image to use for this specific application | `globals.image.tag` | Yes |
| cronjob.image.pullPolicy | The image pull policy to use for this application | `globals.image.pullPOlicy` | Yes |
| cronjob.command | The command that the pod must run. Overrides the docker image command | `""` | Yes |
| cronjob.serviceAccount.create | Creates a service account and adds it to the application. If no name is provided the application name will be used | `false` | Yes |
| cronjob.serviceAccount.name | The name of the service account to attach to this application| | Yes |
| cronjob.serviceAccount.annotations | Any annotations to add the service account that is created | | Yes |
| cronjob.env | Basic environment variables specific for this application. Can override the global.env values | `{}` | Yes |
| cronjob.envFields | Environment variables that pull information from kubernetss object fields for this application. Can override the global.envField values | `{}` | Yes |
| cronjob.envSealedSecrets | Environment variables from sealed secrets specific to this application. Can override the global.envSealedSecrets values | `{}` | Yes |
