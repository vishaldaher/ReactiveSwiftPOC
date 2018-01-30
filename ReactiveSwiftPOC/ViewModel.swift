import UIKit
import ReactiveSwift
import Result

struct FormError: Error {
    let reason: String
    static let invalidText = FormError(reason: "Invalid text")
}

class ViewModel: NSObject {
    var placeholderStringOne = "Text one"
    var placeholderStringTwo = "Text two"

    var validation: Property<String?>
    let submit: Action<(), (), FormError>

    var textOne = MutableProperty(false)
    var textTwo = MutableProperty(false)
    
    override init() {
        
        validation = Property
            .combineLatest(textOne,textTwo)
            .map {(arg) -> String? in
                let (textOne, textTwo) = arg
                return textOne && textTwo ? "valid" : nil}
        
        submit = Action(unwrapping: validation) { (_: String) in
            let (_, _) = Signal<String, FormError>.pipe()
            return SignalProducer<(), FormError> {
                observer, disposable in
                observer.sendCompleted()
            }
        }
    }
}
