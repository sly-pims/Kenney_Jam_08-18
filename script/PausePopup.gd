extends Popup

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
#	if event.type == InputEventKey and event.scancode == KEY_ESCAPE:
	if event.is_pressed() and event.scancode == KEY_ESCAPE:
		get_tree().paused = true
		get_parent().get_node("MainGameMusic").stop()
		get_parent().get_node("pause_popup/PauseMusic").play()
		get_parent().get_node("pause_popup/WindowDialog").show()
	if event.is_pressed() and event.scancode == KEY_ENTER or event.is_pressed() and event.scancode == KEY_KP_ENTER:
		get_tree().paused = false
		get_parent().get_node("MainGameMusic").play()
		get_parent().get_node("pause_popup/PauseMusic").stop()
		get_parent().get_node("pause_popup/WindowDialog").hide()
	if event.is_pressed() and event.scancode ==  KEY_SPACE:
		get_tree().change_scene("res://scene/MainMenu2.tscn")
		get_tree().reload_current_scene()

