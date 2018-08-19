APP = donkey
ARCH = $(shell uname -m)
BIOS = /usr/share/seabios/bios.bin
#BIOS = OVMF.fd  # EFI
QEMU_OPTS = -cpu SandyBridge -m 2048 -serial mon:stdio -bios $(BIOS)

all: build
	./gen-boot-parted.sh $(APP)-kernel $(APP)-initrd.img

build:
	linuxkit build $(APP).yml

clean:
	sudo losetup -D
	rm -f $(APP)-bios.img $(APP)-cmdline $(APP)-efi.img $(APP)-kernel $(APP)-squashfs.img $(APP)-initrd.img $(APP).img
	rm -rf $(APP)-kernel-state $(APP)-state

run:
	qemu-system-$(ARCH) $(QEMU_OPTS) -drive format=raw,file=$(APP).img
