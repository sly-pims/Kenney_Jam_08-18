extends Object

var position
var velocity
func _init(position, velocity):
	self.position = position
	self.velocity = velocity
func getPosition():
	return self.position
func getVelocity():
	return self.velocity