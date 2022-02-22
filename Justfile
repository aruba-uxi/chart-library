# Show this message and exit.
help:
	@just list

# Render helm templates for aruba-uxi example to file
output:
	just template-aruba-uxi-local "> examples/aruba-uxi-example/output-local.yaml"
	just template-aruba-uxi-staging "> examples/aruba-uxi-example/output-staging.yaml"
	just template-aruba-uxi-production "> examples/aruba-uxi-example/output-production.yaml"

# Render helm templates for aruba-uxi example local
template-aruba-uxi-local +ARGS='':
	helm dependency update examples/aruba-uxi-example
	helm template aruba-uxi-example examples/aruba-uxi-example -f examples/aruba-uxi-example/values-local.yaml {{ARGS}}

# Render helm templates for aruba-uxi example staging
template-aruba-uxi-staging +ARGS='':
	helm dependency update examples/aruba-uxi-example
	helm template aruba-uxi-example examples/aruba-uxi-example -f examples/aruba-uxi-example/values-staging.yaml {{ARGS}}

# Render helm templates for aruba-uxi example production
template-aruba-uxi-production +ARGS='':
	helm dependency update examples/aruba-uxi-example
	helm template aruba-uxi-example examples/aruba-uxi-example -f examples/aruba-uxi-example/values-production.yaml {{ARGS}}
