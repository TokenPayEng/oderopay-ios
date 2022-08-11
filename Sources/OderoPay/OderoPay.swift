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
}
