# zwave.dart

zwave is a Dart package for interacting with Z-Wave devices.

## Overview

This Dart package uses the
[Open Z-Wave library](https://github.com/OpenZWave/open-zwave/)
to communicate with a compatible Z-Wave Controller
and interact with Z-Wave devices.

## Usage

This package provides 
* a [command line application](bin/zw.dart) for querying and updating Z-Wave devices
* a [library of Dart classes](lib/zwave.dart) for building your own Z-Wave based service

See the **zwave library** for more about how to interact with Z-Wave devices.

## Requirements

* A Z-Wave Controller such as the
  [Aeon Labs Aeotec Z-Wave Z-Stick, Gen5 (ZW090)](http://aeotec.com/z-wave-usb-stick).

* The [Open Z-Wave library](https://github.com/OpenZWave/open-zwave/) used by
  this Dart library to communicate with the Z-Wave controller.
  Tested with Open Z-Wave Library 1.4.256

## Setup

Pair your Z-Wave controller with your Z-Wave devices, then [install the
Open Z-Wave library](https://github.com/OpenZWave/open-zwave/blob/master/INSTALL).
Use the MinOZW example that is included in the Open Z-Wave library to ensure
that the Open Z-Wave library is installed correctly and can communicate with
your devices using your Z-Wave Controller.

Activate this zwave package using the
[pub global](https://www.dartlang.org/tools/pub/cmd/pub-global.html) command.
```
    pub global activate zwave
```

From your application directory (the application that references
the zwave package) run the following command to build the native library
```
    pub global run zwave:build_lib
```

[pub global activate](https://www.dartlang.org/tools/pub/cmd/pub-global.html#activating-a-package)
makes the Dart scripts in the zwave/bin directory runnable
from the command line.
[pub global run](https://www.dartlang.org/tools/pub/cmd/pub-global.html#running-a-script)
zwave:build_lib runs the [zwave/bin/build_lib.dart](bin/build_lib.dart)
program which in turn calls the [build_lib](lib/src/native/build_lib) script
to compile the native libozw_ext.so library for the zwave package.

Finally, run the included [command line application](bin/zw.dart) to ensure that this package
is installed correctly and can communicate with your devices using your Z-Wave Controller.