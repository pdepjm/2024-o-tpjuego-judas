import wollok.game.*


object arriba{
    method mover(){
        var posicionNueva = militar.posicionArriba()
        if(militar.estaDentroDelLimite(posicionNueva)){
           militar.position(posicionNueva) 
        }
     
    }
}
object abajo{
    method mover(){
        var posicionNueva = militar.posicionAbajo()
        if (militar.estaDentroDelLimite(posicionNueva)) {
            militar.position(posicionNueva)
        }
    }
}
object derecha{
    method mover(){
        var posicionNueva = militar.posicionDerecha()
        if (militar.estaDentroDelLimite(posicionNueva)) {
            militar.position(posicionNueva)
        }
    }
}
object izquierda{
    method mover(){
        var posicionNueva = militar.posicionIzquierda()
        if (militar.estaDentroDelLimite(posicionNueva)) {
            militar.position(posicionNueva)
        }
    }
}

object normal{
    method moverHacia(direccion)
    {
     direccion.mover()
    }

    method image(inmune) {
        if(inmune){
            return "Soldado_Dorado.png"
        }
        else{
            return "Soldado.png"
        }
    }

    method disparo(){
        if(not(gameOver.estado())){
            var nombreBala = (1.randomUpTo(10000)).toString()
            const bala1 = new Proyectil(nombre=nombreBala)
		
            bala1.aparecer()
        }
    }
}

object estaArreglando{
    method moverHacia(direcccion){}
    method image(inmune) {
        if(inmune){
            return "constructorInmune.png"
        }
        else{
            return "constructorNormal.png" 
        }
    }

    method disparo(){}
}

object vidaMilitar{
    var property position = game.at(1,0)
    
    method image(){
        if (militar.cuantaVida() == 3){
            return "3corazones.png"
        }
        else if(militar.cuantaVida() == 2){
            return "2corazones.png"
        } else {
            return "1corazon.png"
        }
    }
    
    method chocarConMilitar(){}
    method chocarConBala(){}
    
}

object militar {
    method image() = estado.image(inmune)
    var property position = game.at(0, game.height() - 1)
    var vida = 3
    var property inmune = false
    var estado = normal
    
    method dimeEstado() = estado

    method posicionIzquierda() = position.left(1)
    method posicionDerecha() = position.right(1)
    method posicionArriba() = position.up(1)
    method posicionAbajo() = position.down(1)


    //movimientos

    method moverseHacia(direccion) {
    estado.moverHacia(direccion)
    }
	

    method estaDentroDelLimite(unaPosicion) {
    return unaPosicion.x() >= 0 && unaPosicion.x() <= game.width() - 1 &&
           unaPosicion.y() >= 0 && unaPosicion.y() <= game.height() - 1
    }

    method arreglar(estaArreglando){

    }

    method llenarVida(){vida = 3}
    method cuantaVida() = vida


    method restarVida(nuevaVida){
        vida -= nuevaVida

        if(vida < 1){
            interfaz.detenerJuego()
            gameOver.estaActivado(true)
        }
        else{}
    }  
    
    method sumarVida(nuevaVida){
        if (vida >= 3){} else {vida += nuevaVida} //Max vidas es 3

    } 

    // Método para disparar proyectiles
    method disparar() {
        estado.disparo()
    }
    
    method serAtacado(){
        if(inmune){}
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
        estado=estaArreglando
        if(inmune){
            game.onTick(2000, "No Moverse",{ estado = normal })  
        }
        else{
            game.onTick(4000, "No Moverse",{ estado = normal })
        }
        base.vida(2)
    }
    

}
class Enemigo {
    var property image = "zombie2.png" 
    var property position = game.at(0, 0) // Inicialmente en (0, 0), se ajustará a la hora de aparecer
    var nombre
    method generarEnemigo() {
        if(not(gameOver.estado())){ //gameOver.estado().negate()
            const x = game.width() - 1 // Aparecer en el borde derecho
            const y = 1.randomUpTo(game.height() - 2).truncate(0) // Posición aleatoria en el eje y
            position = game.at(x, y)
        
            game.addVisual(self)
            nombre="movimiento"+(1.randomUpTo(10000)).toString()
            game.onTick(500, nombre, { self.moverIzquierda() })
        }
    }

    method moverIzquierda() {
        const nuevaX = position.x() - 1 // Moverse hacia la izquierda
        if (nuevaX >= 0) { // Mientras no salga del borde izquierdo
            position = game.at(nuevaX, position.y())
            if (gameOver.estado()){self.morir()}
        } 
        else {
            self.morir()// Eliminar al enemigo si llega al borde izquierdo
            base.restarVida(1)
        }
    }

    method chocarConMilitar(){
        self.morir()
        militar.serAtacado()
    }

    method chocarConBala(bala1){
        bala1.desaparecer() // Eliminar proyectil
        self.morir() // Destruir al enemigo
    }

    // Método para destruir el enemigo y sumar puntos
     method morir() {
        game.removeTickEvent(nombre)// Detener el movimiento del enemigo
        game.removeVisual(self)
        contador.sumarPunto(1)
    }

}

class Proyectil {

    var property image = "Bala_Loca.png" 
    var property position = militar.position().right(1) // La bala proviene del militar
    var nombre = "moverProyectil"+(1.randomUpTo(10000)).toString()
    
    method moverse() {
            game.onTick(40, nombre, { self.moverDerecha() })
    }  

    method aparecer(){
        game.addVisual(self)
        self.moverse()
        
        game.onCollideDo(self, { colisionado => colisionado.chocarConBala(self)})
    }

    method chocarConBala(proyectil){}
    method moverDerecha() {
        const proximaPosicion = position.right(1)
        if (proximaPosicion.x() < game.width()) {
            position = proximaPosicion
        } else {
            game.removeVisual(self) // Eliminar proyectil si sale del borde derecho
            game.removeTickEvent(nombre)
        }
    }
    method desaparecer(){
        game.removeVisual(self) 
        game.removeTickEvent(nombre)
    }
    method chocarConMilitar(){  } //le hacemos una colision vacia con el militar para que no haya errores 
}

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
    
    method image() = "Manzana_Dorada.png" 

    override method habilidad() {
        militar.activarInmunidad() 
    }
}

class SuperManzana inherits ManzanaDorada {
    
    override method habilidad() {
        super()
        militar.llenarVida()
    }

    override method image() = "superManzana.png"
}

object base {
    var property position = game.at(3,0)
    var property vida = 2
    method image(){
        if (vida == 2){
            return "base2vidas.png"
        }else {
            return "base1vida.png"
        }
    }
    method chocarConMilitar(){}
    method chocarConBala(bala1){}

    method restarVida(nuevaVida){
        if(vida>1){
            vida -= nuevaVida
        }
        else{
            interfaz.detenerJuego()
            vida=0 
            gameOver.estaActivado(true)
        }
    }  
}

////////////////////////////////////////////////////////////
//////////////////////   GAME OVER  ////////////////////////
////////////////////////////////////////////////////////////
object gameOver{
    var estado = false
    method estado() = estado
    method estaActivado(_estado) { estado = _estado}
    
	var property position = game.at(0,0)
	method quitar(){
		game.removeVisual(self)
	}
	method image() = "gameOver3.png"
	method colocar(){
		game.addVisual(self)
        estado = true
	}
}

object interfaz {
    method empezarJuego() {
        
        game.addVisual(militar)
        game.addVisual(vidaMilitar)
        game.addVisual(base)

		game.addVisual(contador)
		game.addVisual(puntuacion)

        self.desbloquearTeclas()
        self.colisiones()
        
        // Generar enemigos cada 2 segundos
        game.onTick(2000, "aparece enemigo" + (1.randomUpTo(10000)).toString(), {
            const enemigo1 = new Enemigo(nombre="")
            enemigo1.generarEnemigo()
        }) 

        /*   mas enemigos
        game.onTick(2000, "aparece enemigo2" + (1.randomUpTo(10000)).toString(), {
            const enemigo2 = new Enemigo(nombre="")
            enemigo2.generarEnemigo()
        }) 
        */

        game.onTick(20000, "aparece manzana roja", {
            const manzanaRoja1 = new ManzanaRoja()
            manzanaRoja1.generarManzana()
        }) 

        game.onTick(25000, "aparece manzana dorada", {
            const manzanaDorada1 = new ManzanaDorada()
            manzanaDorada1.generarManzana()
        }) 

        game.onTick(35000, "aparece manzana super", {
            const superManzana1 = new SuperManzana()
            superManzana1.generarManzana()
        }) 
    }

    method desbloquearTeclas() {
        keyboard.f().onPressDo { militar.arreglarBase() }
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

object contador {
	var contador = 0
	method puntuacion() = contador
	
	method text() = contador.toString()
	
	method position() = puntuacion.position().right(1.5)
	method sumarPunto(valor){
		contador += valor
	}
	method reiniciar(){
		contador = 0
	}
	method textColor() = paleta.blanco()

    method chocarConMilitar(){}
    method chocarConBala(bala1){}
}
object puntuacion {
	const puntuacion = "          Puntuación:"
	var property position = game.at(1, 8).left(1)
	method text() = puntuacion.toString()
	method posicionInicial(){
		position = game.at(1, 8).left(1)
	} 
	method posicionFinal(){
		//position = game.at(1, 8).left(1)
	}
	method textColor() = paleta.blanco()

    method chocarConMilitar(){}
    method chocarConBala(){}
}
object paleta {
	const property blanco = "FFFFFF"
}