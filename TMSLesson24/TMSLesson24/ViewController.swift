//
//  ViewController.swift
//  TMSLesson24
//
//  Created by Mac on 21.02.24.
//

import UIKit

class ViewController: UIViewController {
    
    enum Constants {
        static let tableViewHeightForRowAt:CGFloat = 100
        
        static let newYork = "America/New_York"
        static let london = "Europe/London"
        static let tokyo = "Asia/Tokyo"
        static let minsk = "Europe/Minsk"
        static let berlin = "Europe/Berlin"
        static let warsaw = "Europe/Warsaw"
        static let paris = "Europe/Paris"
        
        static let title = "World Clock"
        static let tableViewCellIdentifier = "CityTableViewCell"
        
        static let apiKey = "522b0bbb38f54265b2a379e229f0321a"
        static let baseURL = "https://api.opencagedata.com/geocode/v1/json"
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var cities: [City] = []
    
    let dateFormatter = DateFormatter()
    let dateFormatterDate = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        
        _ = "America/New_York"
        _ = "Europe/London"
        _ = "Asia/Tokyo"
        _ = "Europe/Minsk"
        _ = "Europe/Berlin"
        _ = "Europe/Warsaw"
        _ = "Europe/Paris"
        
        if let newYorkTimeZone = TimeZone(identifier: Constants.newYork),
           let londonTimeZone = TimeZone(identifier: Constants.london),
           let tokyoTimeZone = TimeZone(identifier: Constants.tokyo),
           let minskTimeZone = TimeZone(identifier: Constants.minsk),
           let berlinTimeZone = TimeZone(identifier: Constants.berlin),
           let warsawTimeZone = TimeZone(identifier: Constants.warsaw),
           let parisTimeZone = TimeZone(identifier: Constants.paris) {
            
            let cities = [
                City(name: "New-York", timeZoneIdentifier: Constants.newYork),
                City(name: "London", timeZoneIdentifier: Constants.london),
                City(name: "Tokyo", timeZoneIdentifier: Constants.tokyo),
                City(name: "Minsk", timeZoneIdentifier: Constants.minsk),
                City(name: "Berlin", timeZoneIdentifier: Constants.berlin),
                City(name: "Warsaw", timeZoneIdentifier: Constants.warsaw),
                City(name: "Paris", timeZoneIdentifier: Constants.paris)
            ]
            self.cities = cities
        } else {
            print("Ошибка при инициализации часовых поясов.")
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatterDate.dateFormat = "d MMM"
        
        setupNavigation()
        setupTableView()
    }
    
   private func setupNavigation() {
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
        tableView.register(UINib(nibName: Constants.tableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.tableViewCellIdentifier)
        tableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        let citySearchViewController = CitySearchViewController()
        citySearchViewController.delegate = self
        
        navigationController?.pushViewController(citySearchViewController, animated: true)
    }
    
   private func searchCity(_ cityName: String) {
        print("Вы ищете город: \(cityName)")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath) as! CityTableViewCell
        let city = cities[indexPath.row]
        
        if let timeZone = city.timeZone {
            dateFormatter.timeZone = timeZone
            let currentTime = dateFormatter.string(from: Date())
            let currentDate = dateFormatterDate.string(from: Date())
            
            let timeZoneOffset = timeZone.secondsFromGMT()
            let timeZoneString = "UTC\(timeZoneOffset > 0 ? "+" : "")\(timeZoneOffset / 3600),"
            
            cell.configure(city: city, currentTime: currentTime, currentDate: currentDate, timeZone: timeZoneString)
        } else {
            print("Time zone is nil for city: \(city.name)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewHeightForRowAt
    }
}

extension ViewController: CitySearchViewControllerDelegate {
    func didEnterCityName(_ cityName: String) {
           NetworkService.fetchCityDetails(for: cityName) { result, error in
               if let error = error {
                   print("Ошибка: \(error)")
                   return
               }
               
               if let cityDetails = result?.results.first {
                   let timezone = cityDetails.annotations.timezone.name
                   print("Часовой пояс города \(cityName): \(timezone)")
                   
                   let newCity = City(name: cityName, timeZoneIdentifier: timezone)
                   self.cities.append(newCity)
                   
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               } else {
                   print("Информация о часовом поясе не найдена.")
               }
           }
       }
   }
