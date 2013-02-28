Version Manager Library
=======================

The Version manager library (VMLib) is a generic library to handle
semantic versioning as specified at <http://semver.org>. In addition to
complying with semantic versioning v2.0.0-rc.1, it adds additional API
calls to bump the major, minor and patch versions as well as handle
distinct types of releases (development, alpha, beta, release candidate,
final as well as a custom type)

# Public API

VMLib has the following public API

`init <name>` - Initializes the version tracker
> This creates a new version tracker library for the project named
> <name>. It initializes the version number to 0.1.0 and the release
> type to `:development` and the release number to 0. If the project
> has already been intialized, then raises VMLibInitError.

`bump major` - Bumps the major version
> This will increment the major version by 1, while simultaneously
> setting the minor version and patchlevel to 0. The release type is
> also set to `:final`.

`bump minor` - Bumps the minor version
> This will increment the minor version by 1 and reset the patch level
> to 0. The release type is also set to `:final`.

`bump patch` - Bumps the patch level
> This will increment the patch level by 1 and set the release type to
> `:final`.

`bump type` - Bumps the release type to the next higher release type
> This will bump the release type up to the next higher release type,
> i.e., `:development` -> `:alpha` -> `:beta` -> `:release_candidate` ->
> `:final`. The corresponding release number is also set to 0. If the
> release type is already `:final` or `:custom`, it will raise
> VMLibBumpError.

`bump release`
> This will bump the release number by 1 if the release type is
> `:development`, `:alpha`, `:beta` or `:release_candidate`. If the
> release type is `:final` it will raise VMLibBumpError. If the release
> type is `:custom`, it will take the last field of `:rel_custom` and
> if numeric, it will bump it, otherwise, it will raise VMLibBumpError.

`bump build`
> This will bump the build number by 1, unless the build type is set to
> `:custom`, in which case it will raise VMLibBumpError, unless the last
> field of `:build_custom` is numeric, in which case, that field is
> incremented by 1.

# Release Types

VMLib supports the following release types, in order

* :development
* :alpha
* :beta
* :release\_candidate
* :final
* :custom


