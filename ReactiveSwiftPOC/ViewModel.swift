import UIKit
import ReactiveSwift
import Result

class ViewModel: NSObject {

    struct FormError: Error {
        let reason: String
        static let invalidText = FormError(reason: "Invalid text")
    }
    
    var placeholderStringOne = "Text one"
    var placeholderStringTwo = "Text two"

    var textOne: ValidatingProperty<String?, FormError>
    var textTwo: ValidatingProperty<String?, FormError>
    var validation: Property<String?>
    let submit: Action<(), Bool, FormError>

    override init() {
        
        textOne = ValidatingProperty("") { input in
            return  (input?.count)! > 0 ? .valid : .invalid(.invalidText)
        }
        
        textTwo = ValidatingProperty("") { input in
            return  (input?.count)! > 0 ? .valid : .invalid(.invalidText)
        }
        
        validation = Property
            .combineLatest(textOne.result,textTwo.result)
            .map {(arg) -> String? in
                let (textOne1, textTwo2) = arg
                return !textOne1.isInvalid && !textTwo2.isInvalid ? "valid" : nil}
        
        submit = Action(unwrapping: validation) { (_: String) in
            let (_, _) = Signal<String, FormError>.pipe()
            return SignalProducer<Bool, FormError> {
                observer, disposable in
                observer.sendCompleted()
            }
        }
    }
}
