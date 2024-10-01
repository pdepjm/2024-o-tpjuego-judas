object juegoDeRacismo {
  method iniciar(){
    game.height(10)
	  game.width(10)

    //game.addVisual(algo)
    //game.addVisualCharacter(mario)

    //quiero que mi personaje se mueva de derecha a izquierda
    //keyboard.a().onPressDo({negro.irALaIzq()})
    

    game.onCollideDo(mario, {algo=>algo.agarrar()})
    game.onTick(1000, "moverse", {robot.moverseSolo()})
  }

object negro{
 
  var dondeEsta = game.origin()

  method position() = dondeEsta
  
  //method image() = if (dondeEsta.x() == 8) "vegeta.jpg" else "mario.png"
  
  method position(nueva) {
    dondeEsta = nueva
  }

  method irAlBorde() {
    dondeEsta = game.at(8,dondeEsta.y())
    game.schedule(300, {dondeEsta = dondeEsta.up(1)})

  }



}