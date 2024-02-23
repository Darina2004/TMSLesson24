//
//  SitySearchVieewController.swift
//  TMSLesson24
//
//  Created by Mac on 23.02.24.
//

import UIKit

protocol CitySearchViewControllerDelegate: AnyObject {
    func didEnterCityName(_ cityName: String)
}

class CitySearchViewController: UIViewController {
    enum Constants {
        static let textFieldWidth: CGFloat = 350
        static let textFieldHeight: CGFloat = 40
        static let textFieldTopAnchor: CGFloat = 100
        
        static let titlePlaceholder = "Search"
    }
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.titlePlaceholder
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    var cityName: String?
    weak var delegate: CitySearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        
        setupSearchTextField()
    }
    
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.textFieldTopAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }
    
    private func searchButtonTapped() {
        guard let cityName = searchTextField.text, !cityName.isEmpty else {
            print("Введите название города")
            return
        }
        delegate?.didEnterCityName(cityName)
        navigationController?.popViewController(animated: true)
    }
}

extension CitySearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchText = textField.text {
            delegate?.didEnterCityName(searchText)
            navigationController?.popViewController(animated: true)
        }
        return false
    }
}
