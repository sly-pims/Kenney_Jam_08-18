extends Node

# How many frames to rewind by
const rewindTime = 60 * 5
const rewindSpeed = 2

var Frame = load('res://script/frame.gd')
var PlayerFrame = load('res://script/playerFrame.gd')

var isRewinding = false
var rewindFramesLeft = 0
var frames = []

onready var player0 = get_node("../player0")
onready var player1 = get_node("../player1")
onready var player2 = get_node("../player2")
onready var player3 = get_node("../player3")

onready var players = [player0, player1, player2, player3]

onready var timer = get_node('timer')

var playerCount = 4

onready var vhsShader = get_node('../Camera2D/vhsShader')

func _process(delta):
	if rewindFramesLeft <= 0 && !isRewinding:
		var playerFrames = []
		for i in range(playerCount):
			playerFrames.push_back(getPlayerInfo(i))
		
		var currentFrame = Frame.new(delta, playerFrames)
		
		frames.push_front(currentFrame)
		
	elif rewindFramesLeft > 0 && isRewinding:
		# Scrub frames
		var elapsedDelta = popFramesAndGetDelta(rewindSpeed - 1)
		
		# Get previous frame
		var previousFrame = frames.pop_front()
		
		# Check if there is no more frames to rewind by
		if !previousFrame:
			rewindFramesLeft = 0
			return
		
		# Update the delta
		elapsedDelta += previousFrame.getDelta()
		
		# Check if there is no more frames to rewind by
		if !previousFrame:
			rewindFramesLeft = 0
			return

		# Reset the players position, lifetime and velocity
		for i in range(playerCount):
			var previousPlayerFrame = previousFrame.getPlayerFrame(i)
			if previousPlayerFrame:
				setPlayerInfo(i, previousPlayerFrame, elapsedDelta)
		
		# Decrement the rewind frames
		rewindFramesLeft -= rewindSpeed
		
		if rewindFramesLeft <= 0:
			for i in range(playerCount):
				var previousPlayerFrame = previousFrame.getPlayerFrame(i)
				if previousPlayerFrame:
					setPlayerVelocity(i, previousFrame.getPlayerFrame(i))
	else:
		stopPlayerAnim()

func getPlayerInfo(playerIndex):
	if isPlayerInstanceValid(players[playerIndex]):
		return PlayerFrame.new(
			players[playerIndex].position,
			players[playerIndex].linear_vel,
			players[playerIndex].lifeTime,
			players[playerIndex].anim,
			players[playerIndex].sprite.scale.x)
	else:
		return null

func setPlayerInfo(playerIndex, playerFrame, elapsedDelta):
	# Set old position to the player
	players[playerIndex].position = playerFrame.getPosition()
	players[playerIndex].lifeTime = playerFrame.getLifeTime()
	players[playerIndex].sprite.scale.x = playerFrame.getScaleX()
	
	players[playerIndex].loadAndPlayAnim(playerFrame.getAnim(), elapsedDelta)

func setPlayerVelocity(playerIndex, playerFrame):
	players[playerIndex].linear_vel = playerFrame.getVelocity()

func popFramesAndGetDelta(count):
	var totalDelta = 0
	for i in range(count):
		var frame = frames.pop_front()
		if !frame:
			return totalDelta
		totalDelta += frame.getDelta()
	return totalDelta

func setPlayersRewinding(isRewinding):
	for i in range(playerCount):
		if isPlayerInstanceValid(players[i]):
			players[i].isRewinding = isRewinding

func stopPlayerAnim():
	for i in range(playerCount):
		if isPlayerInstanceValid(players[i]):
			players[i].stopAnim()
		
func rewindTime():
	setPlayersRewinding(true)
	vhsShader.visible = true
	timer.start()

func _rewindTime():
	isRewinding = true
	rewindFramesLeft = rewindTime
	timer.stop()

func resumeTime():
	isRewinding = false
	vhsShader.visible = false
	setPlayersRewinding(false)

func _input(event):
	if event is InputEventKey and event.scancode == KEY_K and not event.echo:
		rewindTime()
	if event is InputEventKey and event.scancode == KEY_L and not event.echo:
		resumeTime()
		
func isPlayerInstanceValid(player):
	var wr = weakref(player)
#	return wr.get_ref()
	if wr.get_ref():
		return player.is_class('KinematicBody2D')
	else:
		return false
	
