
import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
import StoreKit

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var scrollMain: UIScrollView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var viewPrice1: UIView!
    @IBOutlet weak var viewPrice2: UIView!
    @IBOutlet weak var viewPrice3: UIView!
    @IBOutlet weak var imageCheck1: UIImageView!
    @IBOutlet weak var imageCheck2: UIImageView!
    @IBOutlet weak var imageCheck3: UIImageView!
    
    @IBOutlet weak var labelPrice1: UILabel!
    @IBOutlet weak var labelPrice2: UILabel!
    @IBOutlet weak var labelPrice3: UILabel!
    
    @IBOutlet weak var buttonBuy: UIButton!
    @IBOutlet weak var buttonTerms: UIButton!
    @IBOutlet weak var buttonPrivacy: UIButton!
    @IBOutlet weak var buttonRestore: UIButton!
    
    private var isDisabled : Bool = false
    var products: [SKProduct] = []
    var product : SKProduct!
    var product1 : SKProduct!
    var product2 : SKProduct!
    var product3 : SKProduct!
    var inp = 0
    var pr = ""
    
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMain.frame = CGRect(x:0, y: 0, width:UIScreen.main.bounds.width, height:756)
        self.scrollMain.isScrollEnabled = true
        self.scrollMain.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 756)
        self.scrollMain.contentInsetAdjustmentBehavior = .never
        
        viewPrice1.layer.cornerRadius = 8
        viewPrice2.layer.cornerRadius = 8
        viewPrice3.layer.cornerRadius = 8
        
        buttonBuy.layer.cornerRadius = 8
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.subShow()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func subShow() {
        IAPManager.shared.startWith(arrayOfIds:  [subscription_1, subscription_2, subscription_3], sharedSecret: shared_secret) { products in
            self.products = products
            
            if (self.products[0].productIdentifier == subscription_1) { self.product1 = self.products[0] }
            else if (self.products[0].productIdentifier == subscription_2) { self.product2 = self.products[0] }
            else if (self.products[0].productIdentifier == subscription_3) { self.product3 = self.products[0] }
            
            if (self.products[1].productIdentifier == subscription_1) { self.product1 = self.products[1] }
            else if (self.products[1].productIdentifier == subscription_2) { self.product2 = self.products[1] }
            else if (self.products[1].productIdentifier == subscription_3) { self.product3 = self.products[1] }
            
            if (self.products[2].productIdentifier == subscription_1) { self.product1 = self.products[2] }
            else if (self.products[2].productIdentifier == subscription_2) { self.product2 = self.products[2] }
            else if (self.products[2].productIdentifier == subscription_3) { self.product3 = self.products[2] }

            if (!self.product1.productIdentifier.isEmpty) { self.labelPrice1.text = String(format: "1 week free, then %@/week", self.product1.localizedPrice()) }
            if (!self.product2.productIdentifier.isEmpty) { self.labelPrice2.text = String(format: "1 week free, then %@/month", self.product2.localizedPrice()) }
            if (!self.product3.productIdentifier.isEmpty) { self.labelPrice3.text = String(format: "1 week free, then %@/year", self.product3.localizedPrice()) }
            
            self.indicatorLoading.isHidden = true
            
        }
    }
    
    
    func restorePurchases(){
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            self.dismiss(animated: true)
            
        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            
        }
    }
    
    @objc func purchaseProduct(skproduct : SKProduct){
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            self.dismiss(animated: true)
        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
        }
    }
    
    @IBAction func buttonPriceAction1(_ sender: Any) {
        inp = 0
        resetChecks()
        self.imageCheck1.image = UIImage(systemName: "checkmark.circle.fill")
    }
    @IBAction func buttonPriceAction2(_ sender: Any) {
        inp = 1
        resetChecks()
        self.imageCheck2.image = UIImage(systemName: "checkmark.circle.fill")
    }
    @IBAction func buttonPriceAction3(_ sender: Any) {
        inp = 2
        resetChecks()
        self.imageCheck3.image = UIImage(systemName: "checkmark.circle.fill")
    }
    func resetChecks() {
        self.imageCheck1.image = UIImage(systemName: "circle")
        self.imageCheck2.image = UIImage(systemName: "circle")
        self.imageCheck3.image = UIImage(systemName: "circle")
    }
    
    @IBAction func buttonBuyAction(_ sender: Any) {
        switch inp {
        case 0:
            purchaseProduct(skproduct: self.product1)
        case 1:
            purchaseProduct(skproduct: self.product2)
        case 2:
            purchaseProduct(skproduct: self.product3)
        default:
            print("Select product")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func buttonRestoreAction(_ sender: Any) {
        restorePurchases()
    }
    @IBAction func termsButtonAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://sites.google.com/view/iterms/")!, options: [:], completionHandler: nil)
    }
    @IBAction func privacyButtonAction(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://sites.google.com/view/ipprivacy-policy/")!, options: [:], completionHandler: nil)
    }
}

extension SKProduct {
        
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        let text = formatter.string(from: price)
        return (text ?? "")
        
    }
    
}
