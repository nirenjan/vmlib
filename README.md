Version Manager Library
=======================

The Version manager library (VMLib) is a generic library to handle
semantic versioning as specified at <http://semver.org>. In addition to
complying with semantic versioning v2.0.0-rc.1, it adds additional API
calls to bump the major, minor and patch versions as well as handle
distinct types of releases (development, alpha, beta, release candidate,
final as well as a custom type)

# Public API

VMLib has the following public CLI interface

`init <name>` - Initializes the version tracker
> This creates a new version tracker library for the project named
> <name>. It initializes the version number to 0.1.0 and the release
> type to `:development` and the release number to 0. If the project
> has already been intialized, then raises VMLibInitError.

`bump major` - Bumps the major version
> This will increment the major version by 1, while simultaneously
> setting the minor version and patchlevel to 0.

`bump minor` - Bumps the minor version
> This will increment the minor version by 1 and reset the patch level
> to 0.

`bump patch` - Bumps the patch level
> This will increment the patch level by 1.

`bump type` - Bumps the prerelease type to the next higher release type
> This will bump the prerelease type up to the next higher release type,
> i.e., `development` -> `alpha` -> `beta` -> `release candidate` ->
> `final`. The corresponding release number is also set to 1. If the
> release type is already `final` or `custom`, it will raise
> `VMLib::Errors::BumpError`.

`bump pre`, `bump prerelease`
> This will bump the release number by 1 if the prerelease type is
> `development`, `alpha`, `beta` or `release candidate`. If the
> release type is `:final` it will raise VMLib::Errors::BumpError.
> If the release type is `custom`, it will take the last field of
> `relcustom` and if numeric, it will bump it, otherwise, it will
> raise VMLib::Errors::BumpError.

`set pre`, `set prerelease`
> This will set the prerelease information as specified by the user.

`set build`
> This will set the build information as specified by the user.

`format`
> This takes in an optional format string for printing the version
> information. If the format string is not specified, it will revert to
> the default, however, if the format string is `tag`, then it will
> print the tag format.

`update`
> This command will search for all source files beginning with the
> string `version` and will update them to match with the primary
> version number set by the bump routine. It will also generate a Git
> commit for the changed files.

`tag`
> This command will generate a Git tag with the version specified by the
> version number file.

# Release Types

VMLib supports the following release types, in order

* development
* alpha
* beta
* release candidate
* final
* custom


