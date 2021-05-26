struct proton {
    var text = "[swift] Hello proton text!"
}

func sayHelloSwift(name: String) -> Int {
    print("[swift] Hello from proton lib: \(name)")
    
    return 0
}


@_cdecl("sayHello")
public func sayHello(namePtr: UnsafePointer<CChar>?) -> Int {
    // Creates a new string by copying the null-terminated UTF-8 data (C String)
    // referenced by the given pointer.
    let name = String(cString: namePtr!)
    return sayHelloSwift(name: name)
}


import Cocoa
import SwiftUI
import WebKit

//import ModuleXObjC
import Swift




class AppMenu : NSMenu {
    override init(title: String) {
        super.init(title: title)
        
        let appMenu = NSMenuItem()
        appMenu.submenu = NSMenu()
        let appName = ProcessInfo.processInfo.processName
        appMenu.submenu?.addItem(NSMenuItem(title: "About \(appName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
        appMenu.submenu?.addItem(NSMenuItem.separator())
        let services = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        //        self.servicesMenu = NSMenu()
        //        services.submenu = self.servicesMenu
        appMenu.submenu?.addItem(services)
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(NSMenuItem(title: "Hide \(appName)", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"))
        let hideOthers = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthers.keyEquivalentModifierMask = [.command, .option]
        appMenu.submenu?.addItem(hideOthers)
        appMenu.submenu?.addItem(NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: ""))
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(NSMenuItem(title: "Quit \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        let fileMenu = NSMenuItem()
        fileMenu.submenu = NSMenu(title: "File")
        fileMenu.submenu?.addItem(NSMenuItem(title: "New", action: #selector(NSDocumentController.newDocument(_:)), keyEquivalent: "n"))
        fileMenu.submenu?.addItem(NSMenuItem(title: "Open", action: #selector(NSDocumentController.openDocument(_:)), keyEquivalent: "o"))
        fileMenu.submenu?.addItem(NSMenuItem.separator())
        fileMenu.submenu?.addItem(NSMenuItem(title: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"))
        fileMenu.submenu?.addItem(NSMenuItem(title: "Save…", action: #selector(NSDocument.save(_:)), keyEquivalent: "s"))
        fileMenu.submenu?.addItem(NSMenuItem(title: "Revert to Saved", action: #selector(NSDocument.revertToSaved(_:)), keyEquivalent: ""))
        
        let editMenu = NSMenuItem()
        editMenu.submenu = NSMenu(title: "Edit")
        editMenu.submenu?.addItem(NSMenuItem(title: "Undo", action: Selector(("undo:")), keyEquivalent: "z"))
        editMenu.submenu?.addItem(NSMenuItem(title: "Redo", action: Selector(("redo:")), keyEquivalent: "Z"))
        editMenu.submenu?.addItem(NSMenuItem.separator())
        editMenu.submenu?.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.submenu?.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.submenu?.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.submenu?.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        
        let windowMenu = NSMenuItem()
        windowMenu.submenu = NSMenu(title: "Window")
        windowMenu.submenu?.addItem(NSMenuItem(title: "Minmize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"))
        windowMenu.submenu?.addItem(NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""))
        windowMenu.submenu?.addItem(NSMenuItem.separator())
        windowMenu.submenu?.addItem(NSMenuItem(title: "Show All", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "m"))
        
        //         let mainMenu = NSMenu(title: "Main Menu")
        //         mainMenu.addItem(appMenu)
        //         mainMenu.addItem(fileMenu)
        //         mainMenu.addItem(editMenu)
        //         mainMenu.addItem(windowMenu)
        // //        return mainMenu
        
        
        let menuItemOne = NSMenuItem()
        menuItemOne.submenu = NSMenu(title: "menuItemOne")
        menuItemOne.submenu?.items = [NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")]
        items = [appMenu, fileMenu, editMenu, windowMenu]
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

@available(macOS 10.15, *)
class AppDelegate: NSObject, NSApplicationDelegate, WKScriptMessageHandler, WKScriptMessageHandlerWithReply {
    var title: String = ProcessInfo.processInfo.processName
    var contentPath: String = ""
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage){
        print("[swift] WKScriptMessageHandler callback called, name: \(message.name) with body: \(message.body)")
    }

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage,
                               replyHandler: @escaping (Any?, String?) -> Void) {
        print("[swift] WKScriptMessageHandlerWithReply callback called, name: \(message.name) with body: \(message.body)")
        DispatchQueue.global(qos: .userInitiated).async {
            print("[swift] This is run on a background queue")
            let result2 = prtn_invoke_function_through_dispatcher(name: message.name, param: message.body as! String)

            DispatchQueue.main.async {
                print("[swift] This is run on the main queue, after the previous code in outer block")
                replyHandler("hello with reply \(result2)", nil)
                }
        }
    }

    var window: NSWindow!
    var statusBarItem: NSStatusItem!
    var webview: WKWebView!
    
    @objc func Login() {
        print("Login...done")
    }
    
    @objc func Logout() {
        print("Logout...done")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        print("in applicationShouldTerminateAfterLastWindowClosed")
        NSApplication.shared.stop(self)
        return false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("in applicationWillTerminate")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 640, height: 480),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.cascadeTopLeft(from: NSPoint(x: 20, y: 20))
        window.title = title
        //        window.contentView = NSHostingView(rootView: ContentV)
        window.makeKeyAndOrderFront(nil)
        
        
        let userContentController = WKUserContentController()
        //        userContentController.add(self, name: "test")
        userContentController.add(
            self,
            name: "test2")
        
        userContentController.add(
            self,
            name: "sleep")
        
        let scriptSource = "window.webkit.messageHandlers.test2.postMessage(\"Hello from swift applicationDidFinishLaunching!\");"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        userContentController.addUserScript(script)
        
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey:"developerExtrasEnabled")
        config.userContentController = userContentController
        
        webview = WKWebView(frame: .zero, configuration: config)
        
        do {
//            let contents = try String(contentsOfFile: "/Users/iokulist/Github/okigan/proton/protonui/dist/index.html")
            let contents = try String(contentsOfFile: contentPath)
            // print(contents)
            webview.loadHTMLString(contents, baseURL: URL(string: ""))
            //            url = URL(string: "data:text/html," + contents)
        } catch {
            let url = URL(string: "https://www.apple.com")
            let request = URLRequest(url: url!)
            webview.load(request)
        }
        window.contentView = webview
        webview.evaluateJavaScript(    "cosole.log(\"hello from swift\")")
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"
        
        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "Login",
            action: #selector(AppDelegate.Login),
            keyEquivalent: "a")
        
        statusBarMenu.addItem(
            withTitle: "Logout",
            action: #selector(AppDelegate.Logout),
            keyEquivalent: "b")
        
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}

    
let app = NSApplication.shared

let delegate = AppDelegate()

@available(macOS 11, *)
func main(_ title:String) -> Int {
    
    autoreleasepool {
        delegate.title = title
 //       delegate.contentPath = "/Users/iokulist/Github/okigan/proton/protonui/dist/index.html"
        let menu = AppMenu()
        app.mainMenu = menu
        app.delegate = delegate
        
        app.setActivationPolicy(.regular)
        app.run()
    }
    return 0
}

@_cdecl("startApp")
public func startApp(namePtr: UnsafePointer<CChar>?) -> Int {
    let name = String(cString: namePtr!)

    return main(name)
}

@_cdecl("setContentPath")
public func setContentPath(contentPathPtr: UnsafePointer<CChar>?) -> Int {
    delegate.contentPath = String(cString: contentPathPtr!)

    return 0
}
