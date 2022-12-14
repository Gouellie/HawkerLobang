extends Node

# warning-ignore:unused_class_variable
var STALLS = {
	"Carrot Cake" : preload("res://resources/stalls/stall_carrot_cake.tres"),
	"Chicken Rice" : preload("res://resources/stalls/stall_chicken_rice.tres"),
	"Nasi Lemak" : preload("res://resources/stalls/stall_nasi_lemak.tres"),
	"Roti Prata" : preload("res://resources/stalls/stall_roti_prata.tres"),
}

var ENTITIES = {
	"stall" : preload("res://src/entities/stalls/stall.tscn"),
	"table_2pax" : preload("res://src/entities/props/tables/table_2pax.tscn"),
	"table_4pax" : preload("res://src/entities/props/tables/table_4pax.tscn"),
	"table_8pax" : preload("res://src/entities/props/tables/table_8pax.tscn"),
	"tray_station_large" : preload("res://src/entities/props/tray_stations/tray_station_large.tscn"),
}
