# chart-library

A repository to store ArubaUXI helm charts.

## Table Of Contents

- [Version Control](#version-control)
- [Pull Requests](#pull-requests)
- [Templating](#templating)
- [Additional Information](#additional-information)

> *__WARNING__:* This is a public repository holding the helm libraries. Do not commit private information to this repo.

## Version Control

Ths repo follows the [SemVer 2](https://semver.org/) version format.

Given a version number `MAJOR.MINOR.PATCH`, increment the:

- `MAJOR` version when you make incompatible API changes,
- `MINOR` version when you add functionality in a backwards compatible manner, and
- `PATCH` version when you make backwards compatible bug fixes.

## Pull Requests

This repo enforces the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style through the use of [Semantic Pull Requests](https://github.com/zeke/semantic-pull-requests) github app.

A commit message or PR title should take the form

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)
```

## Templating

Templating helps view the final kubernetes manifests that are rendered based on the values provided to the helm charts.
The Justfile defines commands to template the various examples.

To template the `aruba-uxi-example` without any arguments:

## Additional Information

See <https://github.com/aruba-uxi/knowledge/wiki/Helm-Charts-Library>
