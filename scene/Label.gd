extends Label

func _process(delta):
	self.set_text("%.2f" % stepify(get_parent().lifeTime, 0.01))