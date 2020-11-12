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
### mac build
```
fastlane mac build
```
Build and notarize the app
### mac compress
```
fastlane mac compress
```
Creates zip file with the application and provides the necessary name format (which is used by the Sparkle framework)
### mac release
```
fastlane mac release
```
Do all the necessary things to prepare a new release

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
