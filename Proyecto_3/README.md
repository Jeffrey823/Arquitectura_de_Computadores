# Proyecto 3: Battle City

Recreación del juego Battle City programada en ensamblador x86 (NASM) y ejecutada en DOSBox.

## Instalación y uso (Windows)

1. Instalar Make desde la línea de comandos:
   ```
   winget install ezwinports.make
   ```
2. Instalar [DOSBox 0.74-3](https://sourceforge.net/projects/dosbox/files/dosbox/0.74-3/DOSBox0.74-3-win32-installer.exe/download) (se puede instalar cualquier versión de DOSBox, siempre que sea compatible).
3. Instalar [NASM 3.01](https://www.nasm.us/pub/nasm/releasebuilds/3.01/win64/nasm-3.01-installer-x64.exe) (se puede instalar cualquier versión de NASM, siempre que sea compatible).
4. En el `Makefile`, colocar la ruta de `nasm.exe` en la variable `NASM`.
5. En el `Makefile`, colocar la ruta de `dosbox.exe` en la variable `DOSBOX`.
6. Cerrar la terminal y reiniciar VS Code para que se actualice el PATH, luego abrir una terminal nueva.
7. Ubicarse en la carpeta donde está el `Makefile`.
8. Ejecutar:
   ```
   make all
   ```

## Cómo jugar

| Tecla | Acción |
|-------|--------|
| `ENTER` | Iniciar el juego (en el menú) |
| `1` | Iniciar el modo infinito (en el menú) |
| Flechas | Mover el tanque |
| `SPACE` | Disparar |
| `ESC` | Ir al menú (en el juego) / salir (en el menú) |

**Objetivo:** Eliminar a todos los tanques enemigos antes de perder las 3 vidas.

## Modos de juego

- **Modo normal:** Hay 9 tanques enemigos en total; si se eliminan todos, se gana.
- **Modo infinito:** Los tanques enemigos aparecen sin límite.

## Notas

- En el centro hay un token que debería ser protegido, pero en esta versión es solo decorativo.

## Autor

Jeffrey Salas Quiel