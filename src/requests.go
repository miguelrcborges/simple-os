package main

import (
	"github.com/totallygamerjet/limine-go"
)

var framebufferRequest = limine.FramebufferRequest{
	Id: [4]uint64{
		limine.CommonMagic0,
		limine.CommonMagic1,
		limine.FramebufferRequestId2,
		limine.FramebufferRequestId3,
	},
}
