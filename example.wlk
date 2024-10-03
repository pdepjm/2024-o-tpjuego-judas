import wollok.game.*

object militar {
    var property image = "militarPrueba.png"
    var property position  = game.origin()

}

class Enemigo{
    var property image = "alien.png" //imagen de base
    var position =  game.at(2,2)

    method position() = position
    method moverseRandom(){
        
    }

    method moverseSolo() {
    position = game.at(0.randomUpTo(4),0.randomUpTo(4) )
  }
    method subir() {
    position = position.up(1)
  }
}

const enemigo1 = new Enemigo()

class Proyectil {
    var property image = "" //agregar imagen
    var property position =  game.origin()// la bala proviene del personaje 
}