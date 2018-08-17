extends Object

var position
var velocity
var lifeTime
var anim
var scaleX
var delta

func _init(delta, position, velocity, lifeTime, anim, scaleX):
	self.delta = delta
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
func getDelta():
	return self.delta