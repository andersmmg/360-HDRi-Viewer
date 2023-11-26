extends Node3D

func _ready():
	get_tree().get_root().files_dropped.connect(_on_files_dropped)

func _on_files_dropped(files):
	var path = files[0]
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		pass
	var texture = ImageTexture.create_from_image(image)
	$Control/Label.text = path
	$WorldEnvironment.environment.sky.sky_material.panorama = texture
	$TrackballCamera.reset_rotation()
