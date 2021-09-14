# Job Library Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - yyyy-mm-dd

### Added

- what has been added

### Changed

- what has been changed

### Fixed

- what has been fixed

## [0.2.0] - 2021-09-13

### Added

Changed `_job_.tpl`

- image tag defined through `values.yaml`

### Changed

Changed `_job_.tpl`

- Jobs must always define their own image mapping.
- Get image tag from `job.image.tag` but default to `.Chart.appVersion` if it is not defined in the values file.

### Fixed

## [0.1.4] - 2021-09-13

All previous changes
