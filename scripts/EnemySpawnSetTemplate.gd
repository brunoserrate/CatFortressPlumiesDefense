# EnemySpawnSetTemplate.gd
extends Resource
class_name EnemySpawnSetTemplate

# Caminho para o arquivo JSON
export(String) var json_file_path = ""
var enemy_spawn_set = []

func _init():
	if json_file_path != "":
		load_enemy_spawn_set()

func load_enemy_spawn_set():
	var file = File.new()
	if file.file_exists(json_file_path):
		file.open(json_file_path, File.READ)
		var json_text = file.get_as_text()
		file.close()

		var json_result = JSON.parse(json_text)
		if json_result.error != OK:
			print("Erro ao parsear JSON: ", json_result.error_string)
			return

		var json_data = json_result.result
		for enemy_info in json_data:
			var enemies_to_spawn = []
			for enemy in enemy_info["enemies_to_spawn"]:
				enemies_to_spawn.append(load(enemy))

			var enemy_spawn_info = {
				"enemies_to_spawn": enemies_to_spawn,
				"time_to_begin": enemy_info["time_to_begin"],
				"change_spawn_time": enemy_info["change_spawn_time"],
				"changed_spawn_time": enemy_info["changed_spawn_time"]
			}
			enemy_spawn_set.append(enemy_spawn_info)
	else:
		print("Arquivo JSON não encontrado: ", json_file_path)
