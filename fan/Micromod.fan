using concurrent

** A music player for MOD, S3M, and XM files; see [Micromod]`https://sites.google.com/site/mumart/home/micromodibxm`.
**  
** Sample usage:
** 
**   syntax: fantom
** 
** 	 player := Micromod(ActorPool(), File(`MyTune.mod`))
**   player.play(Channels.stereo)
**   Actor.sleep(30sec)
**   player.stop
** 
const class Micromod {
	private static const Log log := Micromod#.pod.log	
	private const PlayThread	playThread
	
	** The music file this player, err, plays. 
			const File 			modFile

	** Creates a 'MicromodPlayer' for the given music file.
	new make(ActorPool actorPool, File modFile) {
		if (!modFile.exists)
			throw IOErr("File not found: ${modFile.normalize}")
		this.playThread = PlayThread(actorPool)
		this.modFile	= modFile.normalize
	}
	
	** Plays the music file.
	Void play(Channels channels := Channels.stereo) {
		log.info("Playing \`$modFile\`")
		playThread.play(modFile, channels)
	}
	
	** Stops the music.
	Void stop() {
		log.info("Stopping \`$modFile\`")
		playThread.stop
	}
}

