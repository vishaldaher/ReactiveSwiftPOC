import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfOne: UITextField!
    @IBOutlet weak var tfTwo: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var viewModel : ViewModel!
    var activityIndicatorView: ActivityIndicatorView!
    var dataModel: DataModel!
    
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
        viewModel = ViewModel(rootViewController: self)
    }
    
    //MARK: Selector methods
    @objc func tfOneChanged(textField : UITextField) {
        dataModel.textOne = textField.text
        viewModel.textChanged(dataModel: dataModel)
        updateSubmitButton()
    }

    @objc func tfTwoChanged(textField : UITextField) {
        dataModel.textTwo = textField.text
        viewModel.textChanged(dataModel: dataModel)
        updateSubmitButton()
    }

    //MARK: Button click event
    @objc func btnSubmitClicked(button : UIButton) {
        if viewModel.showActivityIndicator {
            let frame = CGRect(x: (view.frame.width - 50)/2, y: (view.frame.height - 50)/2, width: 50, height: 50)
            activityIndicatorView = ActivityIndicatorView(frame: frame)
            activityIndicatorView.activityIndicator.startAnimating()
            view.addSubview(activityIndicatorView)
            
            //Timer to stop animating activity indicator
            Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0), repeats: false) { (_) in
                self.stopAnimatingActivityIndicator()
            }
        }
    }
    
    //MARK: General Method
    func stopAnimatingActivityIndicator() {
        if activityIndicatorView != nil {
            activityIndicatorView.activityIndicator.stopAnimating()
            activityIndicatorView.removeFromSuperview()
        }
    }

    func updateSubmitButton() {
        btnSubmit.isEnabled = viewModel.enableSubmitButton
    }
    
    func initialize()
    {
        // handle text changes
        tfOne.addTarget(self, action: #selector(self.tfOneChanged), for: UIControlEvents.editingChanged)
        tfTwo.addTarget(self, action: #selector(self.tfTwoChanged), for: UIControlEvents.editingChanged)

        //handle button click
        btnSubmit.addTarget(self, action: #selector(self.btnSubmitClicked), for: UIControlEvents.touchUpInside)

        dataModel = DataModel()
        btnSubmit.isEnabled = viewModel.enableSubmitButton
    }
}

