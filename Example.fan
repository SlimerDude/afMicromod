using concurrent
using afMicromod

class Example {
	
	Void main() {
		player := Micromod(ActorPool(), File(`res/Slammer-WumpingMoshchops.mod`))
		player.play(Channels.stereo)
		
		Actor.sleep(22sec)

		player.stop
	}	
}
