LD = ld
KERNEL = iso_root/s-os.elf
IMAGEDIR = iso
IMAGE = $(IMAGEDIR)/s-os.iso
LIMINE_BIOS_CD = /usr/share/limine/limine-bios-cd.bin
LIMINE_BIOS_SYS = /usr/share/limine/limine-bios.sys
LIMINE_UEFI_CD = /usr/share/limine/limine-uefi-cd.bin


LDFLAGS = -nostdlib -static -m elf_x86_64 -T link.ld
GOFLAGS = -gcflags=github.com/miguelrcborges/simple-os/src=-std \
	-ldflags=" \
		-linkmode external \
		-extld '$(LD)' \
		-extldflags '$(LDFLAGS)' \
	"


SRCFILES := $(shell find -L src -type f -name '*.go')

.PHONY: kernel image clean run

kernel: $(BUILDDIR) $(KERNEL)
$(BUILDDIR):
	mkdir $@

$(KERNEL): $(SRCFILES)
	cd src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOAMD64=v1 go build $(GOFLAGS) -o ../$@


image: $(IMAGEDIR) $(IMAGE)
$(IMAGEDIR):
	mkdir $@

$(IMAGE): kernel iso_root/limine-bios-cd.bin iso_root/limine-bios.sys iso_root/limine-uefi-cd.bin
	xorriso -as mkisofs -b limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-uefi-cd.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o $@ 
	rm iso_root/s-os.elf

iso_root/limine-bios-cd.bin: $(LIMINE_BIOS_CD)
	cp $^ $@

iso_root/limine-uefi-cd.bin: $(LIMINE_UEFI_CD)
	cp $^ $@

iso_root/limine-bios.sys: $(LIMINE_BIOS_SYS)
	cp $^ $@


clean:
	mv iso_root/limine.cfg ..
	rm -rf iso iso_root/*
	mv limine.cfg iso_root


run: image 
	qemu-system-x86_64 -cdrom $(IMAGE) -boot d