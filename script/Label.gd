extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass	

func _process(delta):
	self.clear()
	self.add_text(String(get_parent().lifeTime))
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass