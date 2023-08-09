LD = ld

BUILDDIR = build
KERNEL = $(BUILDDIR)/s-os.elf

LDFLAGS = -nostdlib -static -m elf_x86_64 -T src/link.ld
GOFLAGS = -gcflags=github.com/miguelrcborges/simple-os=-std \
	-ldflags=" \
		-linkmode external \
		-extld '$(LD)' \
		-extldflags '$(LDFLAGS)' \
	"


SRCFILES := $(shell find -L src -type f -name '*.go')

.PHONY: kernel

kernel: $(BUILDDIR) $(KERNEL)
$(BUILDDIR):
	mkdir $@

$(KERNEL): $(SRCFILES)
	cd src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOAMD64=v1 go build $(GOFLAGS) -o ../$@