# CanaryiOS

An iOS library designed to power iOS apps. Based on the [original project](https://github.com/OperatorFoundation/CanaryLibrary.git) written in Swift.

Canary is a tool for testing transport connections and gathering the packets for analysis.

Canary will run a series of transport tests based on the configs that you provide. It is possible to test each transport on a different transport server based on what host information is provided in the transport config files.

Currently only [Shadow](https://github.com/OperatorFoundation/ShapeshifterAndroidKotlin.git) tests are supported. Replicant support is underway, and will be capable of mimicking other transports when it is complete.

## Generate Shadow config files
-Go to: [ShadowSwift](https://github.com/OperatorFoundation/ShadowSwift.git).

## Running Canary
- Transport configs should include their transport server IP and port, and should include the transport name in the name of the file.
- Canary client config files must be saved in the file management system of the device. Config files must conform to the following convention:

{"serverIP":"127.0.0.1","password":"enterYourClientConfigPassword","cipherName":"DarkStar","port":1234}

-Once configured, Canary iOS allows users to run tests, view results, and share results.
