import wollok.game.*

object militar {
    var property image = "militarPrueba.png"
    var property position = game.at(0, game.height() / 2) // Posicionar al militar en el borde izquierdo, centrado verticalmente
}

class Enemigo {
    var property image = "enemigoPrueba.png" // Imagen del enemigo
    var property position = game.at(0, 0) // Inicialmente en (0, 0), se ajustará en aparecer

    method aparecer() {
        const x = game.width() - 1 // Aparecer en el borde derecho
        const y = 1.randomUpTo(game.height() - 2).truncate(0) // Posición aleatoria en el eje y
        position = game.at(x, y)
        
        game.addVisual(self)
        game.onTick(1000, "movimiento", { self.moverIzquierda() }) // Moverse hacia la izquierda
    }

    method moverIzquierda() {
        const nuevaX = position.x() - 1 // Moverse hacia la izquierda
        if (nuevaX >= 0) { // Mientras no salga del borde izquierdo
            position = game.at(nuevaX, position.y())
        } else {
            game.removeVisual(self) // Eliminar al enemigo si llega al borde izquierdo
        }
    }
}

class Proyectil {
    var property image = "proyectilPrueba.png" // Imagen del proyectil
    var property position = game.at(militar.position.x(), militar.position.y()) // La bala proviene del militar
}

const enemigo1 = new Enemigo()