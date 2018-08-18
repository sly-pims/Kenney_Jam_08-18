extends Object

var delta
var playerFrames

func _init(delta, playerFrames):
	self.delta = delta
	self.playerFrames = playerFrames

func getDelta():
	return self.delta
	
func getPlayerFrames():
	return playerFrames

func getPlayerFrame(index):
	return playerFrames[index]