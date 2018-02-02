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

    let submit: Action<(), String, FormError>

    var textOne = MutableProperty(0)
    var textTwo = MutableProperty(0)
    
    var textOne1 = MutableProperty("")
    var textTwo2 = MutableProperty("")
    override init() {
        
        validation = Property
            .combineLatest(textOne,textTwo)
            .map {(arg) -> String? in
                let (textOne, textTwo) = arg
                return textOne != 0 && textTwo != 0 ? "valid" : nil}
        
        submit = Action(unwrapping: validation) { (_: String) in
            let (_, _) = Signal<String, FormError>.pipe()
            return SignalProducer<String, FormError> {
                observer, disposable in
                observer.send(value: "Done")
                observer.sendCompleted()
            }
        }
    }
}
