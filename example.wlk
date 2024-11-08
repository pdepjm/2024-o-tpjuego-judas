import wollok.game.*

object arriba{
    method mover(){
     militar.position(militar.posicionArriba())
    }
}
object abajo{
    method mover(){
     militar.position(militar.posicionAbajo())
    }
}
object derecha{
    method mover(){
     militar.position(militar.posicionDerecha())
    }
}
object izquierda{
    method mover(){
     militar.position(militar.posicionIzquierda())
    }
}

object normal{
    method moverHacia(direccion)
    {
     direccion.mover()
    }

/*
    method moverHaciaDerecha(){
        militar.position(militar.posicionDerecha())
    }

     method moverHaciaArriba(){
        militar.position(militar.posicionArriba())
    }

    method moverHaciaAbajo(){
        militar.position(militar.posicionAbajo())
    }*/

    method image(inmune) {
        if(inmune){
            return "Soldado_Dorado.png"
        }
        else{
            return "Soldado.png"
        }
    }
}

object estaArreglando{
    method moverHacia(direcccion){
        game.say(self, "No puedo moverme")
    }
    method image(inmune) {
        if(inmune){
            return "Soldado_Dorado.png"
        }
        else{
            return "bob.png"
        }
    }
}

object militar {
    method image() = estado.image(inmune)
    var property position = game.at(0, game.height() / 2) // posicionar al militar en el borde izquierdo, centrado verticalmente
    var vida = 3
    var inmune = false
    var estado = normal
    

    method posicionIzquierda() = position.left(1)
    method posicionDerecha() = position.right(1)
    method posicionArriba() = position.up(1)
    method posicionAbajo() = position.down(1)


    //movimientos

    method moverseHacia(direccion) {
    estado.moverHacia(direccion)
    }
/*
    method moverseHaciaIzquierda(){
        estado.moverHaciaIzquierda()

        if(puedeMoverse){
		self.position(position.left(1))
        }else{
            game.say(self, "No puedo moverme")
        } 
	}*/
	

    method arreglar(estaArreglando){

    }

/*
	method moverseHaciaDerecha(){
		if(puedeMoverse){
		self.position(position.right(1))
        }else{
            game.say(self, "No puedo moverme")
        }
	}

    method moverseHaciaArriba(){
		if(puedeMoverse){
		self.position(position.up(1))
        }else{
            game.say(self, "No puedo moverme")
        }
	}

    method moverseHaciaAbajo(){
		if(puedeMoverse){
		self.position(position.down(1))
        }else{
            game.say(self, "No puedo moverme")
        }
	}
*/


    //method image() = image

    /*method image(nuevaImagen) {
        image = nuevaImagen
    }
    */
    


    
    method llenarVida(){vida = 3}
    method cuantaVida() = vida

    method dimeLaVidaActual(){
        
        game.say(self, "Vida Militar: " + vida.toString()) 
    }

    method dimeVidaDeLaBase(){
        game.say(self, "Vida Base: " + base.vida) 
    }

    method restarVida(nuevaVida){
        vida -= nuevaVida

        if(vida < 1){
            game.say(self, "¡Fin Del Juego!")
            interfaz.detenerJuego()
            // PONER FIN DEL JUEGO
        }
        else{
            game.say(self, "¡Perdi una vida!")
        }
    }  
    
    method sumarVida(nuevaVida){
                if (vida >= 3){} else {vida += nuevaVida} //Max vidas es 3

        } 
    //var puntos = 0 // Puntos como número
    //var tiempoJugado = 0 // Tiempo jugado en segundos
    //var property puntosVisual = "Puntos: 0"

    // Método para disparar proyectiles
    method disparar() {
        const bala1 = new Proyectil()
		game.addVisual(bala1)
        bala1.moverse()
        //game.onCollideDo(bala1, { enemigo1 => bala1.enemigoColisionado(enemigo1)})
        game.onCollideDo(bala1, { colisionado => colisionado.chocarConBala(bala1)})
        
        //al salir del borde se elimina la bala
         if(bala1.position().x() == game.width()) { 
				game.removeVisual(bala1) 
				game.removeTickEvent("moverProyectil") 
        }
       
    

/*
    // Método para actualizar el tiempo jugado y sumar puntos por segundo
    method actualizarTiempoYPuntos() {
        tiempoJugado += 1
        puntos += 1 // Se suma 1 punto por cada segundo
        puntosVisual = "Puntos: " + puntos.toString() // Actualizar el texto visible de los puntos
    }
*/
    }
    method serAtacado(){
        if(inmune){
            game.say(self, "¡SOY INMUNE!")
        }
        else {
            self.restarVida(1)
        }
     
    }

    
    method activarInmunidad(){
        inmune = true
        game.onTick(5000, "deshabilitar inmunidad",{ self.desactivarInmunidad() })
    }

    method desactivarInmunidad(){
        inmune = false
    }
    method chocarConBala(bala1){ }
    
    method arreglarBase(){
        game.say(self, "Arreglando la base")
        estado=estaArreglando
        if(inmune){
            game.onTick(2000, "No Moverse",{ estado = normal })
           // game.onTick(2000, "volver",{ image = "soldado.png"})
            
        }
        else{
            game.onTick(4000, "No Moverse",{ estado = normal })
          //  game.onTick(4000, "volver",{ image = "soldado.png"})
        }
        //game.onTick(4000, "POnerkla DURA",{ self.desactivarInmunidad() })
        base.vida(2)
    }
    

}
class Enemigo {
    var property image = "zombie2.png" 
    var property position = game.at(0, 0) // Inicialmente en (0, 0), se ajustará a la hora de aparecer
    var nombre
    method generarEnemigo() {
        const x = game.width() - 1 // Aparecer en el borde derecho
        const y = 1.randomUpTo(game.height() - 2).truncate(0) // Posición aleatoria en el eje y
        position = game.at(x, y)
        
        game.addVisual(self)
        nombre="movimiento"+(1.randomUpTo(10000)).toString()
        game.onTick(1000, nombre, { self.moverIzquierda() }) 
    }

    /*method movimiento(){
        game.onTick(1000, "movimiento", { self.moverIzquierda() }) 
    }*/

    method moverIzquierda() {
        const nuevaX = position.x() - 1 // Moverse hacia la izquierda
        if (nuevaX >= 0) { // Mientras no salga del borde izquierdo
            position = game.at(nuevaX, position.y())
        } else {
            self.morir()// Eliminar al enemigo si llega al borde izquierdo
            base.restarVida(1)
        }
    }

    method chocarConMilitar(){
        self.morir()
        militar.serAtacado()
    }


    method chocarConBala(bala1){
        //bala1.desaparecer() // Eliminar proyectil
        game.removeVisual(bala1) 
        game.removeTickEvent("moverProyectil") // Detener el movimiento del proyectil
        self.morir() // Destruir al enemigo
    }

    // Método para destruir el enemigo y sumar puntos
     method morir() {
        game.removeTickEvent(nombre)// Detener el movimiento del enemigo
        game.removeVisual(self)
        // const puntosPorMatar = 5

    }

}

class Proyectil {
    //var property position = self.posicionInicial()
	//method posicionInicial() = militar.position().right(1)

    var property image = "Bala_Loca.png" 
    var property position = militar.position().right(1) // La bala proviene del militar

    method moverse() {
        game.onTick(50, "moverProyectil", { self.moverDerecha() })
    }  

    /*method moverDerecha() {
        const nuevaX = position.x() + 1
        if (nuevaX < game.width()) {
            position = game.at(nuevaX, position.y())
        } else {
            game.removeVisual(self) // Eliminar proyectil si sale del borde derecho
        }
    }*/

    method moverDerecha() {
        const proximaPosicion = position.right(1)
        if (proximaPosicion.x() < game.width()) {
            position = proximaPosicion
        } else {
            game.removeVisual(self) // Eliminar proyectil si sale del borde derecho
        }
    }
    

    /*method enemigoColisionado(enemigo1) {
        game.removeVisual(self) // Eliminar proyectil
        game.removeTickEvent("moverProyectil") // Detener el movimiento del proyectil
        enemigo1.morir() // Destruir al enemigo
    }*/
    method chocarConMilitar(){  } //le hacemos una colision vacia con el militar para que no haya errores 
}
/*
const enemigo1 = new Enemigo()

const manzanaRoja1 = new ManzanaRoja()

const manzanaDorada1 = new ManzanaDorada()

const superManzana1 = new SuperManzana()
*/
class Manzana{
    var property position = game.at(0, 0)
    
    method generarManzana() {

        //posicion aleatoria
        const x = 0.randomUpTo(game.width()) // Aparecer en el borde derecho
        const y = 0.randomUpTo(game.height()) // Posición aleatoria en el eje y
        position = game.at(x, y)
        
        game.addVisual(self)
    }

    method chocarConMilitar(){
        self.habilidad()
        game.removeVisual(self)
    }

    method habilidad() {    }
    method chocarConBala(bala1){ }

}
class ManzanaRoja inherits Manzana{

    var property image = "Manzana.png" 
    
    override method habilidad() {
      militar.sumarVida(1)
    }
}

class ManzanaDorada inherits Manzana{
    
    var property inmunidadActivada = false
    
    method image() = "Manzana_Dorada.png" 

    
    /*override method habilidad() {
        inmunidadActivada = true
        militar.image("Soldado_Dorado.png") 
        game.onTick(5000, "deshabilitar inmunidad",{ self.inmunidad() })
        game.schedule(5000, {militar.image("Soldado.png")})
    }*/
    override method habilidad() {
        militar.activarInmunidad()
        
    }
    /*
    override method habilidad() {
        militar.inmune = true
        militar.image("Soldado_Dorado.png") 
        game.onTick(5000, "deshabilitar inmunidad",{ militar.inmune = false })
        game.schedule(5000, {militar.image("Soldado.png")})
    }
    */

    /* method inmunidad(){
        inmunidadActivada = false
    } */
}

class SuperManzana inherits ManzanaDorada {
    
    //self.cambiarImage("Manzana_Super.png") {image = "Manzana_Super.png"}

    override method habilidad() {
        super()
        militar.llenarVida()
    }

    override method image() = "superManzana.png"
}

object base {
    var property vida = 3
    
    method restarVida(nuevaVida){
        if(vida>1){
            vida -= nuevaVida
            game.say(militar, "La base perdió una vida!")}
        else{
            game.say(militar, "Perdí cayó la base")
            interfaz.detenerJuego()
            // PONER FIN DEL JUEGO
        }
    }  
}

////////////////////////////////////////////////////////////
//////////////////////   GAME OVER  ////////////////////////
////////////////////////////////////////////////////////////
object gameOver{
	var property position = game.at(0,0)
	method quitar(){
		game.removeVisual(self)
	}
	method image() = "gameOver.jpg"
	method colocar(){
		game.addVisual(self)
	}
}

object interfaz {
    method empezarJuego() {
        
        game.addVisual(militar)
    
        self.desbloquearTeclas()
        self.colisiones()
        
        // Generar enemigos cada 4 segundos
        game.onTick(4000, "aparece enemigo" + (1.randomUpTo(10000)).toString(), {
            const enemigo1 = new Enemigo(nombre="")
            enemigo1.generarEnemigo()
        }) 

        game.onTick(15000, "aparece manzana roja", {
            const manzanaRoja1 = new ManzanaRoja()
            manzanaRoja1.generarManzana()
        }) 

        game.onTick(20000, "aparece manzana dorada", {
            const manzanaDorada1 = new ManzanaDorada()
            manzanaDorada1.generarManzana()
        }) 

        game.onTick(25000, "aparece manzana super", {
            const superManzana1 = new SuperManzana()
            superManzana1.generarManzana()
        }) 
    }

    method desbloquearTeclas() {
        keyboard.e().onPressDo { militar.dimeLaVidaActual() }
        keyboard.b().onPressDo { militar.dimeVidaDeLaBase() }
        keyboard.f().onPressDo { militar.arreglarBase() }
        keyboard.space().onPressDo { self.detenerJuego() }
        keyboard.r().onPressDo { self.restart() }
        keyboard.p().onPressDo { militar.disparar() }

        //flechas de movimiento
        keyboard.a().onPressDo( { militar.moverseHacia(izquierda) } )
		keyboard.d().onPressDo( { militar.moverseHacia(derecha) } )
        keyboard.w().onPressDo( { militar.moverseHacia(arriba) } )
        keyboard.s().onPressDo( { militar.moverseHacia(abajo) } )
    }

    method colisiones() {
        game.whenCollideDo(militar, { colisionado => colisionado.chocarConMilitar() })
    }

    method restart() {
        self.empezarJuego()

        gameOver.quitar()
    }
    
    method detenerJuego() {
        //detener todos los eventos
        game.removeTickEvent("aparece enemigo")
        game.removeTickEvent("aparece manzana roja")
        game.removeTickEvent("aparece manzana dorada")
        game.removeTickEvent("aparece manzana super")
        game.removeTickEvent("actualizar tiempo y puntos")
        game.removeTickEvent("moverProyectil") 
    
        //borrar militar
        game.removeVisual(militar)
        //borrar zombies

        gameOver.colocar()
    }
}
