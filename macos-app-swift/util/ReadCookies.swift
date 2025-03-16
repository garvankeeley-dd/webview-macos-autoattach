import WebKit

func readCookies() {
    Task { @MainActor in
        let c = await Globals.store.httpCookieStore.allCookies()
        for cookie in c {
            guard ["ddweb_session_id", "ddweb_token"].contains(where: { cookie.name.contains($0) }) else {
                continue
            }
            
            print("Cookie found: \(cookie.name), \(cookie.value)")
            UserDefaults.standard.set(cookie.value, forKey: cookie.name)
            
            switch cookie.name {
            case "ddweb_session_id":
                Globals.ddweb_session_id = cookie.value
            case "ddweb_token":
                Globals.ddweb_token = cookie.value
            default:
                break
            }
        }
    }
}
