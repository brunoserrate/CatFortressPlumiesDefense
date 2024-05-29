# EnemySpawnSetTemplate.gd
extends Resource
class_name EnemySpawnSetTemplate

# Caminho para o arquivo JSON
export(String) var json_file_path = ""
var level_enemy_spawn_set = []

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

		print("Carregando inimigos do arquivo: ", json_data)

		for spawn_set in json_data:
			var enemies_to_spawn = []

			for enemy in spawn_set["enemies_to_spawn"]:
				enemies_to_spawn.append(load(enemy))

			var spawn_set_info = {
				"enemies_to_spawn": enemies_to_spawn,
				"time_to_begin": spawn_set["time_to_begin"],
				"change_spawn_time": spawn_set["change_spawn_time"],
				"changed_spawn_time": spawn_set["changed_spawn_time"]
			}

			level_enemy_spawn_set.append(spawn_set_info)
	else:
		print("Arquivo JSON não encontrado: ", json_file_path)
