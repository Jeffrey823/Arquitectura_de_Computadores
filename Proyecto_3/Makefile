ASM = tank.asm
COM = tank.com

# Colocar la ruta en la que se instaló nasm.exe y DOSBox.exe:
NASM = "C:\Users\usrnm\AppData\Local\bin\NASM\nasm.exe"
DOSBOX = "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe"

all: $(COM)
	$(DOSBOX) $(COM)

$(COM): $(ASM)
	$(NASM) -f bin -o $(COM) $(ASM)

clean:
	rm $(COM)

# nasm -f bin tank.asm -o tank.com