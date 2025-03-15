import Foundation

struct Attacher {
    static var runOnce = false
    static func exec() {
        if runOnce { return }
        runOnce = true

        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: Attacher.script)!
        let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
        print("\(error ?? output)")
    }

    static let script = """
        tell application "Safari"
            activate
        end tell
        log "start"
        tell application "System Events"
            tell process "Safari"
                set frontmost to true
                -- Perform user interface scripting tasks
                tell menu "Develop" of menu bar 1
                    click
                    global top_item
                    set top_items to name of every menu item
                    set notFound to true
                    repeat with i in top_items
                        if notFound and (i contains "Simulator" or i contains "MacBook") then
                            set top_item to i
                            set notFound to false
                        end if
                    end repeat
                    
                    log "here"
                    
                    tell menu item top_item
                        click
                        tell menu top_item
                            set notFound to true
                            set menu_items to name of every menu item
                            repeat with i in menu_items
                                log "items " & i
                                if i contains "startpage" then
                                    set notFound to false
                                    click menu item i
                                    log "clicked"
                                end if
                            end repeat
                        end tell
                    end tell
                end tell
            end tell
        end tell
    """
}
