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
    var data = Data()
    let weatherURL = PListHelper().getInfo(key: "weather")

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
            try NetworkingHelper().startLoad([Weather].self, "\(weatherURL)", funcSucess, funcError)
        } catch {
            self.funcAlert(alertMessage: "Error Weather not is Decodable")
            activityIndicator.stopAnimating()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedIndex = indexPath.row
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherTableViewCell
        cell.weatherLabel.text = weather[selectedIndex].name.capitalized
        cell.weatherSwitch.tag = selectedIndex
        if data.weather.contains(where: {$0.id == weather[selectedIndex].id})  {
            cell.weatherSwitch.setOn(true, animated: true)
        } else {
            cell.weatherSwitch.setOn(false, animated: true)
        }
        return cell
    }
    
    func funcSucess(weather: [Weather])  {
        DispatchQueue.main.async {
            self.weather = weather
            self.weatherTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    func funcError(error: NetworkingHelperError)  {
        DispatchQueue.main.async {
            switch error {
            case NetworkingHelperError.RequestError:
                self.funcAlert(alertMessage: "Error requesting")
            case NetworkingHelperError.HttpStatusError:
                self.funcAlert(alertMessage: "Error HTTP Status")
            case NetworkingHelperError.SerializationJsonError:
                self.funcAlert(alertMessage: "Error serialization JSON")
            }
            self.activityIndicator.stopAnimating()
        }
    }

    @IBAction func onChangeItem(_ sender: UISwitch) {
        let index: Int = sender.tag
        if sender.isOn {
            data.weather.append(weather[index])
        } else {
            data.weather = data.weather.filter() {$0.id != weather[index].id}
        }
    }
    
    func funcAlert(alertMessage : String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
