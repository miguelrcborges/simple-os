package main

import (
	"unsafe"
)

func main() {}

func halt() {
	for {
	}
}

// Check https://totallygamerjet.hashnode.dev/writing-an-os-in-go-the-bootloader for more info
//
//go:cgo_export_static _start _start
//go:linkname _start _start
//go:nosplit
func _start() {
	framebuffer := framebufferRequest.Response.Framebuffers()[0]

	for y := uint64(0); y < framebuffer.Height; y++ {
		for x := uint64(0); x < framebuffer.Width; x++ {
			position := uintptr(x + y*framebuffer.Pitch)
			*(*int32)(unsafe.Add(framebuffer.Address, position*unsafe.Sizeof(uint32(0)))) = 0xffffff
		}
	}

	halt()
}
