# Show this message and exit.
help:
	@just list

template-deployment +ARGS='':
  helm dependency update charts/deploymentexample
  helm template charts/deploymentexample {{ARGS}}

template-ingress +ARGS='':
  helm dependency update charts/ingressexample
  helm template charts/ingressexample {{ARGS}}
