package main

import (
	"unsafe"
)

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
	var _ unsafe.Pointer
	halt()
}

func main() {}
