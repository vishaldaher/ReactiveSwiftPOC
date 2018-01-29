import UIKit

class ViewModel: NSObject {

    var rootViewController: ViewController!
    var activityIndicatorView: ActivityIndicatorView!
    var showActivityIndicator: Bool = false
    var enableSubmitButton: Bool = false
    var dataModel: DataModel = DataModel()

    init(rootViewController: ViewController) {
        self.rootViewController = rootViewController
    }
    
    func textChanged(dataModel: DataModel) {
        self.dataModel = dataModel
        processData()
    }
    
    func processData()
    {
        if !dataModel.textOne.isEmpty && !dataModel.textTwo.isEmpty {
            enableSubmitButton = true
            showActivityIndicator = true
        }
        else {
            enableSubmitButton = false
            showActivityIndicator = false
        }
    }    
}
