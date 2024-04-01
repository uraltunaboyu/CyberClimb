class_name WeaponAttributes extends Node

enum Name {
	NONE,
	PISTOL,
	ASSAULT_RIFLE,
	BURST_RIFLE,
	SHOTGUN,
}

const BY_NAME = {
	"pistol" : Name.PISTOL,
	"assault rifle" : Name.ASSAULT_RIFLE,
	"burst rifle" : Name.BURST_RIFLE,
	"shotgun" : Name.SHOTGUN,
}

const SCENE = {
	Name.PISTOL : "res://scenes/Pistol.tscn",
	Name.ASSAULT_RIFLE : "res://scenes/AssaultRifle.tscn",
	Name.BURST_RIFLE : "res://scenes/BurstAssaultRifle.tscn",
	Name.SHOTGUN : "res://scenes/Shotgun.tscn",
}

const COST = {
	Name.PISTOL: 0,
	Name.ASSAULT_RIFLE: 100,
	Name.BURST_RIFLE: 100, 
	Name.SHOTGUN: 25,
}
