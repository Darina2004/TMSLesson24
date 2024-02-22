//
//  ViewController.swift
//  TMSLesson24
//
//  Created by Mac on 21.02.24.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var cities: [City] = []
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "World Clock"
        
        let newYorkTimeZone = TimeZone(identifier: "America/New_York")
        let londonTimeZone = TimeZone(identifier: "Europe/London")
        let tokyoTimeZone = TimeZone(identifier: "Asia/Tokyo")
        let minskTimeZone = TimeZone(identifier: "Europe/Minsk")
        let berlinTimeZone = TimeZone(identifier: "Europe/Berlin")
        let warsawTimeZone = TimeZone(identifier: "Europe/Warsaw")
        let parisTimeZone = TimeZone(identifier: "Europe/Paris")
        
        if let newYorkTimeZone = newYorkTimeZone, let londonTimeZone = londonTimeZone, let tokyoTimeZone = tokyoTimeZone, let minskTimeZone = minskTimeZone, let berlinTimeZone = berlinTimeZone, let warsawTimeZone = warsawTimeZone, let parisTimeZone = parisTimeZone {
            let cities = [
                City(name: "New-York", timeZone: newYorkTimeZone),
                City(name: "London", timeZone: londonTimeZone),
                City(name: "Tokyo", timeZone: tokyoTimeZone),
                City(name: "Minsk", timeZone: minskTimeZone),
                City(name: "Berlin", timeZone: berlinTimeZone),
                City(name: "Warsaw", timeZone: warsawTimeZone),
                City(name: "Paris", timeZone: parisTimeZone)
            ]
            self.cities = cities
        } else {
            print("Ошибка при инициализации часовых поясов.")
        }
        dateFormatter.dateFormat = "HH:mm:ss"
        
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityTableViewCell")
        tableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        let city = cities[indexPath.row]
        dateFormatter.timeZone = city.timeZone
        let currentTime = dateFormatter.string(from: Date())
        let timeZoneOffset = city.timeZone.secondsFromGMT()
        let timeZoneString = "UTC \(timeZoneOffset > 0 ? "+" : "")\(timeZoneOffset / 3600)"
        cell.configure(city: city, currentTime: currentTime, timeZone: timeZoneString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
