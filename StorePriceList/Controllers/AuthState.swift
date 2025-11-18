import Foundation
import Combine
import Security

final class AuthState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentEmail: String? = nil
    @Published var currentName: String? = nil
    private let defaults = UserDefaults.standard
    private let rememberKey = "rememberMeEnabled"
    private let emailKey = "rememberEmail"
    private let nameKey = "rememberName"
    init() {
        restoreIfRemembered()
    }
    func login(email: String, name: String) {
        currentEmail = email
        currentName = name
        isLoggedIn = true
    }
    func rememberSession(email: String, name: String, password: String) {
        defaults.set(true, forKey: rememberKey)
        defaults.set(email, forKey: emailKey)
        defaults.set(name, forKey: nameKey)
        KeychainHelper.shared.save(service: "StorePriceList", account: email, data: Data(password.utf8))
    }
    func clearRememberedSession() {
        defaults.set(false, forKey: rememberKey)
        defaults.removeObject(forKey: emailKey)
        defaults.removeObject(forKey: nameKey)
        if let savedEmail = defaults.string(forKey: emailKey) {
            KeychainHelper.shared.delete(service: "StorePriceList", account: savedEmail)
        }
    }
    func restoreIfRemembered() {
        if defaults.bool(forKey: rememberKey) {
            let savedEmail = defaults.string(forKey: emailKey)
            let savedName = defaults.string(forKey: nameKey)
            if let savedEmail, let savedName {
                currentEmail = savedEmail
                currentName = savedName
                isLoggedIn = true
            }
        }
    }
    func savedPasswordForRememberedEmail() -> String? {
        guard defaults.bool(forKey: rememberKey), let email = defaults.string(forKey: emailKey) else { return nil }
        if let data = KeychainHelper.shared.read(service: "StorePriceList", account: email) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    func logout() {
        isLoggedIn = false
        currentEmail = nil
        currentName = nil
        if !defaults.bool(forKey: rememberKey) {
            clearRememberedSession()
        }
    }
}


