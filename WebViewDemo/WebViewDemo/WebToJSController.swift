

import UIKit
import JavaScriptCore

class WebToJSController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var context: JSContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.context = JSContext()
        let url = Bundle.main.url(forResource: "testJS", withExtension: "js")
        let stringTest = try? String.init(contentsOf: url!, encoding: String.Encoding.utf8)
        self.context?.evaluateScript(stringTest);
    }
    
    @IBAction func loadMethod(_ sender: AnyObject) {
        
        self.context?.evaluateScript("alertResponseOc()")
        
    }
    
    @IBAction func loadWithParameters(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        let tmpInt = sender.isSelected ? 30 : 15
        let value = self.context?.objectForKeyedSubscript("showResult")
        let reult = value?.call(withArguments: [tmpInt])
        
        titleLabel.text = "结果：\(reult?.toNumber().intValue)"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
