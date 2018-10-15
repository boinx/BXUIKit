# BXUIKit
[![build status](https://api.travis-ci.org/boinx/BXUIKit.svg?branch=master)](https://travis-ci.org/boinx/BXUIKit) ![lines of code](https://tokei.rs/b1/github/boinx/bxuikit?category=code) ![comments](https://tokei.rs/b1/github/boinx/bxuikit?category=comments)

AppKit/UIKit extensions written by Boinx Software Ltd. & IMAGINE GbR

Feel free to browse the [BXUIKit](BXUIKIt) directory.
Also, check our [Styleguide](STYLEGUIDE.md).

## Continuous Integration
Since this project will be embedded in most (if not all) of our products, we want to make sure that it always compiles and functions as expected.
Therefore, [travis-ci](https://travis-ci.org/boinx/BXUIKit) will build every commit and run the tests on both macOS and iOS.
Afterwards, a slack notification will be sent to the `#dev` channel.

The process is described in [ `.travis.yml`](.travis.yml).
Setting the Xcode version also implies a certain macOS and iOS version (This information can be found in the [Travis CI Guides](https://docs.travis-ci.com/user/reference/osx/#Xcode-version)).
When changing the Xcode version, keep in mind to also update the build destination versions, or the build will fail.
