# Show this message and exit.
help:
	@just list

helm-dependency-update:
  helm dependency update charts/deploymentexample

template-example +ARGS='':
  @just helm-dependency-update
  helm template charts/deploymentexample {{ARGS}}
