package proton

/*
#include <stdio.h>
#include <stdlib.h>

#include "../proton-backend-cocoa/Sources/proton-backend-cocoa/proton_crafted.h"

#cgo LDFLAGS: -L../proton-backend-cocoa/.build/x86_64-apple-macosx/debug -lproton-backend-cocoa
#cgo darwin LDFLAGS: -L/usr/lib/swift/
#cgo darwin LDFLAGS: -framework Foundation
#cgo darwin LDFLAGS: -framework WebKit

extern prtn_fun_ptr go_callback_proxy_go_type_workaround;
*/
import "C"
import (
	"fmt"
	"time"
	"unsafe"

	"github.com/mattn/go-pointer"
)

func registerCallback(name string, callback func(v string) (int, string)) int {
	cName := C.CString(name)
	defer C.free(unsafe.Pointer(cName))

	result := C.prtn_register_function_callback_with_dispatcher(
		cName,
		C.go_callback_proxy_go_type_workaround,
		pointer.Save(callback),
	)

	return int(result)
}

func Hello() string {
	str := "Hello, world."
	print(str, "\n")
	return str
}

//export goCallbackDispatcher
func goCallbackDispatcher(v unsafe.Pointer, param *C.char) *C.char {
	print("[golang] in go_callback_proxy\n")

	go_callback := pointer.Restore(v).(func(string) (int, string))
	go_param := C.GoString(param)
	_, s := go_callback(go_param)
	print("[golang] completed callback call\n")
	return C.CString(s)
}

type ProtonApp interface {
	Run()
	Destroy()
	SetTitle(path string)
	SetContentPath(path string)
	Bind(name string, callback func(string) string)
	AddMenuExtra(name string)
	//	SetTitle(title string)
}

type protonSwiftAppHandle struct {
	ContentPath string
	Title       string
}

func New() ProtonApp {
	handle := protonSwiftAppHandle{}
	handle.ContentPath = "unset content path"

	return &handle
}

func (handle *protonSwiftAppHandle) Destroy() {
}

func (handle *protonSwiftAppHandle) Run() {
	cTitle := C.CString(handle.Title)
	defer C.free(unsafe.Pointer(cTitle))

	cContentPath := C.CString(handle.ContentPath)
	defer C.free(unsafe.Pointer(cContentPath))

	C.setTitle(cTitle)
	C.setContentPath(cContentPath)

	result := C.startApp()
	fmt.Println("[golang]", time.Now().Format("2006-01-02 15:04:05"), "proton app exit code: ", result)
}

func (handle *protonSwiftAppHandle) SetContentPath(path string) {
	fmt.Println("[golang] in", "SetContentPath", path)
	handle.ContentPath = path
}

func (handle *protonSwiftAppHandle) SetTitle(title string) {
	fmt.Println("[golang] in", "SetTitle", title)
	handle.Title = title
}

func (handle *protonSwiftAppHandle) Bind(name string, callback func(string) string) {
	registerCallback(name, func(v string) (int, string) {
		result := callback(v)
		return 0, result
	})

	cName := C.CString(name)
	defer C.free(unsafe.Pointer(cName))
	C.bindCallback(cName)
}

func (handle *protonSwiftAppHandle) AddMenuExtra(name string) {
	cName := C.CString(name)
	defer C.free(unsafe.Pointer(cName))
	C.addMenuExtra(cName)
}
