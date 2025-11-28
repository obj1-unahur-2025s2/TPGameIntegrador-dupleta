import wollok.game.*
import juego.*

class Personaje {
    var property position = game.at(0,0)

    const puntosDeSaludInicial = 100
    var danioRecibido = 0 
    
    const fuerzaInicial
    const agilidadInicial

    method vidaMaxima() { return puntosDeSaludInicial } 
    method fuerzaTotal() { return fuerzaInicial }
    method agilidadTotal() { return agilidadInicial }

    method vidaActual() {
        return (self.vidaMaxima() - danioRecibido).max(0)
    }
    
    method tieneVida() {
        return self.vidaActual() > 0
    }

    method atacarA(unEnemigo) {
        if (self.agilidadTotal() >= unEnemigo.agilidadTotal()) {
            game.say(self, "¡Soy más rápido!")
            unEnemigo.recibirDanioDe(self)
            if (unEnemigo.tieneVida()) {
                self.recibirDanioDe(unEnemigo)
            } else {
                game.say(self, "¡Lo eliminé sin recibir daño!")
            }
        } else {
            game.say(unEnemigo, "¡Soy más rápido!")
            self.recibirDanioDe(unEnemigo)
            if (self.tieneVida()) {
                unEnemigo.recibirDanioDe(self)
            } else {
                 game.say(self, "Me mató antes de atacar...")
            }
        }
    }

  
    method recibirDanio(cantidad) {
        danioRecibido += cantidad
        if (!self.tieneVida()) {
             self.morir()
        }
    }

    
    method recibirDanioDe(atacante) {
        self.recibirDanio(atacante.fuerzaTotal())
    }   

    method reiniciarVida() {
        danioRecibido = 0
    }

    method morir() {
        game.removeVisual(self)
    }
    
  
    method image() 
    
    method reaccionar(unPersonaje) {
        self.atacarA(unPersonaje) 
    }
}


class Caballero inherits Personaje {
    const objetosEnMochila = []
      
    method moverArriba() { 
        const destino = position.up(1) 
        if (self.esZonaCaminable(destino)) { 
            position = destino 
        }
    }

    method moverAbajo() { 
        const destino = position.down(1)
        if (self.esZonaCaminable(destino)) {
            position = destino
        }
    }

    method moverDerecha() { 
        const destino = position.right(1)
        if (self.esZonaCaminable(destino)) {
            position = destino
        }
    }

    method moverIzquierda() { 
        const destino = position.left(1)
        if (self.esZonaCaminable(destino)) {
            position = destino
        }
    }

    method resetearEstado() {
        self.reiniciarVida()      
        objetosEnMochila.clear()   
    }
    method atacar() {
        const enemigos = game.colliders(self)
        
        if(enemigos.isEmpty()) {
            game.say(self, "¡Al aire!")
        } else {
            enemigos.forEach { enemigo => 
                self.atacarA(enemigo) 
            }
        }
    }

    method interactuar() {
        const objetos = game.colliders(self)
        if (!objetos.isEmpty()) {
            objetos.first().reaccionar(self)
        }
    }

    method recogerObjeto(unObjeto) {
        objetosEnMochila.add(unObjeto)
        game.say(self, "¡Equipado!")
    }

    method esZonaCaminable(unaPosicion) {
        const x = unaPosicion.x()
        const y = unaPosicion.y()

        const enPasilloVertical = x.between(6, 9) && y.between(1, 10)
        const enPasilloHorizontal = x.between(1, 14) && y.between(4, 6) 

        return enPasilloVertical || enPasilloHorizontal
    }

    override method vidaMaxima() {
        return super() + objetosEnMochila.sum({ o => o.saludQueAporta() })
    }
    override method fuerzaTotal() {
        return super() + objetosEnMochila.sum({ o => o.fuerzaQueAporta() })
    }
    override method agilidadTotal() {
        return super() + objetosEnMochila.sum({ o => o.agilidadQueAporta() })
    }
    
    override method image() = "caballero.png"

    override method morir() {
        super() 
        juego.perder() 
    }
}

class Enemigo inherits Personaje {
    method objetoQueSuelta() 
    
    override method morir() {
        super()
        self.objetoQueSuelta().dropearObjeto(self.position())
    }
    
    override method reaccionar(personaje) {
        game.say(self, "¡Grrr!") 
    }
}

class Esqueleto inherits Enemigo {
    override method image() = "esqueleto.png"
    override method objetoQueSuelta() = huesos
}

class Lobo inherits Enemigo {
    override method image() = "lobo.png"
    override method objetoQueSuelta() = garras
}

class Vampiro inherits Enemigo {
    override method image() = "vampiro.png"
    override method objetoQueSuelta() = sangreDeVampiro
}

class VampiroJefe inherits Vampiro {
    override method image() = "vampiro.png" 
    override method morir() {
        game.removeVisual(self) 
        juego.ganar()
    }
}

object huesos {
    method fuerzaQueAporta() = 10
    method agilidadQueAporta() = 0
    method saludQueAporta() = 30
    method image() = "hueso.png"             
    var property position = game.at(0,0)     

    method dropearObjeto(posicion) {
        self.position(posicion) 
        game.addVisual(self)
    }
    method reaccionar(personaje) {
        personaje.recogerObjeto(self)
        game.removeVisual(self)
    }
}

object garras {
    method fuerzaQueAporta() = 30
    method agilidadQueAporta() = 10
    method saludQueAporta() = 0
    method image() = "garras.png"             
    var property position = game.at(0,0)  
    
    method dropearObjeto(posicion) {
        self.position(posicion) 
        game.addVisual(self)
    }
    method reaccionar(personaje) {
        personaje.recogerObjeto(self)
        game.removeVisual(self)
    }   
}

object sangreDeVampiro {
    method fuerzaQueAporta() = 0
    method agilidadQueAporta() = 30
    method saludQueAporta() = 10
    method image() = "sangrevampiro.png"    
    var property position = game.at(0,0)     

    method dropearObjeto(posicion) {
        self.position(posicion) 
        game.addVisual(self)
    }
    method reaccionar(personaje) {
        personaje.recogerObjeto(self)
        game.removeVisual(self)
    }
}

class Puerta {
    var property position
    method image() = "puerta.png"
    
    method reaccionar(personaje) {
        game.say(personaje, "¡Avanzando!")
        juego.pasarANivel2()
    }
}

object barraVida {
    
    method position() = game.at(0, 10) 
    method image() {
        const vida = juego.personaje().vidaActual()
        if (vida == 100) {
            return "barra100.png"
        } else if (vida >= 75) {
            return "barra75.png"
        } else if (vida >= 50) {
            return "barra50.png"
        } else if (vida >= 1) {
            return "barra25.png"
        } else {
            return "barra0.png"
        }
    }
}