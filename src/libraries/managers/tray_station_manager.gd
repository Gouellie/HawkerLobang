extends Reference

class_name TrayStationManager

var _stations = []


func _init() -> void:
	Global.tray_station_manager = self


func register_station(station : TrayStation) -> void:
	if not _stations.has(station):
		_stations.push_back(station)


func remove_station(station) -> void:
	_stations.erase(station)


func get_nearest_station(position : Vector2) -> TrayStation:
	var closest_station = null
	var closest_distance = 999999.0
	for station in _stations:
		var station_pos = station.global_position
		var distance = position.distance_to(station_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_station = station
	return closest_station
