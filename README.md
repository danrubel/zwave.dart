# zwave.dart

zwave is a Dart package for interacting with Z-Wave devices.

## Overview

This Dart package enables interacting with
[Z-Wave devices](https://www.z-wave.com/) on Linux.

## Usage

This package provides
* a [library of Dart classes](lib/) for interacting with a Z-Wave network
* a [Z-Wave check port](bin/check_port.dart) for checking the connection to the Z-Wave controller
* a [Z-Wave packet decoder](bin/decode_packet.dart) for decoding and printing Z-Wave packets
* an [example](example/example.dart) using this package

## Requirements

* A Z-Wave Controller such as the
  [Aeon Labs Aeotec Z-Wave Z-Stick, Gen5 (ZW090)](http://aeotec.com/z-wave-usb-stick).

## Setup

1) [Setup](https://www.z-wave.com/smart-home-DIY-resources)
your Z-Wave controller with your Z-Wave devices

2) Activate this zwave package using the
[pub global](https://www.dartlang.org/tools/pub/cmd/pub-global.html) command.
```
    pub global activate zwave
```

3) From your application directory (the application that references
the zwave package) run the following command to build the native library
```
    pub global run zwave:build_lib
```

4) Finally, run the included [command line application](bin/check_port.dart) to ensure that this package
is installed correctly and can communicate with your devices using your Z-Wave Controller.
```
    pub global run zwave:zw_check
```

[pub global activate](https://www.dartlang.org/tools/pub/cmd/pub-global.html#activating-a-package)
makes the Dart scripts in the zwave/bin directory runnable
from the command line.
[pub global run](https://www.dartlang.org/tools/pub/cmd/pub-global.html#running-a-script)
zwave:build_lib runs the [zwave/bin/build_lib.dart](bin/build_lib.dart)
program which in turn calls the [build_lib](lib/src/native/build_lib) script
to compile the native libozw_ext.so library for the zwave package.

## Example

The [example](example/example.dart) demonstrates how to use this package to build
an application for interacting with a Z-Wave network.