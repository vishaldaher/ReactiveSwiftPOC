import UIKit
import ReactiveSwift

class CustomTextFieldViewModel: NSObject {

    var textOne: ValidatingProperty<String?, FormError>
    var isTextValid = MutableProperty(false)
    
    override init() {        
        textOne = ValidatingProperty("") { input in
            return  (input?.count)! > 0 ? .valid : .invalid(.invalidText)
        }        
    }
}
