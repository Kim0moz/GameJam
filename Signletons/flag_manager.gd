extends Node

@export var flags : Dictionary

func createFlag(flagName : String, flagState, flagSignal : Signal):
	var flag = flags.get_or_add(flagName)
	flag.State = flagState
	flag.Signal = flagSignal
	flags.get(flagName).Signal.emit(flag.State)
	
func setFlag(flagName : String, flagState):
	if flags.has(flagName):
		var flag = flags.get_or_add(flagName)
		flag.State = flagState
		flags.get(flagName).Signal.emit(flag.State)
	else:
		return false

func getFlagValue(flagName : String):
	if flags.has(flagName):
		return flags[flagName].State
	else:
		return false

func getFlag(flagName : String):
	if flags.has(flagName):
		return flags[flagName]
	else:
		return false
