import UIKit
import ReactiveCocoa
import ReactiveSwift

class CustomTextField: UIView {
    
    @IBOutlet weak var textField: UITextField!

    var customTextFieldViewModel: CustomTextFieldViewModelType!
    
    var contentView : UIView?

    override init(frame: CGRect) {

        super.init(frame: frame)
        
        xibSetup()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        customTextFieldViewModel = CustomTextFieldViewModel()
        customTextFieldViewModel.output.textOne <~ self.textField.reactive.continuousTextValues
            .map{ $0!.trimmingCharacters(in: .whitespacesAndNewlines) }
        customTextFieldViewModel.output.textOne.result.signal.observeValues {
            if !$0.isInvalid {
                let attributedString = NSAttributedString(string: (self.textField.text!), attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
                self.textField.attributedText = attributedString
                self.customTextFieldViewModel.input.isTextValid.value = ($0.value??.count)!
            }
            else
            {
                self.customTextFieldViewModel.input.isTextValid.value = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
