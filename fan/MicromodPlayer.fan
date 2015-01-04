using [java] javax.sound.sampled
using [java] fanx.interop
using [java] ibxm
using concurrent

**
** A Java only wrapper around [Micromod]`http://code.google.com/p/micromod/`. Sample usage:
** 
** 	   modPlayer := MicromodPlayer(`fan://afMicromod/res/music/Slammer-WumpingMoshchops.mod`)
**     modPlayer.play(MicromodChannels.stereo)
**     Actor.sleep(30sec)
**     modPlayer.stop
** 
class MicromodPlayer {
	private static const Log log := Log.get("MicroModPlayer")
	
			const Uri modUri
	private const PlayThread playThread
	
	new make(Uri modUri) {
		this.modUri = modUri
		this.playThread = PlayThread()
	}
	
	Void play(MicromodChannels channels) {
		log.info("Playing \`$modUri\`")
		playThread.play(modUri.get, channels)
	}
	
	Void stop() {
		log.info("Stopping \`$modUri\`")
		playThread.stop
	}
}

**
** Defines whether playback is Stereo or Mono.
** 
enum class MicromodChannels {
	mono,
	stereo
}

internal const class PlayThread : AfActor {
	private static const Log log := Log.get("MicroModPlayer")
	private static const Int SAMPLE_RATE := 48000
	
	new make() : super(ActorPool(), "MicroModPlayer") { } 
	
	Future play(File modFile, MicromodChannels channels) {
		send |->| {
			sampleRate := SAMPLE_RATE 
			moduleData := ByteArray.make(modFile.size)
			Interop.toJava(modFile.in).read(moduleData)
			
			module := Module( moduleData )
			ibxm = IBXM( module, SAMPLE_RATE )
			ibxm.setInterpolation( Channel.LINEAR )
			
			mixBuf = IntArray.make( ibxm.getMixBufferLength )
			outBuf = ByteArray.make( mixBuf.size * 4 )

			Int noOfChannels := 2
			if (channels == MicromodChannels.mono) {
				noOfChannels = 1
				sampleRate *= 2
			}
			
			audioFormat := AudioFormat( sampleRate.toFloat, 16, noOfChannels, true, true )
			audioLine = AudioSystem.getSourceDataLine( audioFormat )
			
			audioLine.open
			audioLine.start
			playing = true
		
			playLoop
		}
	}

	Void stop() {
		send |->| {
			playing = false
			tidyUp
		}
	}
	
	private Void playLoop() {
		send |->| {
			if (!playing) {
				tidyUp
				return
			}
			
			try {
				Int count := ibxm.getAudio( mixBuf )
				Int mixEnd := count * 2
				Int outIdx := 0
				for( Int mixIdx := 0; mixIdx < mixEnd; mixIdx++ ) {
					Int ampl := mixBuf[ mixIdx ]
					if ( ampl >  32767 ) ampl =  32767
					if ( ampl < -32768 ) ampl = -32768
					outBuf[ outIdx++ ] = ampl.shiftr(8)
					outBuf[ outIdx++ ] = ampl
				}
	
				audioLine.write( outBuf, 0, outIdx )
				
				playLoop
			
			} catch (Err e) {
				log.err("Could not play Mod", e)
				tidyUp
			}
		}
	}

	private Void tidyUp() {
		if (audioLine != null && audioLine.isOpen) {
			audioLine.drain
			audioLine.close
		}
		audioLine = null
		ibxm = null
		mixBuf = null
		outBuf = null
		playing = false
	}
	
	// ---- Actor Local Getters and Setters -------------------------------------------------------
	
	private Bool playing {
		get { stash.get("playing") |->Bool| { false } }
		set { stash.set("playing", it) }
	}

	private IBXM? ibxm {
		get { stash.get("ibxm") }
		set { stash.set("ibxm", it) }
	}

	private SourceDataLine? audioLine {
		get { stash.get("audioLine") }
		set { stash.set("audioLine", it) }
	}

	private IntArray? mixBuf {
		get { stash.get("mixBuf") }
		set { stash.set("mixBuf", it) }
	}

	private ByteArray? outBuf {
		get { stash.get("outBuf") }
		set { stash.set("outBuf", it) }
	}
}
