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
	if rewindFramesLeft <= 0:
		var playerInfo1 = Frame.new(player1.position, player1.linear_vel, player1.lifeTime)
		frames.push_front(playerInfo1)
	else:
		# Get previous frame
		var previousFrame = frames.pop_front()
		# Check if there is no more frames to rewind by
		if !previousFrame:
			rewindFramesLeft = 0
			return
		# Set old position to the player
		player1.position = previousFrame.getPosition()
		player1.lifeTime = previousFrame.getLifeTime()
		# Decrement the rewind frames
		rewindFramesLeft -= rewindSpeed
		# Scrub frames
		popFrames(rewindSpeed - 1)
		if rewindFramesLeft <= 0:
			player1.linear_vel = previousFrame.getVelocity()

func popFrames(count):
	for i in range(count):
		frames.pop_front()

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
	