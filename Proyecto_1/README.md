# Proyecto 1: Blackjack

Juego de Blackjack (21) contra el repartidor, programado en ensamblador x86.

## Ejecución

El juego se ejecuta desde el emulador **EMU8086**. En este se puede abrir el archivo `.asm` o el `.exe`.

## Cómo jugar

**Menú de inicio**

- `0`: Salir del programa.
- `1` o cualquier otra tecla: Iniciar una partida.

**Durante la partida**

- `0`: Quedarse (dejar de pedir cartas).
- `1` o cualquier otra tecla: Pedir otra carta.

**Al finalizar**

La partida termina cuando el jugador y el repartidor ya no pueden o dejan de pedir cartas, o cuando alguno llega a 21. En ese punto:

1. Presionar cualquier tecla para ver la pantalla de puntuación.
2. Presionar cualquier tecla de nuevo para volver al menú de inicio.

> **Nota:** la carta de valor 10 se muestra como `T`.

## Reglas

- Si el jugador o el repartidor tiene un As, se elige automáticamente el valor que más le convenga (11 o 1).

**Puntaje mayor a 21**

- Pierde automáticamente quien se pase de 21.

**Puntaje igual a 21**

- Gana quien consiga un Blackjack.
- Si ambos tienen 21 (sin Blackjack), gana el repartidor.

**Puntaje menor a 21**

- Gana quien tenga el mayor puntaje.
- Si hay empate, gana el repartidor.

## Autor

Jeffrey Salas Quiel