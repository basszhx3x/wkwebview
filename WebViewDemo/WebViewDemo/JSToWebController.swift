

import UIKit
import JavaScriptCore
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


@objc protocol JSTestDelegate: JSExport {
    
    func pushController()    //测试模型js调用oc方法
    func calculateForJS()    //测试模型计算
}

@objc class JSObjcModel:NSObject,JSTestDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func pushController() {
        
        let array = JSContext.currentArguments()
        var index = 0
        var className:String?
        var title:String?
        for obj in array! {
            
            switch index {
            case 0:
                className = (obj as AnyObject).toString()
            default:
                title = (obj as AnyObject).toString()
            }
            
            index += 1
        }
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let receive = board.instantiateViewController(withIdentifier: className!)
        receive.title = title
        controller!.navigationController?.pushViewController(receive, animated: true)
    
    }
    
    func calculateForJS() {
        
        let array = JSContext.currentArguments()
        let number = (array?[0] as AnyObject).toNumber()
        
        let result = calculateFactorialOfNumber(number)
        let showResult = jsContext?.objectForKeyedSubscript("showResult")
        
        showResult?.call(withArguments: [result])
    }
    
    func calculateFactorialOfNumber(_ number:NSNumber?) -> NSNumber {
    
        let i = number?.intValue
        if i < 0 {
            return NSNumber(value: 0 as Int)
        }
        if i==0 {
            return NSNumber(value: 1 as Int)
        }
        
        let r = i! * (calculateFactorialOfNumber(NSNumber(value: (i!-1) as Int)).intValue)
        return NSNumber(value: r as Int)
    }
    
}

class JSToWebController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var context: JSContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        webView.backgroundColor = UIColor.clear
        webView.delegate = self
        loadUrl()
        
        automaticallyAdjustsScrollViewInsets = false
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    fileprivate func loadUrl() {
    
        let filePath = Bundle.main.path(forResource: "JSCallOC", ofType: "html")
        webView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath!)))
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        
        let model = JSObjcModel()
        model.controller = self
        self.context = context
        model.jsContext = self.context

        //设置模型 第一种调用方法
        self.context?.setObject(model, forKeyedSubscript: "app" as (NSCopying & NSObjectProtocol)!)
        let url = Bundle.main.url(forResource: "JSCallOC", withExtension: "html")
        self.context?.evaluateScript(try? String(contentsOf: url!, encoding: String.Encoding.utf8));

        self.context?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception)
        }
        
        
        
        //block 第二种方法
        let log: @convention(block) (String) -> Void = { value in
        
            print("js调用swift代码打印" + value)
        }
        self.context?.setObject(unsafeBitCast(log, to: AnyObject.self), forKeyedSubscript: "log" as (NSCopying & NSObjectProtocol)!)
        //绑定js中的log方法
        
        weak var weakSelf = self
        let alertHandle:@convention(block) (String) -> () = { value in
            
            let alertView = UIAlertController(title: "", message: "js 调用原生 ui", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "确定", style: .default, handler: { (object) in
                
            }))
            weakSelf?.present(alertView, animated: true, completion: nil)
        }
        self.context?.setObject(unsafeBitCast(alertHandle, to: AnyObject.self), forKeyedSubscript: "alert" as (NSCopying & NSObjectProtocol)!)
        //绑定js中的alert方法
        
        print(self.context?.objectForKeyedSubscript("app"))
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
