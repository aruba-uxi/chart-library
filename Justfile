# Show this message and exit.
help:
	@just list

output:
  just template-asimmetric "> examples/asimmetric-example/output.yaml"

template-deployment +ARGS='':
  helm dependency update charts/deploymentlib
  helm dependency update charts/deploymentexample
  helm template charts/deploymentexample {{ARGS}}

template-asimmetric +ARGS='':
  helm dependency update examples/asimmetric-example
  helm template asimmetric-example examples/asimmetric-example {{ARGS}}
