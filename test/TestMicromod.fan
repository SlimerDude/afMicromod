using concurrent

class TestMicromod : Test {
	
	Void testPlayer() {
		modPlayer := MicromodPlayer(`fan://${typeof.pod}/res/music/Slammer-WumpingMoshchops.mod`)
		echo("playing")
		modPlayer.play(MicromodChannels.stereo)
		
		Actor.sleep(22sec)

		modPlayer.stop
		echo("stopped")
	}
	
}
