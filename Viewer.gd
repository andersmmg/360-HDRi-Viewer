extends Spatial

func _ready():
	var _t = get_tree().connect("files_dropped", self, "_on_files_dropped")

func _on_files_dropped(files, _screen):
	var path = files[0]
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		pass
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	$Control/Label.text = path
	$WorldEnvironment.environment.background_sky.panorama = texture
	$TrackballCamera.reset_rotation()
