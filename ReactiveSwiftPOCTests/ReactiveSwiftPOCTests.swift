import XCTest
@testable import ReactiveSwiftPOC
import ReactiveSwift

class ReactiveSwiftPOCTests: XCTestCase {
    
    var viewModel: ViewModelType!
    var tfOne: CustomTextField!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ViewModel()
        tfOne = CustomTextField(frame: CGRect.zero)
        viewModel.input.textOne <~ tfOne.customTextFieldViewModel.input.isTextValid
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextFieldContainsNoText() {
        XCTAssertFalse(viewModel.input.textOne.value != 0 ? true : false)
        
        tfOne.textField.insertText(" ")
        XCTAssertFalse(viewModel.input.textOne.value != 0 ? true : false)

        tfOne.textField.insertText("")
        XCTAssertFalse(viewModel.input.textOne.value != 0 ? true : false)
    }

    func testFieldContainsText() {
        tfOne.textField.insertText(" T")
        XCTAssertTrue(viewModel.input.textOne.value != 0 ? true : false)

        tfOne.textField.insertText("T")
        XCTAssertTrue(viewModel.input.textOne.value != 0 ? true : false)

        tfOne.textField.insertText("Text")
        XCTAssertTrue(viewModel.input.textOne.value != 0 ? true : false)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
