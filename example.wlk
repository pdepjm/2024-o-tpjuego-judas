import wollok.game.*

object militar {
    var property image = "militarPrueba2.png"
    var property position = game.at(0, game.height() / 2) // posicionar al militar en el borde izquierdo, centrado verticalmente
    var puntos = 0 // Puntos como número
    var tiempoJugado = 0 // Tiempo jugado en segundos
    var property puntosVisual = "Puntos: 0"

    // Método para disparar proyectiles
    method disparar() {
        const bala1 = new Proyectil()
		game.addVisual(bala1)
        bala1.moverse()
        game.onCollideDo(bala1, { enemigo => bala1.enemigoColisionado(enemigo)})
    }

    // Método para actualizar el tiempo jugado y sumar puntos por segundo
    method actualizarTiempoYPuntos() {
        tiempoJugado += 1
        puntos += 1 // Se suma 1 punto por cada segundo
        puntosVisual = "Puntos: " + puntos.toString() // Actualizar el texto visible de los puntos
    }
}

class Enemigo {
    var property image = "zombie2.png" 
    var property position = game.at(0, 0) // Inicialmente en (0, 0), se ajustará a la hora de aparecer

    method aparecer() {
        const x = game.width() - 1 // Aparecer en el borde derecho
        const y = 1.randomUpTo(game.height() - 2).truncate(0) // Posición aleatoria en el eje y
        position = game.at(x, y)
        
        game.addVisual(self)
        game.onTick(1500, "movimiento", { self.moverIzquierda() }) 
    }

    method moverIzquierda() {
        const nuevaX = position.x() - 1 // Moverse hacia la izquierda
        if (nuevaX >= 0) { // Mientras no salga del borde izquierdo
            position = game.at(nuevaX, position.y())
        } else {
            game.removeVisual(self) // Eliminar al enemigo si llega al borde izquierdo
            game.say(militar, "Perdí cayó la base")
            // Fin del juego
        }
    }

    method teTocoEnemigo() {
        game.say(militar, "¡Perdí!")
        // Fin del juego
    }

    // Método para destruir el enemigo y sumar puntos
     method morir() {
        game.removeTickEvent("movimiento") // Detener el movimiento del enemigo
        game.removeVisual(self)
        const puntosPorMatar = 5
    }
}

class Proyectil {
    //var property position = self.posicionInicial()
	//method posicionInicial() = militar.position().right(1)

    var property image = "bala_blanca.png" 
    var property position = militar.position() // La bala proviene del militar

    method moverse() {
        game.onTick(50, "moverProyectil", { self.moverDerecha() })
    }

    method moverDerecha() {
        const nuevaX = position.x() + 1
        if (nuevaX < game.width()) {
            position = game.at(nuevaX, position.y())
        } else {
            game.removeVisual(self) // Eliminar proyectil si sale del borde derecho
        }
    }

    method enemigoColisionado(enemigo) {
        game.removeVisual(self) // Eliminar proyectil
        enemigo.morir() // Destruir al enemigo
    }
}

const enemigo1 = new Enemigo()