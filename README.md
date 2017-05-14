# ReactantCLI

**IMPORTANT**: ReactantCLI is a preview and we'd love any feedback on it.

## Requirements

* Swift 3.0+
* CocoaPods

## Installation

Follow these steps to install ReactantCLI:
1. download the master branch in zip: https://github.com/Brightify/ReactantCLI/archive/master.zip
2. unzip the file
3. in terminal, go into the unzipped directory
4. run `make install`

**NOTE**: The same steps apply to updating.

## Usage

At this time, ReactantCLI has only one command and that's `init`. It'll ask you for configuration and then it'll initialize a Reactant project for you.

To use it, run `reactant init`. After you answer its questions and confirm the configuration, ReactantCLI will create a directory with the new project inside it. It will then proceed to run `pod install`. After that's completed, the new project will open in Xcode and you can run it.
