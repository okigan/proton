package main

import (
	"os"

	proton "github.com/okigan/proton/proton"
)

func mycallback1(param string) string {
	println("go lang in", "mycallback1", param)
	return "Done"
}

func mycallback2(param string) string {
	println("go lang] in", "mycallback2", param)
	return "Done"
}

func main() {
	if len(os.Args) == 2 && os.Args[1] == "--self-test" {
		print("self test complete.\n")
		return
	}

	p := proton.New()
	p.SetTitle("Proton App")
	p.SetContentPath("../protonappui/dist/index.html")
	p.Bind("mycallback1", mycallback1)
	p.Bind("mycallback2", mycallback2)
	p.Bind("MenuExtraCallback", mycallback2)
	p.AddMenuExtra("MenuItem1")
	p.AddMenuExtra("MenuItem2")
	defer p.Destroy()
	p.Run()
}
