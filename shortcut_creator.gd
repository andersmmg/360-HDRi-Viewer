extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !OS.is_debug_build() and OS.get_name() == "X11":
		print(Engine.is_editor_hint())
		create_shortcut()
#		get_tree().quit()

func create_shortcut() -> void:
	# Get username
	var output := []
	var _error = OS.execute("whoami", [], output, true, false)
	var username: String = output[0].substr(0, output[0].length() - 1) # Trim junk
	
	# Get other useful data.
	var project_name: String = ProjectSettings.get_setting("application/config/name")
	var description: String = ProjectSettings.get_setting("application/config/description")
	
	# Prepare paths.
	var user_folder_path := "/home/" + username + "/.local/share/godot/app_userdata/" + project_name + "/"
	var desktop_file_path := user_folder_path + project_name + ".desktop"
	var exec_path := OS.get_executable_path()
	
	# Save game icon to storage.
	var icon: Texture2D = load("res://icon.png")
	var icon_data := icon.get_image()
	_error = icon_data.save_png("user://shortcut.png")
	
	# Write out file with all the necessary info.
	var file := FileAccess.open(desktop_file_path, FileAccess.WRITE)
	#_error = file.open(desktop_file_path, File.WRITE)
	file.store_string("[Desktop Entry]\n")
	file.store_string("Encoding=UTF-8\n")
	file.store_string("Name=" + project_name + "\n")
	file.store_string("Comment=" + description + "\n")
	file.store_string("Exec=\"" + exec_path + "\"\n")
	file.store_string("Icon=" + user_folder_path + "shortcut.png\n")
	file.store_string("Terminal=false\n")
	file.store_string("Type=Application\n")
	file.store_string("Categories=Game;")
	file.close()
	
	# Copies the desktop file to the right places and allows it to be registered.
	_error = OS.execute("cp", [desktop_file_path, "/home/" + username + "/.local/share/applications"], output, true)
	_error = OS.execute("cp", [desktop_file_path, "/usr/share/applications"], output, true)
	
	_error = OS.execute("chmod", ["+x", desktop_file_path], output, true)
