
##About the Handset Assistant for iOS

This project contains the source code for buidling the handset assistant framework for iOS. 

This is a minimal implementation, written in Swift that gathers parameters from iOS devices and submits them as HuqDeviceInformationEvents.

The Framework is compiled as a binary and distributed via the Swift Package Manager. More coming on this.

###Getting Started

Edit the project is using XCode. The SampleApplication integrates the Framework, use this target to test changes made to the framework code. You should be sure to test the code on a physical device for the most representative results. It can be useful to use a proxy to check that the data is being submitted correctly, for example [mitmproxy](https://mitmproxy.org)

###Build and test the binary
Run `./build_framework.sh` to build the Framework locally.