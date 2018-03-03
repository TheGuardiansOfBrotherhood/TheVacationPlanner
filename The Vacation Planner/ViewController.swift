//
//  ViewController.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import UIKit

class Data {
    var weather: [Weather] = Array()
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var weatherTableView: UITableView!

    let days: [Int] = Array(1...30)
    var cities: [City] = Array()
    var titles: [String] = ["Clima"]
    var data = Data()

    var dayPickerView: UIPickerView = UIPickerView()
    var cityPickerView: UIPickerView = UIPickerView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        dayPickerView.tag = 0

        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        cityPickerView.tag = 1

        dayField.inputView = dayPickerView
        dayField.textAlignment = .center
        dayField.placeholder = "Selecione quantidade de dias"

        cityField.inputView = cityPickerView
        cityField.textAlignment = .center
        cityField.placeholder = "Selecione a cidade"
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)

        weatherTableView.delegate = self
        weatherTableView.dataSource = self

        do {
            activityIndicator.startAnimating()
            try URLHelper().startLoad([City].self, "http://localhost:8882/cities/", funcSucess, funcError)
        } catch {
            print("Error City not is Decodable")
            activityIndicator.stopAnimating()
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return days.count
        } else if (pickerView.tag == 1) {
            return cities.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return "\(days[row])"
        } else if (pickerView.tag == 1) {
            return "\(cities[row].district) - \(cities[row].stateAcronym.localizedUppercase)"
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            dayField.text = "\(days[row])"
            dayField.resignFirstResponder()
        } else if (pickerView.tag == 1) {
            cityField.text = "\(cities[row].district) - \(cities[row].stateAcronym.localizedUppercase)"
            cityField.resignFirstResponder()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = titles[indexPath.row].capitalized
        cell?.detailTextLabel?.text = String(data.weather.count)
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showWeather", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeather" {
            if let destination = segue.destination as? WeatherViewController {
                destination.data = data
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weatherTableView.reloadData()
    }

    func funcSucess(cities: [City])  {
        DispatchQueue.main.async {
            self.cities = cities
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

}
