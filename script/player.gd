extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2
const BEIGE_FRAMES = preload('res://asset/sprite/alienBeige.sprites/spriteFrames.tres')
const BLUE_FRAMES = preload('res://asset/sprite/alienBlue.sprites/spriteFrames.tres')
const GREEN_FRAMES = preload('res://asset/sprite/alienGreen.sprites/spriteFrames.tres')
const PINK_FRAMES = preload('res://asset/sprite/alienPink.sprites/spriteFrames.tres')
const FRAMES = [BEIGE_FRAMES, BLUE_FRAMES, GREEN_FRAMES, PINK_FRAMES]

onready var SPRITE_SCALE = $sprite.scale.x
onready var TimeController = get_node('../timeController')
var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time=99999 #time since last shot
var lifeTime = 30
var playerIndex = 0
var isRewinding = false
var lives = 3

var anim=""

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $sprite

func _ready():
	playerIndex = self.name[self.name.length() - 1]
	$sprite.set_sprite_frames(FRAMES[int(playerIndex)])
	var controllerConnected = false
	for i in Input.get_connected_joypads():
		if i == int(playerIndex):
			controllerConnected = true
			break
	if !controllerConnected:
		queue_free()
	
func _physics_process(delta):
	if isRewinding:
		if Input.is_action_just_pressed("shoot" + playerIndex) && TimeController.isReadyToResume:
			TimeController.resumeTime()
		return
	#increment counters
	lifeTime -= delta
	if lifeTime < 0:
		lifeTime = 0
	onair_time += delta
	shoot_time += delta

	if lifeTime <= 0:
		lives -= 1
		loadAndPlayAnim("death")
		if lives > 0:
			TimeController.rewindTime()
			return

	### MOVEMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	if lives <= 0:
		return
	# Move and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	### CONTROL ###

	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("move_left" + playerIndex):
		target_speed += -1
	if Input.is_action_pressed("move_right" + playerIndex):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and Input.is_action_just_pressed("jump" + playerIndex):
		linear_vel.y = -JUMP_SPEED
		$sound_jump.play()

	# Shooting
	if Input.is_action_just_pressed("shoot" + playerIndex) && !TimeController.isPaused:
		var bullet = preload("res://scene/bullet.tscn").instance()
		bullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		bullet.playerOwner = self
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		$sound_shoot.play()
		shoot_time = 0
		lifeTime -= 1

	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -SPRITE_SCALE
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = SPRITE_SCALE
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("move_left" + playerIndex) and not Input.is_action_pressed("move_right" + playerIndex):
			sprite.scale.x = -SPRITE_SCALE
		if Input.is_action_pressed("move_right" + playerIndex) and not Input.is_action_pressed("move_left" + playerIndex):
			sprite.scale.x = SPRITE_SCALE

		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"

	if shoot_time < SHOOT_TIME_SHOW_WEAPON:
		new_anim += "_weapon"

	loadAndPlayAnim(new_anim)

func loadAndPlayAnim(new_anim, delta = null):
	if anim == new_anim:
		return
	
	anim = new_anim
	
	$anim.play(anim)
	# Advance frames
	if delta:
		$anim.advance(delta)
	
func stopAnim():
	$anim.stop(false)

func hitByBullet():
	lifeTime -= 5
	if(lifeTime < 0):
		lifeTime = 0