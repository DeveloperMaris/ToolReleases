fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## Mac
### mac release
```
fastlane mac release
```
Do all the necessary things to prepare a new release
### mac build
```
fastlane mac build
```
Build and notarize the app
### mac compress
```
fastlane mac compress
```
Create zip file with the application and provides the necessary name format (which is used by the Sparkle framework).
### mac release_hash
```
fastlane mac release_hash
```
Return sha-256 hash from the application zip file. This is necessary for the Homebrew version.
### mac release_on_github
```
fastlane mac release_on_github
```
Uploads the latest build to the GitHub Releases.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
