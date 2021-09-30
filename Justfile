# Show this message and exit.
help:
	@just list

output:
	just template-asimmetric-local "> examples/asimmetric-example/output-local.yaml"
	just template-asimmetric-staging "> examples/asimmetric-example/output-staging.yaml"

template-asimmetric-local +ARGS='':
	helm dependency update examples/asimmetric-example
	helm template asimmetric-example examples/asimmetric-example -f examples/asimmetric-example/values-local.yaml {{ARGS}}

template-asimmetric-staging +ARGS='':
	helm dependency update examples/asimmetric-example
	helm template asimmetric-example examples/asimmetric-example -f examples/asimmetric-example/values-staging.yaml {{ARGS}}
