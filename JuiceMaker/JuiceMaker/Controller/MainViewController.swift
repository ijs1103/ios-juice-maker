//
//  MainViewController.swift
//  JuiceMaker
//
//  Created by Taewan Kim on 12/8/23.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var strawberryQuantity: UILabel!
    @IBOutlet weak var bananaQuantity: UILabel!
    @IBOutlet weak var pineappleQuantity: UILabel!
    @IBOutlet weak var kiwiQuantity: UILabel!
    @IBOutlet weak var mangoQuantity: UILabel!
    let juiceMaker = JuiceMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFruitQuantities), name: NSNotification.Name("JuiceMade"), object: nil)
        
        let allFruitQuantity = juiceMaker.fruitStore.currentQuantityOfAllFruits()
        guard let strawberry = allFruitQuantity[.strawberry] else {
            return
        }
        guard let banana = allFruitQuantity[.banana] else {
            return
        }
        guard let pineapple = allFruitQuantity[.pineapple] else {
            return
        }
        guard let kiwi = allFruitQuantity[.kiwi] else {
            return
        }
        guard let mango = allFruitQuantity[.mango] else {
            return
        }
        
        strawberryQuantity.text = String(strawberry)
        bananaQuantity.text = String(banana)
        pineappleQuantity.text = String(pineapple)
        kiwiQuantity.text = String(kiwi)
        mangoQuantity.text = String(mango)
    }
    
    @objc func updateFruitQuantities() {
        guard let strawberry = juiceMaker.fruitStore.currentFruitStockQuantity(fruitName: .strawberry) else {
            return
        }
        
        guard let banana = juiceMaker.fruitStore.currentFruitStockQuantity(fruitName: .banana) else {
            return
        }
        
        guard let pineapple = juiceMaker.fruitStore.currentFruitStockQuantity(fruitName: .pineapple) else {
            return
        }
        
        guard let kiwi = juiceMaker.fruitStore.currentFruitStockQuantity(fruitName: .kiwi) else {
            return
        }
        
        guard let mango = juiceMaker.fruitStore.currentFruitStockQuantity(fruitName: .mango) else {
            return
        }
        
        strawberryQuantity.text = String(strawberry)
        bananaQuantity.text = String(banana)
        pineappleQuantity.text = String(pineapple)
        kiwiQuantity.text = String(kiwi)
        mangoQuantity.text = String(mango)
    }
    
    private func openResultAlert(_ result: Result<Void, JuiceError>) {
        switch result {
        case .success:
            NotificationCenter.default.post(name: NSNotification.Name("JuiceMade"), object: nil)
            let alert = UIAlertController(title: "주문 완료", message: "쥬스가 나왔습니다! 맛있게 드세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        case .failure(let error):
            switch error {
            case JuiceError.outOfStock:
                let alert = UIAlertController(title: "재료 부족", message: "재료가 모자라요. 재고를 수정할까요?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "modifyInventorySegue", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            case JuiceError.unknown:
                break
                
            case JuiceError.quantityOfAllFruitsAccessFailed:
                let alert = UIAlertController(title: "유효하지 않은 레시피", message: "주문할 수 없는 쥬스입니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func StrawberryJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .strawberry))
    }
    
    @IBAction func bananaJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .banana))
    }
    
    @IBAction func pineappleJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .pineapple))
    }
    
    @IBAction func kiwiJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .kiwi))
    }
    
    @IBAction func mangoJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .mango))
    }
    
    @IBAction func strawberryBananaJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .straberryBanana))
    }
    
    @IBAction func mangoKiwiJuiceOrderButtonTapped(_ sender: UIButton) {
        openResultAlert(juiceMaker.makeJuice(juiceMenu: .mangoKiwi))
    }
    
}
