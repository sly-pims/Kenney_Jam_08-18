extends Node

# How many frames to rewind by
const rewindTime = 60 * 3
const rewindSpeed = 3

var Frame = load('res://script/frame.gd')

var isRewinding = false
var rewindFramesLeft = 0
var frames = []

onready var player1 = get_node("../player")

func _process(delta):
	if rewindFramesLeft <= 0 && !isRewinding:
		var playerInfo1 = Frame.new(
		 delta,
		 player1.position,
		 player1.linear_vel,
		 player1.lifeTime,
		 player1.anim,
		 player1.sprite.scale.x)
		frames.push_front(playerInfo1)
	elif rewindFramesLeft > 0 && isRewinding:
		# Get previous frame
		var previousFrame = frames.pop_front()
		# Check if there is no more frames to rewind by
		if !previousFrame:
			rewindFramesLeft = 0
			return
		# Set old position to the player
		player1.position = previousFrame.getPosition()
		player1.lifeTime = previousFrame.getLifeTime()
		
		player1.sprite.scale.x = previousFrame.getScaleX()
		# Decrement the rewind frames
		rewindFramesLeft -= rewindSpeed
		# Scrub frames
		var elapsedDelta = previousFrame.getDelta() + popFramesAndGetDelta(rewindSpeed - 1)
		
		player1.loadAndPlayAnim(previousFrame.getAnim(), elapsedDelta, true)
		
		if rewindFramesLeft <= 0:
			player1.linear_vel = previousFrame.getVelocity()
	else:
		player1.stopAnim()

func popFramesAndGetDelta(count):
	var totalDelta = 0
	for i in range(count):
		var frame = frames.pop_front()
		totalDelta += frames.getDelta()
	return totalDelta

func rewindTime():
	isRewinding = true
	rewindFramesLeft = rewindTime
	player1.isRewinding = true
	
func resumeTime():
	isRewinding = false
	player1.isRewinding = false

func _input(event):
	if event is InputEventKey and event.scancode == KEY_K and not event.echo:
		rewindTime()
	if event is InputEventKey and event.scancode == KEY_L and not event.echo:
		resumeTime()
	