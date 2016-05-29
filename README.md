# zwave.dart

zwave is a Dart library for interacting with Z-Wave devices.

## Overview

This Dart library uses the
[Open Z-Wave library](https://github.com/OpenZWave/open-zwave/)
to communicate with a compatible Z-Wave Controller
and interact with Z-Wave devices.

## Requirements

* A Z-Wave Controller such as the
  [Aeon Labs Aeotec Z-Wave Z-Stick, Gen5 (ZW090)](https://www.google.com/webhp?ion=1&espv=2&ie=UTF-8#q=Aeon+Labs+Aeotec+Z-Wave+Z-Stick,+Gen5+(ZW090)&tbm=shop).

* The [Open Z-Wave library](https://github.com/OpenZWave/open-zwave/) used by
  this Dart library to communicate with the Z-Wave controller.

## Setup

Pair your Z-Wave controller with your Z-Wave devices, then [install the
Open Z-Wave library](https://github.com/OpenZWave/open-zwave/blob/master/INSTALL).
Use the MinOZW example that is included in the Open Z-Wave library to ensure
that the Open Z-Wave library is installed correctly and can communicate with
your devices using your Z-Wave Controller.
