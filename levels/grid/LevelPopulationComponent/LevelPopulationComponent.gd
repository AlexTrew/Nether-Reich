extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#########################
#
# here are the scenarios for rooms
#
# road2 scenarios
#
#
##########################
var road2_difficulty_1_variation_1 = [["villager", "2"], ["swordsman", "1"], ["villager", "2"]]
var road2_difficulty_1_variation_2 = [["villager", "2"], ["headyhandballer", "1"], ["headyhandballer", "1"]]
var road2_difficulty_1_variation_3 = [["swordsman", "1"],["headyhandballer", "1"], ["headyhandballer", "1"]]
var road2_difficulty_1_variation_4 = [["villager", "2"],["hellkite", "1"], ["villager", "2"]]
var road2_difficulty_1_variation_5 = [["rifleman", "2"],["rifleman", "1"], ["villager", "2"]]

var road2_difficulty_3_variation_1 = [["villager", "5"], ["swordsman", "4"], ["villager", "5"], ["villager", "5"], ["swordsman", "4"], ["villager", "5"], ["hellkite", "1"], ["rifleman", "5"]]
var road2_difficulty_3_variation_2 = [["villager", "5"], ["headyhandballer", "4"], ["headyhandballer", "2"], ["villager", "5"], ["swordsman", "4"], ["villager", "5"], ["hellkite", "1"], ["villager", "10"]]
var road2_difficulty_3_variation_3 = [["swordsman", "5"],["headyhandballer", "2"], ["headyhandballer", "2"], ["rifleman", "5"],["rifleman", "1"], ["villager", "10"], ["headyhandballer", "2"], ["rifleman", "5"]]
var road2_difficulty_3_variation_4 = [["villager", "5"],["hellkite", "1"], ["villager", "5"], ["villager", "5"],["hellkite", "1"], ["villager", "5"], ["headyhandballer", "2"], ["villager", "5"], ["swordsman", "4"]]
var road2_difficulty_3_variation_5 = [["rifleman", "5"],["rifleman", "1"], ["villager", "10"], ["villager", "5"], ["swordsman", "4"], ["villager", "5"], ["villager", "10"], ["headyhandballer", "2"], ["rifleman", "5"]]

var road2_difficulty_4_variation_1 = [["villager", "10"], ["hellkite", "1"], ["villager", "10"]]
var road2_difficulty_4_variation_2 = [["villager", "10"], ["hellkite", "1"], ["headyhandballer", "6"]]
var road2_difficulty_4_variation_3 = [["swordsman", "5"],["headyhandballer", "2"], ["hellkite", "1"]]
var road2_difficulty_4_variation_4 = [["villager", "10"],["hellkite", "1"], ["villager", "0"]]
var road2_difficulty_4_variation_5 = [["rifleman", "5"],["rifleman", "5"], ["hellkite", "1"]]


var road_2_scenarios_difficulty_3 = [road2_difficulty_3_variation_1, road2_difficulty_3_variation_2, road2_difficulty_3_variation_3 ,road2_difficulty_3_variation_4, road2_difficulty_3_variation_5]
var road_2_scenarios_difficulty_1 = [road2_difficulty_1_variation_1, road2_difficulty_1_variation_2, road2_difficulty_1_variation_3 ,road2_difficulty_1_variation_4, road2_difficulty_1_variation_5]
var road_2_scenarios_difficulty_4 = [road2_difficulty_4_variation_1, road2_difficulty_4_variation_2, road2_difficulty_4_variation_3 ,road2_difficulty_4_variation_4, road2_difficulty_4_variation_5]

#########################
#
# road3 scenarios
#
##########################
var road3_difficulty_1_variation_1 = [["villager", "2"], ["swordsman", "1"], ["villager", "2"], ["rifleman", "1"]]
var road3_difficulty_1_variation_2 = [["villager", "2"], ["swordsman", "1"], ["headyhandballer", "1"], ["villager", "2"]]
var road3_difficulty_1_variation_3 = [["swordsman", "1"],["headyhandballer", "1"], ["headyhandballer", "1"], ["swordsman", "1"]]
var road3_difficulty_1_variation_4 = [["swordsman", "1"],["hellkite", "1"], ["villager", "3"], ["rifleman", "1"]]
var road3_difficulty_1_variation_5 = [["rifleman", "1"],["swordsman", "1"], ["villager", "2"], ["rifleman", "1"]]



var road3_difficulty_3_variation_1 = [["villager", "5"], ["swordsman", "4"], ["villager", "5"], ["rifleman", "4"]]
var road3_difficulty_3_variation_2 = [["villager", "5"], ["swordsman", "4"], ["headyhandballer", "4"], ["villager", "2"]]
var road3_difficulty_3_variation_3 = [["swordsman", "4"],["headyhandballer", "4"], ["headyhandballer", "4"], ["swordsman", "4"]]
var road3_difficulty_3_variation_4 = [["swordsman", "4"],["hellkite", "1"], ["villager", "15"], ["rifleman", "5"]]
var road3_difficulty_3_variation_5 = [["rifleman", "5"],["swordsman", "4"], ["villager", "10"], ["rifleman", "5"]]


var road3_difficulty_4_variation_1 = [["villager", "10"], ["hellkite", "1"], ["villager", "10"], ["swordsman", "4"]]
var road3_difficulty_4_variation_2 = [["villager", "10"], ["hellkite", "1"], ["headyhandballer", "6"], ["swordsman", "4"]]
var road3_difficulty_4_variation_3 = [["swordsman", "5"],["headyhandballer", "2"], ["hellkite", "1"], ["swordsman", "4"]]
var road3_difficulty_4_variation_4 = [["villager", "10"],["hellkite", "1"], ["villager", "1"], ["swordsman", "4"]]
var road3_difficulty_4_variation_5 = [["rifleman", "5"],["rifleman", "5"], ["hellkite", "1"], ["swordsman", "4"]]

var road_3_scenarios_difficulty_1 = [road3_difficulty_1_variation_1, road3_difficulty_1_variation_2, road3_difficulty_1_variation_3 ,road3_difficulty_1_variation_4, road3_difficulty_1_variation_5]
var road_3_scenarios_difficulty_3 = [road3_difficulty_3_variation_1, road3_difficulty_3_variation_2, road3_difficulty_3_variation_3 ,road3_difficulty_3_variation_4, road3_difficulty_3_variation_5]
var road_3_scenarios_difficulty_4 = [road3_difficulty_4_variation_1, road3_difficulty_4_variation_2, road3_difficulty_4_variation_3 ,road3_difficulty_4_variation_4, road3_difficulty_4_variation_5]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func populate_rooms(list_of_rooms, difficulty):
	for room in list_of_rooms:
		var spawners_node = room.get_node("Statics").get_node_or_null("Spawners")
		if spawners_node != null:
			var spawner_indexes = spawners_node.get_child_count()
			for i in range(0, spawner_indexes):
				var scenario_list = select_scenario_list(room.room_type, difficulty)
				if scenario_list != []:
					var scenario = random_scenario(scenario_list)

					spawners_node.get_child(i).initialize(enemy_from_scenario(scenario, i))
					spawners_node.get_child(i).set_wave_size(wave_size_from_scenario(scenario, i))
					spawners_node.get_child(i).reset_waves_spawned()

func select_scenario_list(room_type, difficulty):
	if room_type == "road_2":
		if difficulty == 1:
			return road_2_scenarios_difficulty_1
		elif difficulty == 3:
			return road_2_scenarios_difficulty_3
		elif difficulty == 4:
			return road_2_scenarios_difficulty_4

	if room_type == "road_3":
		if difficulty == 1:
			return road_3_scenarios_difficulty_1
		elif difficulty == 3:
			return road_3_scenarios_difficulty_3
		elif difficulty == 4:
			return road_3_scenarios_difficulty_4
	else:
		return []

	##and so on


func random_scenario(scenario_list):
	var r = scenario_list.size()
	return scenario_list[rand_range(0,r)]


func enemy_from_scenario(scenario, spawner_index):
	return scenario[spawner_index][0]

func wave_size_from_scenario(scenario, spawner_index):
	return int(scenario[spawner_index][1])
