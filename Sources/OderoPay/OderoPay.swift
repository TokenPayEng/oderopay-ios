import Foundation
import CryptoKit

public struct OderoPay {
    static private var environment = Environment.SANDBOX_AZ.getBaseURL()
    static private var apiKey = String()
    static private var secretKey = String()
    static private var randomKey = String()
    static private var token = String()
    static private var iOSHeader = String("IOSMOBILSDK")
    
    static private var asWebView: Bool = false
    
    static private var singleCardPaymentEnabled: Bool = true
    static private var multipleCardsPaymentEnabled: Bool = true
    static private var tokenFlexPaymentEnabled: Bool = false
    
    static private var checkoutForm = CheckoutForm()
    static private var completePaymentForm = CompletePaymentForm()
    
    static private var paymentCompleted: Bool = false
    
    static internal func setPaymentStatus(to status: Bool) {
        self.paymentCompleted = status
    }
    
    static internal func isPaymentCompleted() -> Bool {
        self.paymentCompleted
    }
    
    // single card toggle
    static internal func isSingleCardPaymentEnabled() -> Bool {
        self.singleCardPaymentEnabled
    }
    
    static public func enableSingleCardPayment() {
        self.singleCardPaymentEnabled = true
    }
    
    static public func disableSingleCardPayment() {
        self.singleCardPaymentEnabled = false
    }
    
    // multiple cards toggle
    static internal func isMultipleCardsPaymentEnabled() -> Bool {
        self.multipleCardsPaymentEnabled
    }
    
    static public func enableMultipleCardsPayment() {
        self.multipleCardsPaymentEnabled = true
    }
    
    static public func disableMultipleCardsPayment() {
        self.multipleCardsPaymentEnabled = false
    }
    
    //  token flex toggle
    static internal func isTokenFlexPaymentEnabled() -> Bool {
        self.tokenFlexPaymentEnabled
    }
    
    static public func enableTokenFlexPayment() {
        self.tokenFlexPaymentEnabled = true
    }
    
    static public func disableTokenFlexPayment() {
        self.tokenFlexPaymentEnabled = false
    }
    
    static internal func assignRetrievedToken(withValue token: String) {
        self.token = token
    }
    
    static public func authorizeWithKeys(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    static public func setEnvironment(to environment: Environment) {
        self.environment = environment.getBaseURL()
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
        print(concatenatedString)
        let hmac_md5 = concatenatedString.hmac(algorithm: .sha512, key: secretKey)
        return hmac_md5
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
        request.setValue(iOSHeader, forHTTPHeaderField: "x-channel")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        return try JSONDecoder().decode(CheckoutFormResult.self, from: data)
    }

    static internal func retrieveInstallments(for binNumber: String, withPrice price: Double, in currency: Currency) async throws -> RetrieveInstallmentResult {
        var urlComponents = URLComponents(string: environment.getOOS() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.INSTALLMENTS.rawValue)!
        urlComponents.queryItems = [
            URLQueryItem(name: "binNumber", value: binNumber),
            // URLQueryItem(name: "walletPrice", value: String(price)),
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        // generate signature
        let signature = try generateSignature(for: urlComponents.url!.absoluteString, body: String())
        
        // method
        request.httpMethod = HTTPMethod.GET.rawValue
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        request.setValue(token, forHTTPHeaderField: "x-token")
        request.setValue(iOSHeader, forHTTPHeaderField: "x-channel")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        return try JSONDecoder().decode(RetrieveInstallmentResult.self, from: data)
    }
    
    static internal func sendCompletePaymentForm() async throws -> CompletePaymentFormResult {
        let url = URL(string: environment.getOOS() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.COMPLETE.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.completePaymentForm)
        request.httpBody = encodedBody
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String(data: request.httpBody!, encoding: .utf8)!)
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        request.setValue(token, forHTTPHeaderField: "x-token")
        request.setValue(iOSHeader, forHTTPHeaderField: "x-channel")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        print(String(data: data, encoding: .utf8) as Any)
        return try JSONDecoder().decode(CompletePaymentFormResult.self, from: data)
    }
    
    static internal func sendComplete3DSPaymentForm() async throws -> CompletePaymentFormResult {
        let url = URL(string: environment.getOOS() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.THREEDS_INIT.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.completePaymentForm)
        request.httpBody = encodedBody
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String(data: request.httpBody!, encoding: .utf8)!)
        
        // header custom
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(randomKey, forHTTPHeaderField: "x-rnd-key")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue("V1", forHTTPHeaderField: "x-auth-version")
        request.setValue(token, forHTTPHeaderField: "x-token")
        request.setValue(iOSHeader, forHTTPHeaderField: "x-channel")
        
        // header default
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send request
        let (data, _) = try await URLSession.shared.data(with: request)
        print(String(data: data, encoding: .utf8) as Any)
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
