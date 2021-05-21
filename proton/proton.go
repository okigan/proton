package proton

/*
#include <stdio.h>
#include <stdlib.h>

#include "../proton-swift/Sources/proton/proton_crafted.h"
#cgo LDFLAGS: -L../proton-swift/.build/x86_64-apple-macosx/debug -lproton
#cgo darwin LDFLAGS: -L/usr/lib/swift/
#cgo darwin LDFLAGS: -framework Foundation
#cgo darwin LDFLAGS: -framework WebKit

extern prtn_fun_ptr go_callback_proxy_go_type_workaround;
*/
import "C"
import (
	"fmt"
	"strconv"
	"time"
	"unsafe"

	"github.com/mattn/go-pointer"
)

func register_callback(name string, callback func(v string) (int, string)) int {
	namex := C.CString(name)
	defer C.free(unsafe.Pointer(namex))

	result := C.prtn_register_function_callback_with_dispatcher(
		namex,
		C.go_callback_proxy_go_type_workaround,
		pointer.Save(callback),
	)

	return int(result)
}

func Main() {
	main()
}

func main() {
	value_to_return := 13

	register_callback("test2", func(v string) (int, string) {
		fmt.Println("[golang]", time.Now().Format("2006-01-02 15:04:05"), "hello there xxx", v)
		return value_to_return, "Done"
	})

	register_callback("sleep", func(v string) (int, string) {
		sleepMs, _ := strconv.Atoi(v)

		fmt.Println("[golang]", time.Now().Format("2006-01-02 15:04:05"), "going to sleep", v)
		time.Sleep(time.Duration(sleepMs) * time.Millisecond)
		fmt.Println("[golang]", time.Now().Format("2006-01-02 15:04:05"), "done sleeping", v)
		return value_to_return + value_to_return, "Done"
	})

	name := "test string"
	c_name := C.CString(name)
	defer C.free(unsafe.Pointer(c_name))

	C.sayHello(c_name)
	result := C.startApp(c_name)
	fmt.Println("[golang]", time.Now().Format("2006-01-02 15:04:05"), "proton app exit code: ", result)
}

func Hello() string {
	str := "Hello, world."
	print(str, "\n")
	return str
}

//export go_callback_dispatcher
func go_callback_dispatcher(v unsafe.Pointer, param *C.char) *C.char {
	print("[golang] in go_callback_proxy\n")

	go_callback := pointer.Restore(v).(func(string) (int, string))
	go_param := C.GoString(param)
	_, s := go_callback(go_param)
	print("[golang] complited callback call\n")
	return C.CString(s)
}

type ProtonApp interface {
	Run()
	Destroy()
	SetTitle(title string)
}

type proton_app_handle struct {
}

func New() ProtonApp {
	w := &proton_app_handle{}

	return w
}

func (handle *proton_app_handle) Destroy() {
	// C.webview_destroy(w.w)
}

func (handle *proton_app_handle) Run() {

	main()
}
