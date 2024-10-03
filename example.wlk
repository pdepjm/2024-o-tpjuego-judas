import wollok.game.*

object militar {
    var property image = "militarPrueba2.png"
    var property position = game.at(0, game.height() / 2) // posicionar al militar en el borde izquierdo, centrado verticalmente
    var puntos = "Puntos: 0"

}

class Enemigo {
    var property image = "zombie2.png" 
    var property position = game.at(0, 0) // inicialmente en (0, 0), se ajustará a la hora de aparecer

    method aparecer() {
        const x = game.width() - 1 // aparecer en el borde derecho
        const y = 1.randomUpTo(game.height() - 2).truncate(0) // posición aleatoria en el eje y
        position = game.at(x, y)
        
        game.addVisual(self)
        game.onTick(1500, "movimiento", { self.moverIzquierda() }) 
    }

    method moverIzquierda() {
        const nuevaX = position.x() - 1 // moverse hacia la izquierda
        if (nuevaX >= 0) { // mientras no salga del borde izquierdo
            position = game.at(nuevaX, position.y())
        } else {
            game.removeVisual(self) // eliminar al enemigo si llega al borde izquierdo
            game.say(militar, "Perdí cayó la base")
            //perder juego
            
        }
        
    }
    method teTocoEnemigo(){
        game.say(militar, "¡Perdí!")
        //perder juego
    }

}

class Proyectil {
    var property image = "proyectilPrueba.png" 
    var property position = game.at(militar.position.x(), militar.position.y()) // la bala proviene del militar
}

const enemigo1 = new Enemigo()
