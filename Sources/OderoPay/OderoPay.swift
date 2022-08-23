import Foundation

public struct OderoPay {
    public private(set) var text = "Hello, World!"
    static private var checkoutForm = CheckoutForm()

    public init() {
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
        
        let encoded = try JSONEncoder().encode(OderoPay.checkoutForm)
        let json = try JSONSerialization.jsonObject(with: encoded, options: [])
        
        var components = URLComponents(string: url.absoluteString)!
        if let object = json as? [String: Any] {
            components.queryItems = object.compactMap { (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.POST.rawValue
        
        let (data, _) = try await URLSession.shared.data(from: request.url!)
        return try JSONDecoder().decode(CheckoutFormResult.self, from: data)
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
