using [java] javax.sound.sampled
using [java] fanx.interop
using [java] ibxm
using concurrent::ActorPool
using afConcurrent

internal const class PlayThread {
	private static const Log 	log 		:= Micromod#.pod.log
	private static const Int 	SAMPLE_RATE := 48000
	
	private const LocalMap		stash		:= LocalMap("Micromod")
	private const Synchronized	lock

	private Bool playing {
		get { stash.get("playing", false) }
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
	
	new make(ActorPool actorPool) {
		this.lock = Synchronized(actorPool)
	} 
	
	Void play(File modFile, Channels channels) {
		lock.async |->| {
			sampleRate	:= SAMPLE_RATE 
			modBuf		:= modFile.readAllBuf
			moduleData	:= ByteArray.make(modBuf.size)
			Interop.toJava(modBuf.in).read(moduleData)

			module := Module( moduleData )
			ibxm = IBXM( module, SAMPLE_RATE )
			ibxm.setInterpolation( Channel.LINEAR )
			
			mixBuf = IntArray.make( ibxm.getMixBufferLength )
			outBuf = ByteArray.make( mixBuf.size * 4 )

			noOfChannels := 2
			if (channels == Channels.mono) {
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
		lock.async |->| {
			playing = false
			tidyUp
		}
	}
	
	private Void playLoop() {
		lock.async |->| {
			if (!playing) {
				tidyUp
				return
			}
			
			try {
				count  := ibxm.getAudio( mixBuf )
				mixEnd := count * 2
				outIdx := 0
				for( Int mixIdx := 0; mixIdx < mixEnd; mixIdx++ ) {
					ampl := mixBuf[ mixIdx ]
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
		stash.clear
	}
}