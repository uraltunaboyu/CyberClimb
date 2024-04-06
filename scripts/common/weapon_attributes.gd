class_name WeaponAttributes extends Node

const PISTOL_NAME = "pistol"
const ASSAULT_RIFLE_NAME = "assault rifle"
const BURST_GUN_NAME = "burst rifle"
const SHOTGUN_NAME = "shotgun"

enum Name {
	NONE,
	PISTOL,
	ASSAULT_RIFLE,
	BURST_RIFLE,
	SHOTGUN,
}

const BY_NAME = {
	PISTOL_NAME : Name.PISTOL,
	ASSAULT_RIFLE_NAME : Name.ASSAULT_RIFLE,
	BURST_GUN_NAME : Name.BURST_RIFLE,
	SHOTGUN_NAME : Name.SHOTGUN,
}

const TO_NAME = {
	Name.PISTOL : PISTOL_NAME,
	Name.ASSAULT_RIFLE : ASSAULT_RIFLE_NAME,
	Name.BURST_RIFLE : BURST_GUN_NAME,
	Name.SHOTGUN : SHOTGUN_NAME,
}

const SCENE = {
	Name.PISTOL : "res://scenes/weapons/pistol.tscn",
	Name.ASSAULT_RIFLE : "res://scenes/weapons/assault_rifle.tscn",
	Name.BURST_RIFLE : "res://scenes/weapons/burst_assault_rifle.tscn",
	Name.SHOTGUN : "res://scenes/weapons/shotgun.tscn",
}

const COST = {
	Name.PISTOL: 0,
	Name.ASSAULT_RIFLE: 100,
	Name.BURST_RIFLE: 100, 
	Name.SHOTGUN: 25,
}
