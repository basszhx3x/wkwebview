

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toOCButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toOCButtonHandle(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "toOC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOC" {
            
            let  receive = segue.destination
            receive.title = "JS to OC"
        }
        
    }

   
    @IBAction func toJSButtonHandle(_ sender: AnyObject) {
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let receive = board.instantiateViewController(withIdentifier: "toJS")
        receive.title = "OC to JS"
        navigationController?.pushViewController(receive, animated: true)
    }
    
}

