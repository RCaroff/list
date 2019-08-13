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
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios generate_signing_development
```
fastlane ios generate_signing_development
```
Generate provisioning profiles and certificates, pushes on certs repo and install them
### ios generate_signing_adhoc
```
fastlane ios generate_signing_adhoc
```

### ios generate_signing_appstore
```
fastlane ios generate_signing_appstore
```

### ios generate_signing_all
```
fastlane ios generate_signing_all
```

### ios generate_appicon
```
fastlane ios generate_appicon
```
Will generate appicons for app & watch from a 1024*1024px appicon.png file in project's fastlane folder. Warning : it will replace all icons files in AppIcon iconset.
### ios set_version_number
```
fastlane ios set_version_number
```
Set the version number with the one specified with parameter 'version'. Example : fastlane set_version_number version:1.6.3
### ios set_build_number
```
fastlane ios set_build_number
```
Set the build number with the one specified with parameter 'build'. Example : fastlane set_build_number build:1
### ios bump_version
```
fastlane ios bump_version
```

### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios release
```
fastlane ios release
```
Deploy a new version to the App Store
### ios test
```
fastlane ios test
```
Runs all the tests

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
