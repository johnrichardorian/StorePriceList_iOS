import Foundation
import SwiftData
import Security

final class KeychainHelper {
    static let shared = KeychainHelper()
    func save(service: String, account: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        SecItemAdd(attributes as CFDictionary, nil)
    }
    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return data
    }
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}

@Model
final class Account {
    @Attribute(.unique) var email: String
    var name: String
    var password: String
    init(email: String, name: String, password: String) {
        self.email = email
        self.name = name
        self.password = password
    }
}

@Model
final class StoreEntity {
    var name: String
    var address: String
    var phone: String
    var email: String
    var zip: String
    var storeDescription: String
    var ownerEmail: String?
    init(name: String, address: String, phone: String, email: String, zip: String, storeDescription: String, ownerEmail: String? = nil) {
        self.name = name
        self.address = address
        self.phone = phone
        self.email = email
        self.zip = zip
        self.storeDescription = storeDescription
        self.ownerEmail = ownerEmail
    }
}


