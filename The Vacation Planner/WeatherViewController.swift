//
//  WeatherViewController.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 25/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var weatherTableView: UITableView!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    var weather: [Weather] = Array()
    var weatherSelected: [Weather] = Array()
    
    var data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTableView.delegate = self
        weatherTableView.dataSource = self

        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)

        do {
            activityIndicator.startAnimating()
            try URLHelper().startLoad([Weather].self, "http://localhost:8882/weather/", funcSucess, funcError)
        } catch {
            print("Error City not is Decodable")
            activityIndicator.stopAnimating()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.total = weather.count
        return weather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedIndex = indexPath.row
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherTableViewCell
        cell.weatherLabel.text = weather[selectedIndex].name.capitalized
        if weatherSelected.contains(where: {$0.id == weather[selectedIndex].id})  {
            cell.weatherSwitch.setOn(true, animated: true)
        }
    
        cell.weatherSwitch.restorationIdentifier = String(weather[selectedIndex].id)

        return cell
    }
    
    func funcSucess(weather: [Weather])  {
        DispatchQueue.main.async {
            self.weather = weather
            self.weatherTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    func funcError(error: URLHelperError)  {
        DispatchQueue.main.async {
            switch error {
            case URLHelperError.RequestError:
                print("Error requesting")
            case URLHelperError.HttpStatusError:
                print("Error HTTP Status")
            case URLHelperError.SerializationJsonError:
                print("Error serialization JSON")
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    @IBAction func onChangeItem(_ sender: UISwitch) {
        let id:String = sender.restorationIdentifier!

        if sender.isOn {
            data.checkedIds.append(id)
        } else {
            data.checkedIds = data.checkedIds.filter() {$0 != id}
        }
    }
}
