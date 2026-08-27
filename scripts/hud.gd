extends CanvasLayer

func _ready():
	$coinlabel.text = str(0)
	$scorelabel.text = str(0)

func _process(delta):
	$coinlabel.text = str(Gamemaneger.money)
	$scorelabel.text = str(Gamemaneger.score)
	pass
