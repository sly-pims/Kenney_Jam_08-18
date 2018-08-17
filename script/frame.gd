extends Object

var position
var velocity
var lifeTime
func _init(position, velocity, lifeTime):
	self.position = position
	self.velocity = velocity
	self.lifeTime = lifeTime
func getPosition():
	return self.position
func getVelocity():
	return self.velocity
func getLifeTime():
	return self.lifeTime