## Overview 

`Micromod` is a (Java only) music player for MOD, S3M, and XM files. It wraps the excellent [Micromod](https://sites.google.com/site/mumart/home/micromodibxm) by Martin Cameron.

## Install 

Install `Micromod` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afMicromod

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afMicromod 1.0"]

## Documentation 

Full API & fandocs are available on the [Status302 repository](http://repo.status302.com/doc/afMicromod/).

## Quick Start 

1). Create a text file called `Example.fan`, making sure the file `MyTune.mod` exists.

```
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
```

2). Run `Example.fan` as a Fantom script from the command line:

```
C:\> fan Example.fan

[afMicromod] Playing `file:/.../MyTune.mod`
[afMicromod] Stopping `file:/.../MyTune.mod`
```

