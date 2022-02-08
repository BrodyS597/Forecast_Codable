//
//  DayDetailsViewController.swift
//  Forecast_Codable
//
//  Created by Karl Pfister on 2/6/22.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    private var days = [Day]()
    private var forcastData: TopLevelDictionary?
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayForcastTableView.dataSource = self
        dayForcastTableView.delegate = self
        
        NetworkController.fetchDays { forcastData in
            guard let forcastData = forcastData else { return }
            self.days = forcastData.days
            self.forcastData = forcastData
            DispatchQueue.main.async {
                self.updateViews(index: 0)
                self.dayForcastTableView.reloadData()
            }
        }
    }
    
    // MARK: -Helper Func
    func updateViews(index: Int) {
        let currentDay = days[index]
        //        guard let forcastData = forcastData else { return }
        
        cityNameLabel.text = forcastData?.cityName
        currentDescriptionLabel.text = currentDay.weather.description
        currentLowLabel.text = "\(currentDay.lowTemp)"
        currentHighLabel.text = "\(currentDay.highTemp)"
        currentTempLabel.text = "\(currentDay.temp)"
    }
}

//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        let day = days[indexPath.row]
        cell.updateViews(day: day)
        
        return cell
    }
}

