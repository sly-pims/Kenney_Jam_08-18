extends Label

func _process(delta):
	self.set_text(String(stepify(get_parent().lifeTime, 0.01)))