extends KinematicBody2D

#variaveis
var velocidade = 1.5
var velocidadeMax = 200
var forca_pulo = 700
var gravidade = 10
var pulando = false
var atirando = false
var mov = Vector2.ZERO #zera os vetores x e y

#O PLANO CARTESIANO AQUI NA GODOT FUNCIONA INVERTIDO,
# OU SEJA PRA CIMA É - E PRA BAIXO É +
#
#Para adicionar teclas, controle, etc, podemos ir nas configurações do projeto 
#e vamos em mapa de entrada para configurar novas teclas, ou botões.
# variavel de movimentação



#Varivel delta é o tempo de exibição de cada frame



func _process(delta):
	mov.y += gravidade #Eixo y simbolisa a altura em que o personagem esta no plano
	parado()
	
	movimentacao()
		
	animacao()
		
	mov = move_and_slide(mov, Vector2(0,-1))# aqui mostramos onde esta o teto, 


#Movimentação do personagem.
func movimentacao():
	if (Input.is_action_pressed("ui_left")): #Movimento para esquerda
		if(mov.x != -velocidadeMax):
			mov.x -= 2 * velocidade
		
		#Movimento para direita
	elif (Input.is_action_pressed("ui_right")):
		if(mov.x != velocidadeMax):
			mov.x += 2 * velocidade
	else:
		mov.x = 0 # Eixo x é o deslocamento do personagem
		
	if (Input.is_action_just_pressed("ui_up") and is_on_floor()):#Movimento de pulo 
		mov.y = -forca_pulo

#Animaçoes do personagem
func animacao():
		#Animação do personagem.
	if(Input.is_action_just_pressed("ui_up")):
		$AnimationPlayer.play("PuloNormal")
		
	elif (Input.is_action_pressed("ui_left")): #Movimento para esquerda
		$Sprite.flip_h = false #Modifica a orientação do personagem
		if(mov.x < 60 and is_on_floor()):
			$AnimationPlayer.play("Andando")
		elif(mov.x > 60 and is_on_floor()):
			$AnimationPlayer.play("Correndo")
		
	#Movimento para direita
	elif (Input.is_action_pressed("ui_right")):
		$Sprite.flip_h = true #Modifica a orientação do personagem
		if(mov.x > - 60 and is_on_floor()):
			$AnimationPlayer.play("Andando")
		elif(mov.x < - 60 and is_on_floor()):
			$AnimationPlayer.play("Correndo")
		
		
		
		if(is_on_floor()):#Verifica se o personagem está no chão
			pulando = false
			
			if(not atirando):
				parado()
					
				if(Input.is_action_just_pressed("disparo")):
					$AnimationPlayer.play('atirando')
					atirando = true
					
			if($AnimationPlayer.current_animation==""):
				atirando = false
		elif(not pulando):
			$AnimationPlayer.play("PuloNormal")
			pulando = true



func parado():
	if(is_on_floor() and mov.x == 0):
		if(Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
			if(mov.x > 60 or mov.x < -60):
				$AnimationPlayer.play("Correndo")
			else:
				$AnimationPlayer.play("Andando")
		else:
			$AnimationPlayer.play("Parado")
