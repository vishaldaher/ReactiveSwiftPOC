import UIKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    
    var textFieldOne: CustomTextField!
    var textFieldTwo: CustomTextField!
    
    var viewModel: ViewModel!
    var activityIndicatorView: ActivityIndicatorView!
    
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
    
    func btnSubmitClicked() {
        activityIndicatorView = ActivityIndicatorView(frame: view.frame)
        activityIndicatorView.activityIndicator.startAnimating()
        view.addSubview(activityIndicatorView)
        
        //Timer to stop animating activity indicator
        Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0), repeats: false) { (_) in
            self.stopAnimatingActivityIndicator()
        }
    }
    
    //MARK: General Method
    func stopAnimatingActivityIndicator() {
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
        textFieldOne.placeholder = viewModel.placeholderStringOne
        
        let frameTwo = CGRect(x: (view.frame.width - 200)/2, y: 100, width: 200, height: 30)
        textFieldTwo = CustomTextField(frame: frameTwo)
        textFieldTwo.placeholder = viewModel.placeholderStringTwo
        
        view.addSubview(textFieldOne)
        view.addSubview(textFieldTwo)
        
        viewModel.textOne <~ textFieldOne.customTextFieldViewModel.isTextValid
        viewModel.textTwo <~ textFieldTwo.customTextFieldViewModel.isTextValid
        
        btnSubmit.reactive.pressed = CocoaAction(viewModel.submit)
        
        viewModel.submit.completed.observeValues {
            self.btnSubmitClicked()
        }
        
        viewModel.validation.signal.observeValues {
            if $0 == "valid" {
                self.btnSubmit.isEnabled = true
            }
            else {
                self.btnSubmit.isEnabled = false
            }
        }
    }
}

