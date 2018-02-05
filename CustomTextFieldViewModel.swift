import UIKit
import ReactiveSwift

protocol CustomTextFieldViewModelInput {
    var isTextValid: MutableProperty<Int> { get }
}

protocol CustomTextFieldViewModelOutput {
    var textOne: ValidatingProperty<String?, FormError> { get }
}

protocol CustomTextFieldViewModelType {
    var input: CustomTextFieldViewModelInput { get }
    var output: CustomTextFieldViewModelOutput { get }
}

class CustomTextFieldViewModel: NSObject, CustomTextFieldViewModelType, CustomTextFieldViewModelInput, CustomTextFieldViewModelOutput{
    var isTextValid: MutableProperty<Int> = MutableProperty(0)
    var textOne: ValidatingProperty<String?, FormError> = ValidatingProperty("") { input in
                    return  (input?.count)! > 0 ? .valid : .invalid(.invalidText)
                }
    
    var input: CustomTextFieldViewModelInput { return self }    
    var output: CustomTextFieldViewModelOutput { return self }
    
    override init() {
        
    }
}
