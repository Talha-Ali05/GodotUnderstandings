extends Node

enum Guns {PISTOL,LAUNCHER}

var guns_data = {
	Guns.PISTOL:ResourceLoader.load("res://Gun/gun_data/Pistol.tres") as Gun,
	Guns.LAUNCHER:ResourceLoader.load("res://Gun/gun_data/gernade launcher.tres") as Gun,
}
