# Migrate To New Chart Library

> **_NOTE_** Its a good idea to run `helm template <service_name> -f charts<service_name>/values-staging.yaml` on your current helm charts, and then again when you have moved to using the `aruba-uxi` library, pipeing the output to a separate file each. This way you will be able to compare the k8s objects and see that you have done everything right

Moving from the old library to the new one is fairly straight forward. However, there are some notable changes.

See [PR-140](https://github.com/aruba-uxi/customer-integrations-service/pull/140) for the customer-integrations-service repo to see how it is done

## Noteable Changes

- `labels.repo` has moved to `global.repository`
- `.Chart.appVersion` is no longer used and should be removed from the `Chart.yaml` file
- applications (webapp or worker) require the `role` to be set to state whether they are a webapp or a worker.
- webapps and workers are all defined under `.Values.asimemtric.applications`
- cronjobs are defined under `.Values.asimemtric.cronjobs`
- Datadog is enabled by setting the `datadog.enabled` value to `true`. When set to `true` all the required environment variables will be added for you. You should not need to add `DD_ENV`, `DD_SERVICE`, `DD_TRACE_ENABLED`, `DD_ENTITY_ID`, `DD_AGENT_HOST`. (See the [README](https://github.com/aruba-uxi/chart-library/blob/main/charts/aruba-uxi/README.md#application-values) for information on what can be configure for datadog)

## Chart.yaml Dependencies

The helm charts have been moved into a single template called `aruba-uxi`. This means that in your `Chart.yaml` file you only need to define a single dependency

```yaml
# Chart.yaml
dependencies:
- name: aruba-uxi
  version: "1.0.0"
  repository: https://aruba-uxi.github.io/chart-library
```

## Values Files

Helm works by using a `values.yaml` and then overriding the values with those defined in additional values file e.g :

```sh
helm install example-service -f /charts/example-service/values-staging.yaml
```

Will use the values defined in `values.yaml` and then override them with any values defined in `values-staging.yaml`.

Currently its best to define a values file for each environment (local, staging, production). The result is:

- `values.yaml` is empty
- `values-local.yaml` holds all values for local
- `values-staging.yaml` holds all values for staging
- `values-production.yaml` holds all values for production

## Values

To set values that the aruba-uxi library uses, you need to add a map to the values file. For example:

``` yaml
# values-staging.yaml
aruba-uxi:
 ...
```

Within `.Values.aruba-uxi` will be the values as discussed in [values.example.yaml](https://github.com/aruba-uxi/chart-library/blob/main/examples/aruba-uxi-example/values.example.yaml)

## Notes / ToDo

- If you are reading this in the early days of the staging project that means we do not need a `values-local.yaml` file so you can remove that file
- No need to add a `values-production.yaml` file to the service
- Its possible that for now you can define all the environment variables in the `aruba-uxi.global` map. You can always move them around if you need to have different values per application or cronjob
