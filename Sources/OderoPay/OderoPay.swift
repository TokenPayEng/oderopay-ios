public struct OderoPay {
    public private(set) var text = "Hello, World!"
    static private var checkoutForm = CheckoutForm()

    public init() {
    }
    
    static public func isCheckoutFormReady() -> Bool {
        OderoPay.checkoutForm.isReady()
    }
}
