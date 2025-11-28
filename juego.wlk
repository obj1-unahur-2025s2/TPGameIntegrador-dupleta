import wollok.game.*
import clases.* 



object juego {
    const personajePrincipal = new Caballero(
        
        position = game.at(8, 2), 
        fuerzaInicial = 15,
        agilidadInicial = 10,
        puntosDeSaludInicial = 100
    )
    method personaje() = personajePrincipal

    var estado = 0 

    method iniciar() {
        game.addVisual(pantallaInicio)
        keyboard.enter().onPressDo { 
            self.avanzarPantalla()
        }
    }

    method avanzarPantalla() {
        if (estado == 0) {
            game.removeVisual(pantallaInicio)
            game.addVisual(pantallaInstrucciones)
            estado = 1
        } 
        else if (estado == 1) {
             game.removeVisual(pantallaInstrucciones)
             estado = 2
             self.comenzarJuego() 
        }
    }

   
    method comenzarJuego() {
        game.addVisual(new Puerta(position = game.at(8, 10)))
        game.addVisual(new Puerta(position = game.at(7, 10)))

        game.addVisual(personajePrincipal) 
        game.addVisual(barraVida)

        game.addVisual(new Lobo(
            position = game.at(2, 5), 
            fuerzaInicial=10, agilidadInicial=5, puntosDeSaludInicial=50
        ))
        
        game.addVisual(new Vampiro(
            position = game.at(8,9),
            fuerzaInicial=15, agilidadInicial=20, puntosDeSaludInicial=60
        ))

        game.addVisual(new Esqueleto(
             position = game.at(13, 5),
             fuerzaInicial=8, agilidadInicial=5, puntosDeSaludInicial=30
        ))
        
        game.addVisual(huesos) 

        self.configurarTeclasDelJuego()
    }

    
    method pasarANivel2() {
        
        game.clear()
        
        game.boardGround("Mazmorra.png") 

        game.addVisual(new Puerta(position = game.at(8, 10)))
        game.addVisual(new Puerta(position = game.at(7, 10)))
        
        personajePrincipal.position(game.at(8, 1))
        game.addVisual(personajePrincipal)
        game.addVisual(barraVida)
        
        game.addVisual(new VampiroJefe(
            position = game.at(8, 9),
            fuerzaInicial=25, agilidadInicial=25, puntosDeSaludInicial=150
        ))

        game.addVisual(new Lobo(
            position = game.at(13, 5),
            fuerzaInicial=12, agilidadInicial=8, puntosDeSaludInicial=60
        ))

        game.addVisual(new Esqueleto(
            position = game.at(2, 5),
            fuerzaInicial=10, agilidadInicial=5, puntosDeSaludInicial=40
        ))

        self.configurarTeclasDelJuego()
    }

    method habilitarPasoNivel3(posicion) {
        game.say(personajePrincipal, "¡Se abre un camino de huesos!")
    }
    method pasarANivel3() {
        game.clear()
        game.boardGround("Mazmorra.png") 
        personajePrincipal.position(game.at(8, 1))
        game.addVisual(personajePrincipal)
        game.addVisual(barraVida)
        game.addVisual(new GranEsqueleto(
            position = game.at(8, 8),
           
            fuerzaInicial = 50,      
            agilidadInicial = 35,
            puntosDeSaludInicial = 250 
        ))
        self.configurarTeclasDelJuego()
    }

    method configurarTeclasDelJuego() {
        keyboard.w().onPressDo { personajePrincipal.moverArriba() }
        keyboard.s().onPressDo { personajePrincipal.moverAbajo() }
        keyboard.a().onPressDo { personajePrincipal.moverIzquierda() }
        keyboard.d().onPressDo { personajePrincipal.moverDerecha() }
         
        keyboard.e().onPressDo { personajePrincipal.interactuar() } 
        keyboard.v().onPressDo { personajePrincipal.atacar() }      
    }
    
    method perder() {
        game.say(personajePrincipal, "¡He perdido!")
        game.schedule(2000, { game.stop() })
    }
    method ganar() {
        game.clear()
        
        game.addVisual(pantallaVictoria)
        
        game.schedule(5000, { 
            self.reiniciarJuego() 
        })
    }
    method reiniciarJuego() {
        game.clear()
        
        personajePrincipal.resetearEstado()
        personajePrincipal.position(game.at(8, 3)) 
        
        estado = 0
        
        game.boardGround("Mazmorra.png")
        
        self.iniciar()
    }
    
}

object pantallaInicio {
    method position() = game.at(0,0)
    method image() = "inicio.png"  
}

object pantallaInstrucciones {
    method position() = game.at(0,0)
    method image() = "instrucciones.png" 
}

object pantallaVictoria {
    method position() = game.at(0,0)
    method image() = "victoria.png" 
    }






