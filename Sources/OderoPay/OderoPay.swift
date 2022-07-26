import Foundation
import UIKit
import CryptoKit

public struct OderoPay {
    static private var environment = Environment.SANDBOX_AZ
    static private var apiKey = String()
    static private var secretKey = String()
    static private var randomKey = String()
    static private var token = String()
    static private var iOSHeader = String("IOSMOBILSDK")
    
    static private var asWebView: Bool = false
    static private var predefinedScreens: Bool = true
    static private var customSuccessScreenViewController: UIViewController = UIViewController()
    static private var customErrorScreenViewController: UIViewController = UIViewController()
    
    static private var singleCardPaymentEnabled: Bool = true
    static private var multipleCardsPaymentEnabled: Bool = true
    static private var tokenFlexPaymentEnabled: Bool = false
    static private var payByPointsEnabled: Bool = false
    
    static private var priceForFirstMultiCard: Double = 0
    static private var priceForSecondMultiCard: Double {
        OderoPay.checkoutForm.getCheckoutPriceRaw() - priceForFirstMultiCard
    }
    
    static private var checkoutForm = CheckoutForm()
    static private var completePaymentForm = CompletePaymentForm()
    
    static private var paymentCompleted: Bool = false
    static private var multipleCardsPaymentOneCompleted: Bool = false
    static private var multipleCardsPaymentTwoCompleted: Bool = false
    
    static internal func setPriceForFirstMultiCard(_ price: Double) {
        self.priceForFirstMultiCard = price
    }
    
    static internal func getPricesForMultipleCardsPayment() -> (Double, Double) {
        (priceForFirstMultiCard, priceForSecondMultiCard)
    }
    
    static internal func setPaymentStatus(to status: Bool) {
        self.paymentCompleted = status
    }
    
    static internal func isPaymentCompleted() -> Bool {
        self.paymentCompleted
    }
    
    static internal func setMultipleCardsPaymentOneStatus(to status: Bool) {
        self.multipleCardsPaymentOneCompleted = status
    }
    
    static internal func setMultipleCardsPaymentTwoStatus(to status: Bool) {
        self.multipleCardsPaymentTwoCompleted = status
    }
    
    static internal func areMultipleCardsPaymentsCompleted() -> (Bool, Bool) {
        (self.multipleCardsPaymentOneCompleted, self.multipleCardsPaymentTwoCompleted)
    }
    
    static internal func setEnabledPayments(singleCard: Bool, multipleCards: Bool, tokenFlex: Bool, with points: Bool) {
        self.singleCardPaymentEnabled = singleCard
        self.multipleCardsPaymentEnabled = multipleCards
        self.tokenFlexPaymentEnabled = tokenFlex
        self.payByPointsEnabled = points
    }
    
    // single card toggle
    static internal func isSingleCardPaymentEnabled() -> Bool {
        self.singleCardPaymentEnabled
    }
    
    // multiple cards toggle
    static internal func isMultipleCardsPaymentEnabled() -> Bool {
        self.multipleCardsPaymentEnabled
    }
    
    //  token flex toggle
    static internal func isTokenFlexPaymentEnabled() -> Bool {
        self.tokenFlexPaymentEnabled
    }
    
    //  pay by points toggle
    static internal func isPayByPointsEnabled() -> Bool {
        true
        //self.payByPointsEnabled
    }
    
    static internal func assignRetrievedToken(withValue token: String) {
        self.token = token
    }
    
    static public func authorizeWithKeys(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    static public func setEnvironment(to environment: Environment) {
        self.environment = environment
    }
    
    static internal func getEnvironment() -> Environment {
        self.environment
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
    
    static public func useCustomEndScreens(_ value: Bool) {
        self.predefinedScreens = !value
    }
    
    static internal func shouldUseCustomEndScreens() -> Bool {
        !self.predefinedScreens
    }
    
    // success screens
    static public func instantiateCustomSuccessScreenWith(viewController: UIViewController) {
        self.customSuccessScreenViewController = viewController
    }
    
    static public func instantiateCustomSuccessScreenWith(storyboard: UIStoryboard, identifiedBy: String) {
        self.customSuccessScreenViewController = storyboard.instantiateViewController(withIdentifier: identifiedBy)
    }
    
    static internal func getCustomSuccessScreenViewController() -> UIViewController {
        self.customSuccessScreenViewController
    }
    
    // error screens
    static public func instantiateCustomErrorScreenWith(viewController: UIViewController) {
        self.customErrorScreenViewController = viewController
    }
    
    static public func instantiateCustomErrorScreenWith(storyboard: UIStoryboard, identifiedBy: String) {
        self.customErrorScreenViewController = storyboard.instantiateViewController(withIdentifier: identifiedBy)
    }
    
    static internal func getCustomErrorScreenViewController() -> UIViewController {
        self.customErrorScreenViewController
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
        let hmac_md5 = concatenatedString.hmac(algorithm: .sha512, key: secretKey)
        return hmac_md5
    }
    
    static internal func sendCheckoutForm() async throws -> CheckoutFormResult {
        let url = URL(string: environment.getGateway().rawValue + Path.CHECKOUT.rawValue + Action.INIT.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.checkoutForm)
        request.httpBody = encodedBody
        
        print("sending checkout request with following request body:")
        print(String(data: encodedBody, encoding: .utf8) as Any)
        
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
        print("retrieving token...")
        let (data, _) = try await URLSession.shared.data(with: request)
        return try JSONDecoder().decode(CheckoutFormResult.self, from: data)
    }
    
    static internal func retrieveMerchantSettings() async throws -> MerchantSettingsResult {
        let url = URL(string: environment.getGateway().getBaseURL() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.SETTINGS.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.GET.rawValue
        
        // generate signature
        let signature = try generateSignature(for: url.absoluteString, body: String())
        
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
        return try JSONDecoder().decode(MerchantSettingsResult.self, from: data)
    }

    static internal func retrieveInstallments(for binNumber: String, withPrice price: Double, in currency: Currency) async throws -> RetrieveInstallmentResult {
        var urlComponents = URLComponents(string: environment.getGateway().getBaseURL() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.INSTALLMENTS.rawValue)!
        urlComponents.queryItems = [
            URLQueryItem(name: "binNumber", value: binNumber),
            URLQueryItem(name: "price", value: String(price)),
            URLQueryItem(name: "currency", value: currency.rawValue)
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
        let url = URL(string: environment.getGateway().getBaseURL() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.COMPLETE.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.completePaymentForm)
        request.httpBody = encodedBody
        
        print("sending payment request with following request body:")
        print(String(data: encodedBody, encoding: .utf8) as Any)
        
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
        return try JSONDecoder().decode(CompletePaymentFormResult.self, from: data)
    }
    
    static internal func sendComplete3DSPaymentForm() async throws -> CompletePaymentFormResult {
        let url = URL(string: environment.getGateway().getBaseURL() + Path.COMMON_PAYMENT_PAGE.rawValue + Action.THREEDS_INIT.rawValue)!
        var request = URLRequest(url: url)
        
        // method
        request.httpMethod = HTTPMethod.POST.rawValue
        
        // body
        let encodedBody = try JSONEncoder().encode(OderoPay.completePaymentForm)
        request.httpBody = encodedBody
        
        print("sending 3DS payment request with following request body:")
        print(String(data: encodedBody, encoding: .utf8) as Any)
        
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
