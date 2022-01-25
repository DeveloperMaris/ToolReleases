fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Mac

### mac release

```sh
[bundle exec] fastlane mac release
```

Do all the necessary things to prepare a new release

### mac build

```sh
[bundle exec] fastlane mac build
```

Build and notarize the app

### mac compress

```sh
[bundle exec] fastlane mac compress
```

Create zip file with the application and provides the necessary name format (which is used by the Sparkle framework).

### mac sign_update_for_sparkle

```sh
[bundle exec] fastlane mac sign_update_for_sparkle
```



### mac release_hash_for_homebrew

```sh
[bundle exec] fastlane mac release_hash_for_homebrew
```

Return sha-256 hash from the application zip file. This is necessary for the Homebrew version.

### mac release_on_github

```sh
[bundle exec] fastlane mac release_on_github
```

Uploads the latest build to the GitHub Releases.

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
