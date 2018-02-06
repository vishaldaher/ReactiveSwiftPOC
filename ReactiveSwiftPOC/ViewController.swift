import UIKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    
    var textFieldOne: CustomTextField!
    var textFieldTwo: CustomTextField!
    
    var viewModel: ViewModelType!
    var activityIndicatorView: ActivityIndicatorView!
    
    var returnString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //This will initialize view model class while creating object of view controller
        viewModel = ViewModel()
    }
    
    //MARK: General Method
    func showAndStartAnimatingActivityIndicator() {
        activityIndicatorView = ActivityIndicatorView(frame: view.frame)
        activityIndicatorView.activityIndicator.startAnimating()
        view.addSubview(activityIndicatorView)
    }
    
    func hideAndstopAnimatingActivityIndicator() {
        if activityIndicatorView != nil {
            activityIndicatorView.activityIndicator.stopAnimating()
            activityIndicatorView.removeFromSuperview()
        }
    }

    func initialize()
    {
        btnSubmit.isEnabled = false

        let frameOne = CGRect(x: (view.frame.width - 200)/2, y: 50, width: 200, height: 30)
        textFieldOne = CustomTextField(frame: frameOne)
        textFieldOne.textField.placeholder = viewModel.input.placeholderStringOne
        
        let frameTwo = CGRect(x: (view.frame.width - 200)/2, y: 100, width: 200, height: 30)
        textFieldTwo = CustomTextField(frame: frameTwo)
        textFieldTwo.textField.placeholder = viewModel.input.placeholderStringTwo
        
        view.addSubview(textFieldOne)
        view.addSubview(textFieldTwo)
        
        viewModel.input.textOne <~ textFieldOne.customTextFieldViewModel.input.isTextValid
        viewModel.input.textTwo <~ textFieldTwo.customTextFieldViewModel.input.isTextValid
        self.textFieldOne.reactive.isUserInteractionEnabled <~ viewModel.input.submit.isExecuting.map({ (value) -> Bool in
            return !value
        })
        self.textFieldTwo.reactive.isUserInteractionEnabled <~ viewModel.input.submit.isExecuting.map({ (value) -> Bool in
            return !value
        })

        btnSubmit.reactive.pressed = CocoaAction(viewModel.input.submit)
        
        textFieldOne.customTextFieldViewModel.input.isTextValid.signal.observeValues {
            if $0 == 0 {
                self.textFieldOne.textField.text = ""
            }
            if $0 > 3 {
                self.textFieldOne.textField.text =  String(describing: self.textFieldOne.textField.text!.prefix(3))
            }
        }
        
        viewModel.input.submit.isExecuting.signal.observeValues {
            
            self.btnSubmit.reactive.isEnabled <~ self.viewModel.input.submit.isExecuting.map({ (value) -> Bool in
                return !value
            })

            if $0 {
                self.showAndStartAnimatingActivityIndicator()
            }
            else {
                self.hideAndstopAnimatingActivityIndicator()
                self.btnSubmit.setTitle(self.returnString, for: .normal)
            }
        }
        
        self.viewModel.input.submit.values.observeValues {
                if !$0.isEmpty {
                 self.returnString = $0
            }
        }
                
        viewModel.output.validation.signal.observeValues { _ in
            self.btnSubmit.setTitle("Submit", for: .normal)
        }
    }
}

