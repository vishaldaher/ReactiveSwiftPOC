import UIKit
import ReactiveSwift
import Result

protocol ViewModelInput {
    var textOne: MutableProperty<Int> { get }
    var textTwo: MutableProperty<Int> { get }
    var isControlEnabled: MutableProperty<Bool> { get }
    var submit: Action<(), String, FormError> { get }
    var placeholderStringOne: String { get }
    var placeholderStringTwo: String { get }
}

protocol ViewModelOutput {
    var validation: Property<String?> { get }
}

protocol ViewModelType {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

struct FormError: Error {
    let reason: String
    static let invalidText = FormError(reason: "Invalid text")
}

class ViewModel: NSObject, ViewModelType, ViewModelInput, ViewModelOutput {
    
    var isControlEnabled: MutableProperty<Bool>
    
    var signal: Signal<Bool, NoError>!
    
    var placeholderStringOne: String {
        return "Text one"
    }
    
    var placeholderStringTwo: String {
        return "Text two"
    }
    
    var input: ViewModelInput {
        return self
    }
    
    var output: ViewModelOutput {
        return self
    }
    
    var validation: Property<String?>
    let submit: Action<(), String, FormError>
    var textOne = MutableProperty(0)
    var textTwo = MutableProperty(0)
    
    override init() {
        
        isControlEnabled = MutableProperty(true)
        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    observer.sendCompleted()
                })
            }
        }
    }
}
