# chart-library

This is a public repository holding the helm libraries

It has Github pages hosted on the branch `gh-pages`

# Examples

To run an example:

1. `cd` into the example directory:

   `cd example/deploymentexample`

2. Update the dependencies:

   `helm dependency update deploymentexample`

3. Build the template:

   `helm template --debug deploymentexample`
