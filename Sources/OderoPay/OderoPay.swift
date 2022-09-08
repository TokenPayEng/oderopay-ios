import Foundation
import CommonCrypto

public struct OderoPay {
    static private var apiKey = String()
    static private var secretKey = String()
    static private var randomKey = String()
    static private var token = String()
    
    static private var checkoutForm = CheckoutForm()
    static private var completePaymentForm = CompletePaymentForm()
    
    static private var asWebView: Bool = false
    
    static internal func assignRetrievedToken(withValue token: String) {
        self.token = token
    }
    
    static public func authorizeWithKeys(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    static internal func assignRandomKey(using key: String) {
        self.randomKey = key
    }
    
    static internal func areKeysProvided() -> Bool {
        !self.apiKey.isEmpty || !self.secretKey.isEmpty
    }
    
    static internal func getKeys() -> (String, String) {
        (self.apiKey, self.secretKey)
    }
    
    static internal func isAsWebView() -> Bool {
        self.asWebView
    }
    
    static public func changeToWebView(_ value: Bool) {
        self.asWebView = value
    }
    
    static internal func isCheckoutFormReady() -> Bool {
        OderoPay.checkoutForm.isReady()
    }
    
    static public func setCheckoutForm(to form: CheckoutForm) {
        OderoPay.checkoutForm.setCheckoutForm(to: form)
    }
    
    static internal func getCheckoutForm() -> CheckoutForm {
        OderoPay.checkoutForm
    }
    
    static internal func setCompletePaymentForm(to form: CompletePaymentForm) {
        OderoPay.completePaymentForm = form
    }
    
    static internal func getCompletePaymentForm() -> CompletePaymentForm {
        OderoPay.completePaymentForm
    }
    
    static internal func sendCheckoutForm() async throws -> CheckoutFormResult {
        let url = URL(string: APIGateway.LOCAL.rawValue + Path.CHECKOUT.rawValue + Action.INIT.rawValue)!
        var request = URLRequest(url: url)
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String())
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.checkoutForm)
        request.httpBody = encodedBody
        
        print(request.url)
        print(request.allHTTPHeaderFields)
        print(String(data: request.httpBody!, encoding: .utf8))
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        return try JSONDecoder().decode(CheckoutFormResult.self, from: data)
    }
    
    static private func generateSignature(for url: String, body: String) throws -> String {
        guard !randomKey.isEmpty else { throw CheckoutError.emptyRandomKey }
        let concatenatedString = url + apiKey + secretKey + randomKey + body
        return concatenatedString.toSha256().toBase64().uppercased()
    }

    static internal func retrieveInstallments(for binNumber: String, withPrice price: Double, in currency: Currency) async throws -> RetrieveInstallmentResult {
        let url = URL(string: APIGateway.LOCAL.rawValue + Path.RETRIEVE_INSTALLMENTS.rawValue)!
        var urlComponents = URLComponents(string: APIGateway.LOCAL.rawValue + Path.RETRIEVE_INSTALLMENTS.rawValue)!
        urlComponents.queryItems = [
            URLQueryItem(name: "binNumber", value: binNumber),
            URLQueryItem(name: "price", value: String(price)),
            URLQueryItem(name: "currency", value: currency.rawValue)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String())
        
        // method
        request.httpMethod = HTTPMethod.GET.rawValue
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        return try JSONDecoder().decode(RetrieveInstallmentResult.self, from: data)
    }
    
    static internal func sendCompletePaymentForm() async throws -> CompletePaymentFormResult {
        let url = URL(string: APIGateway.LOCAL.rawValue + Path.CHECKOUT.rawValue + Action.COMPLETE.rawValue)!
        var request = URLRequest(url: url)
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String())
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        request.setValue(token, forHTTPHeaderField: "x-token")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.completePaymentForm)
        request.httpBody = encodedBody
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        print(data)
        return try JSONDecoder().decode(CompletePaymentFormResult.self, from: data)
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
    func data(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
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
