import Foundation
import CommonCrypto

public struct OderoPay {
    static private var apiKey = String()
    static private var secretKey = String()
    static private var randomKey = String()
    
    static private var checkoutForm = CheckoutForm()
    
    static public func authorizeWithKeys(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    static public func assignRandomKey(using key: String) {
        self.randomKey = key
    }
    
    static func areKeysProvided() -> Bool {
        !self.apiKey.isEmpty || !self.secretKey.isEmpty
    }
    
    static func getKeys() -> (String, String) {
        (self.apiKey, self.secretKey)
    }
    
    static public func isCheckoutFormReady() -> Bool {
        OderoPay.checkoutForm.isReady()
    }
    
    static public func setCheckoutForm(to form: CheckoutForm) {
        OderoPay.checkoutForm.setCheckoutForm(to: form)
    }
    
    static public func getCheckoutForm() -> CheckoutForm {
        OderoPay.checkoutForm
    }
    
    static public func sendCheckoutForm() async throws -> CheckoutFormResult {
        let url = URL(string: APIGateway.LOCAL.rawValue + Path.CHECKOUT.rawValue + Action.INIT.rawValue)!
        
//        let encoded = try JSONEncoder().encode(OderoPay.checkoutForm)
//        let json = try JSONSerialization.jsonObject(with: encoded, options: [])
//        guard let jsonString = String(data: encoded, encoding: .utf8) else { throw CheckoutError.invalidRequestBody }
//
//        var components = URLComponents(string: url.absoluteString)!
//        if let object = json as? [String: Any] {
//            components.queryItems = object.compactMap { (key, value) in
//                URLQueryItem(name: key, value: "\(value)")
//            }
//        }
        
        var request = URLRequest(url: url)
        let signature = try generateSignature(for: request.url!.absoluteString, body: String())
        
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(randomKey, forHTTPHeaderField: "x-random-key")
        request.addValue(signature, forHTTPHeaderField: "x-signature")
        request.addValue("1", forHTTPHeaderField: "x-auth-version")
        
        print(request.url!)
        print(request.httpMethod!)
        print(request.allHTTPHeaderFields!)
        //print(request.httpBody)
        
        let (data, _) = try await URLSession.shared.data(from: request.url!)
        print("data returned is \(data)")
        return try JSONDecoder().decode(CheckoutFormResult.self, from: data)
    }
    
    static private func generateSignature(for url: String, body: String) throws -> String {
        guard !randomKey.isEmpty else { throw CheckoutError.emptyRandomKey }
        let concatenatedString = url + apiKey + secretKey + randomKey + body
        print(concatenatedString)
        print(concatenatedString.toSha256().toBase64().uppercased())
        return concatenatedString.toSha256().toBase64().uppercased()
    }
}

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

extension String {
    func toSha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
