#!/bin/bash

# https://github.com/microsoft/entra-verifiedid-wallet-library-ios

killall Xcode
killall Simulator
rm -rf Workspace.xcworkspace
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm Podfile.lock
rm -rf Pods
pod cache clean --all

pod install

open Workspace.xcworkspace
