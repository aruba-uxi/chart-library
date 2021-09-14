# Deployment Library Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - yyyy-mm-dd

### Added

- what has been added

### Changed

- what has been changed

### Fixed

- what has been fixed

## [0.6.0] - 2021-09-13

### Added

Changed `_webapp.tpl`

- image tag defined through `values.yaml`

### Changed

Changed `_webapp.tpl`

- Get image tag from `.Values.image.tag` but default to `.Chart.appVersion` if it is not defined in the values file.
- Values file updated to use an `image` map for `tag`, `pullPolicy` and `repository`

### Fixed

## [0.5.5] - 2021-09-13

All previous changes
