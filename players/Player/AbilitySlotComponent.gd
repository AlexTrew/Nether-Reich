extends Node

var slots = [null, null , null , null]

#used for swapping ability slots
var slot_tmp
signal ability_loaded(slot, ability)
signal ability_unloaded(slot)

var summon_cannon_ability = preload("res://Abilities/SummonCannonAbility/SummonCannonAbility.tscn")

var abilities = {'summon_cannon' : summon_cannon_ability}

func _ready():
	pass # Replace with function body.


func get_free_slot_number():
	for i in range(0, len(slots)):
		if slots[i] == null:
			return i + 1
	return -1

func assign_ability_to_slot_or_unload_4(ability):
	var free_slot = get_free_slot_number()
	if free_slot != -1:
		print("ability assigned to slot " + str(free_slot))
		slots[free_slot-1] = ability
		return free_slot
	else:
		unload_ability(4)
		return -1

func load_ability(ability_str, level):
	if !is_ability_already_assigned(ability_str):
		var ability_instance = abilities[ability_str].instance()
		ability_instance.name = ability_str
		add_child(ability_instance)
		var free_slot = assign_ability_to_slot_or_unload_4(ability_instance)
		ability_instance.init(level)

		if  free_slot!= -1:
			emit_signal("ability_loaded", free_slot, ability_str)	
		
	else:
		print("this ability is already assigned!")

func is_ability_already_assigned(ability_str):
	for slot in slots:
		if slot != null:
			if slot.name == ability_str:
				return true
	return false


func unload_ability(slot):
	var ability = slots[slot-1]
	if ability != null:
		emit_signal("ability_unloaded", slot)
		ability.queue_free()

func use_ability(slot):
	var ability = slots[slot-1]
	if ability != null:
		ability.use_ability()



func can_use_ability():
	pass
