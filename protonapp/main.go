package main

import (
	"fmt"
	"os"

	proton "github.com/okigan/proton/blob/master/proton/proton"
)

func callbacktest(param string) string {
	fmt.Sprintln("[golang] in %s: %s", "callbacktest", param)
	return "Done"
}

func main() {
	if len(os.Args) == 2 && os.Args[1] == "--self-test" {
		print("self test complete.\n")
		return
	}

	p := proton.New()
	p.SetContentPath("../protonappui/dist/index.html")
	p.Bind("test2", callbacktest)
	defer p.Destroy()
	// w.SetTitle("Minimal webview example")
	// w.SetSize(800, 600, webview.HintNone)
	// w.Navigate("https://en.m.wikipedia.org/wiki/Main_Page")
	p.Run()
}
