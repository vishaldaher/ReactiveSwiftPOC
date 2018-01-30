import UIKit
import ReactiveCocoa
import ReactiveSwift

class CustomTextField: UITextField {

    var customTextFieldViewModel: CustomTextFieldViewModel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        customTextFieldViewModel = CustomTextFieldViewModel()
        customTextFieldViewModel.textOne <~ self.reactive.continuousTextValues
        customTextFieldViewModel.textOne.result.signal.observeValues {
            if !$0.isInvalid {
                let attributedString = NSAttributedString(string: self.text!, attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
                self.attributedText = attributedString
                self.customTextFieldViewModel.isTextValid.value = true
            }
            else
            {
                self.customTextFieldViewModel.isTextValid.value = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
    }
}
