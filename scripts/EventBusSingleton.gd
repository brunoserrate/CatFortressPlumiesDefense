extends Node

var event_handlers = {}

func register_event(event_name):
	if not event_handlers.has(event_name):
		event_handlers[event_name] = []

func connect_event(event_name, target, method):
	if event_handlers.has(event_name):
		event_handlers[event_name].append({"target": target, "method": method})
	else:
		event_handlers[event_name] = [{"target": target, "method": method}]

func emit_event(event_name, data = null):
	if event_handlers.has(event_name):
		for handler in event_handlers[event_name]:
			if data == null:
				handler["target"].callv(handler["method"], [])
			else:
				handler["target"].callv(handler["method"], [data])
