# Show this message and exit.
help:
	@just list

output:
  just template-deployment "> charts/deploymentexample/output.yaml"
  just template-deployment-staging "> charts/deploymentexample/output.staging.yaml"
  just template-ingress "> charts/ingressexample/output.yaml"
  just template-ingress-staging "> charts/ingressexample/output.staging.yaml"
  just template-job "> charts/jobexample/output.yaml"
  just template-job-staging "> charts/jobexample/output.staging.yaml"
  just template-service "> charts/serviceexample/output.yaml"
  just template-service-staging "> charts/serviceexample/output.staging.yaml"
  just template-serviceaccount "> charts/serviceaccountexample/output.yaml"
  just template-serviceaccount-staging "> charts/serviceaccountexample/output.staging.yaml"

template-deployment +ARGS='':
  helm dependency update charts/deploymentlib
  helm dependency update charts/deploymentexample
  helm template charts/deploymentexample {{ARGS}}

template-deployment-staging +ARGS='':
  @just template-deployment -f charts/deploymentexample/values.yaml -f charts/deploymentexample/values-staging.yaml "{{ARGS}}"

template-ingress +ARGS='':
  helm dependency update charts/ingressexample
  helm template charts/ingressexample {{ARGS}}

template-ingress-staging +ARGS='':
  @just template-ingress -f charts/ingressexample/values.yaml -f charts/ingressexample/values-staging.yaml "{{ARGS}}"

template-job +ARGS='':
  helm dependency update charts/joblib
  helm dependency update charts/jobexample
  helm template charts/jobexample {{ARGS}}

template-job-staging +ARGS='':
  @just template-job -f charts/jobexample/values.yaml -f charts/jobexample/values-staging.yaml "{{ARGS}}"

template-service +ARGS='':
  helm dependency update charts/serviceexample
  helm template charts/serviceexample {{ARGS}}

template-service-staging +ARGS='':
  @just template-service -f charts/serviceexample/values.yaml -f charts/serviceexample/values-staging.yaml "{{ARGS}}"

template-serviceaccount +ARGS='':
  helm dependency update charts/serviceaccountexample
  helm template charts/serviceaccountexample {{ARGS}}

template-serviceaccount-staging +ARGS='':
  @just template-serviceaccount  -f charts/serviceaccountexample/values.yaml -f charts/serviceaccountexample/values-staging.yaml "{{ARGS}}"


template-asimmetric +ARGS='':
  helm dependency update examples/asimmetric-example
  helm template asimmetric-example examples/asimmetric-example {{ARGS}}
