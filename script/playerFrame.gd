extends Object

var position
var velocity
var lifeTime
var anim
var scaleX

func _init(position, velocity, lifeTime, anim, scaleX):
	self.position = position
	self.velocity = velocity
	self.lifeTime = lifeTime
	self.anim = anim
	self.scaleX = scaleX
func getPosition():
	return self.position
func getVelocity():
	return self.velocity
func getLifeTime():
	return self.lifeTime
func getAnim():
	return self.anim
func getScaleX():
	return self.scaleX