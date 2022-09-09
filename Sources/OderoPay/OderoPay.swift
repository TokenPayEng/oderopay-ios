import Foundation
import CryptoKit

public struct OderoPay {
    static private var environment = APIGateway.SANDBOX
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
    
    static public func setEnvironment(to environment: APIGateway) {
        self.environment = environment
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
    
    static private func generateSignature(for url: String, body: String) throws -> String {
        guard !randomKey.isEmpty else { throw CheckoutError.emptyRandomKey }
        let concatenatedString = url + apiKey + secretKey + randomKey + body
        let str = "https://api-gateway.tokenpay.com.tr/onboarding/v1/sub-merchants/1key-1FooBar123!Xa15Fp11T"
        let sha256hash = SHA256.hash(data: Data(concatenatedString.utf8))
        let testhash = SHA256.hash(data: Data(str.utf8))
        print(testhash)
        print(testhash.hashValue)
        print(testhash.description)
        return sha256hash.description.data(using: .utf8)!.base64EncodedString().uppercased()
    }
    
    static internal func sendCheckoutForm() async throws -> CheckoutFormResult {
        let url = URL(string: APIGateway.SANDBOX.rawValue + Path.CHECKOUT.rawValue + Action.INIT.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.checkoutForm)
        request.httpBody = encodedBody
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String(data: request.httpBody!, encoding: .utf8)!)
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        return try JSONDecoder().decode(CheckoutFormResult.self, from: data)
    }

    static internal func retrieveInstallments(for binNumber: String, withPrice price: Double, in currency: Currency) async throws -> RetrieveInstallmentResult {
        let url = URL(string: environment.rawValue + Path.RETRIEVE_INSTALLMENTS.rawValue)!
        var urlComponents = URLComponents(string: environment.rawValue + Path.RETRIEVE_INSTALLMENTS.rawValue)!
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
        let url = URL(string: environment.rawValue + Path.CHECKOUT.rawValue + Action.COMPLETE.rawValue)!
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
