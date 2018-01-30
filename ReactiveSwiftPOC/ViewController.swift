import UIKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tfOne: UITextField!
    @IBOutlet weak var tfTwo: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var viewModel : ViewModel!
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
            let frame = CGRect(x: (view.frame.width - 50)/2, y: (view.frame.height - 50)/2, width: 50, height: 50)
            activityIndicatorView = ActivityIndicatorView(frame: frame)
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
        tfOne.placeholder = viewModel.placeholderStringOne
        
        tfTwo.placeholder = viewModel.placeholderStringTwo
        
        btnSubmit.isEnabled = false
        
        viewModel.textOne <~ tfOne.reactive.continuousTextValues
            .map { $0!.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        viewModel.textTwo <~ tfTwo.reactive.continuousTextValues
            .map { $0!.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        btnSubmit.reactive.pressed = CocoaAction(viewModel.submit)
        
        viewModel.submit.completed.observeValues {
            self.btnSubmitClicked()
        }
        
        viewModel.textOne.result.signal.observeValues {
            if !$0.isInvalid {
                let attributedString = NSAttributedString(string: self.tfOne.text!, attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
                self.tfOne.attributedText = attributedString
            }
        }

        viewModel.textTwo.result.signal.observeValues {
            if !$0.isInvalid {
                let attributedString = NSAttributedString(string: self.tfTwo.text!, attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
                self.tfTwo.attributedText = attributedString
            }
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

