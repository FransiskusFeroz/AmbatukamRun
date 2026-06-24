extends AudioStreamPlayer3D

func walk(material: int = 0, speed: float = 1.0):
	if speed == 0:
		#stop()
		return
	if not playing:
		play()
		
