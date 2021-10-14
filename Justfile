# Show this message and exit.
help:
	@just list

output:
	just template-aruba-uxi-local "> examples/aruba-uxi-example/output-local.yaml"
	just template-aruba-uxi-staging "> examples/aruba-uxi-example/output-staging.yaml"

template-aruba-uxi-local +ARGS='':
	helm dependency update examples/aruba-uxi-example
	helm template aruba-uxi-example examples/aruba-uxi-example -f examples/aruba-uxi-example/values-local.yaml {{ARGS}}

template-aruba-uxi-staging +ARGS='':
	helm dependency update examples/aruba-uxi-example
	helm template aruba-uxi-example examples/aruba-uxi-example -f examples/aruba-uxi-example/values-staging.yaml {{ARGS}}
