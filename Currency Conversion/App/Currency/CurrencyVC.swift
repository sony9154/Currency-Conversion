//
//  CurrencyVC.swift
//  Currency Conversion
//
//  Created by Hsu Hua on 2021/8/21.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxViewController
import UICollectionViewLeftAlignedLayout

class CurrencyVC: NodeVC,
                  StoryboardMakable,
                  UIPickerViewDelegate,
                  UIPickerViewDataSource,
                  UITextFieldDelegate,
                  UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    
    lazy var countryPicker : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    var node: CurrencyUINode? { return ownerNode as? CurrencyUINode }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        settingField()
    }
    
    override func bindNode(_ node: Node) {
        guard let node =  node as? CurrencyUINode else { return }
            
        amountTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe{ [weak node] text in
                guard let amount = self.amountTextField.text else { return }
                guard let currency = self.countryTextField.text else { return }
                node?.act(.setInputAmount(amount: Double(amount) ?? 0.0))
                node?.act(.convertAmount(currency: currency, amount: Double(amount) ?? 0.0))
            }.disposed(by: disposeBag)
        
        countryTextField.rx.text
            .filterNil()
            .subscribe(onNext: { [weak self] text in
                guard let amountStr = self?.amountTextField.text else { return }
                node.act(.setCurrency(currency: text))
                node.act(.convertAmount(currency: text, amount: Double(amountStr) ?? 0.0))
            })
            .disposed(by: disposeBag)
        
        convertButton.rx.tap
            .subscribe(onNext: { [weak node] in
                guard let amount = self.amountTextField.text else { return }
                guard let currency = self.countryTextField.text else { return }
                node?.act(.convertAmount(currency: currency, amount: Double(amount) ?? 0.0))
            }).disposed(by: disposeBag)
        
        node.exchangeRates
            .map { $0 ?? [] }
            .filterNil()
            .bind(to: collectionView.rx.items(cellIdentifier: "ExchangeRatesCell", cellType: ExchangeRatesCell.self))
                { index, exchangeRate, cell in
                    cell.configure(exchangeRate: exchangeRate,
                                   newAmount: exchangeRate.amount)
                }
            .disposed(by: disposeBag)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 30) / 3 // compute your cell width
            return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
    
    private func settingField() {
        countryTextField.inputView = countryPicker
        countryTextField.delegate = self
    }
    
    //MARK: - PickerView Delegate / DataSource -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return node?.currencies.value?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = node?.currencies.value?[row].name
        return country
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = node?.currencies.value?[row].code
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
