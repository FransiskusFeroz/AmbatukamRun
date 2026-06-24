class_name Interactable
extends Area3D

@export var enabled: bool = true

signal interacted(interactor: Node3D)

func interact(interactor: Node3D): 
	if enabled:
		interacted.emit(interactor)

func enable(): enabled = true

func disable(): enabled = false
