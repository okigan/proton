package main

import (
	proton "github.com/okigan/proton"
)

func main() {
	// proton.Hello()
	// proton.Main()

	p := proton.New()
	defer p.Destroy()
	// w.SetTitle("Minimal webview example")
	// w.SetSize(800, 600, webview.HintNone)
	// w.Navigate("https://en.m.wikipedia.org/wiki/Main_Page")
	p.Run()
}
