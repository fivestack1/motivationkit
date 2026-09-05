
import Foundation
import SwiftUI
import Combine
import StoreKit

let subscription_1 = "motivationweek"
let subscription_2 = "motivationmonth"
let subscription_3 = "motivationyear"
let shared_secret = "e7ef97b05ed8442eb43622bc88659620"

class ProductsStore : ObservableObject {
    
    static let shared = ProductsStore()
    
    @Published var products: [SKProduct] = []
    @Published var anyString = "" 
    
    func handleUpdateStore(){
        anyString = UUID().uuidString
    }
    
    func initializeProducts(){
        IAPManager.shared.startWith(arrayOfIds: [subscription_1, subscription_2, subscription_3], sharedSecret: shared_secret) { products in
            self.products = products   
        }
    }
}
