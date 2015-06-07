#Micromod v1.0.4
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v1.0.4](http://img.shields.io/badge/pod-v1.0.4-yellow.svg)](http://www.fantomfactory.org/pods/afMicromod)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

Micromod is a (Java only) music player for MOD, S3M, and XM files. It wraps the excellent [Micromod](https://sites.google.com/site/mumart/home/micromodibxm) by Martin Cameron.

## Install

Install `Micromod` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afMicromod

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afMicromod 1.0"]

## Documentation

Full API & fandocs are available on the [Fantom Pod Repository](http://pods.fantomfactory.org/pods/afMicromod/).

## Quick Start

1. Create a text file called `Example.fan`, making sure the file `MyTune.mod` exists:

        using concurrent
        using afMicromod
        
        class Example {
        
            Void main() {
                player := Micromod(ActorPool(), File(`MyTune.mod`))
                player.play(Channels.stereo)
        
                Actor.sleep(22sec)
        
                player.stop
            }
        }


2. Run `Example.fan` as a Fantom script from the command line:

        C:\> fan Example.fan
        
        [afMicromod] Playing `file:/.../MyTune.mod`
        [afMicromod] Stopping `file:/.../MyTune.mod`



## .mod Files?

[.MOD files](http://en.wikipedia.org/wiki/MOD_%28file_format%29) are music files created by [Music Tracker Software](http://en.wikipedia.org/wiki/Music_tracker) such as [OctoMED](http://en.wikipedia.org/wiki/OctaMED). They were prominent in the Amiga DemoScene. See the [Equninox Slammer page](http://www.alienfactory.co.uk/equinox/slammer) for some example `.mod` files.

