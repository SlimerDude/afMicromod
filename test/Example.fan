using concurrent

class Example {
	
	Void main() {
		player := MicromodPlayer(ActorPool(), File(`res/Slammer-WumpingMoshchops.mod`))
		player.play(Channels.stereo)
		
		Actor.sleep(22sec)

		player.stop
	}	
}
