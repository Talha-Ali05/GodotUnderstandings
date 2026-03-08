extends Node2D

var config = ConfigFile.new()
func _on_save_pressed() -> void:
	#JSON
	var player_data = {
		"x" : $CharacterBody2D.position.x,
		"y" : $CharacterBody2D.position.y
		
	}
	var json_data = JSON.stringify(player_data)
	var json_file = FileAccess.open("res://save.json",FileAccess.WRITE) #to open file in write mode
	json_file.store_line(json_data) #to store data
	json_file.close() # to close the file (try to close after saving or retriving)
	
	
	#config file
	#saving position
	config.set_value("player","x",$CharacterBody2D.position.x) #sets section, key, value 
	config.set_value("player","y",$CharacterBody2D.position.y)
	config.save("res://save.cfg")


func _on_load_pressed() -> void:
	var json_file = FileAccess.open("res://save.json",FileAccess.READ) #to open file in read mode
	var json_string = json_file.get_as_text() # to get the data if form of string
	json_file.close()
	
	var player_data = JSON.parse_string(json_string) # to convert string into dictionary
	$CharacterBody2D.position.x =  player_data.x
	$CharacterBody2D.position.y =  player_data.y
	
	#config File
	var err = config.load("res://save.cfg") # to load the file err means to see if isn't corrupt then retrive data
	if err == OK:
		$CharacterBody2D.position.x =  config.get_value("player","x")
		$CharacterBody2D.position.y =  config.get_value("player","y")
