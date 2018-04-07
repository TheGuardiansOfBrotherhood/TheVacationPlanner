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
    @IBOutlet weak var periodsTableView: UITableView!

    let days: [Int] = [10, 15, 20, 30]
    var cities: [City] = Array()
    let titles: [String] = ["Clima"]
    let data = Data()
    var weatherForecast: [WeatherForecast] = Array()
    var day: Int = 15
    var city: City? = nil
    var periods: [[WeatherForecast]] = Array()
    let formatter = DateFormatter()
    let citiesURL = PListHelper().getInfo(key: "cities")
    let weatherForecastURL = PListHelper().getInfo(key: "weatherForecast")

    var dayPickerView: UIPickerView = UIPickerView()
    var cityPickerView: UIPickerView = UIPickerView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBAction func SearchWeatherForecast(_ sender: Any) {
        periods = Array()
        periodsTableView.reloadData()
        if let city = self.city {
            do {
                activityIndicator.startAnimating()
                let date = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: date)
                var finalURL = weatherForecastURL.replacingOccurrences(of: "{cityId}", with: "\(city.woeid)")
                finalURL = finalURL.replacingOccurrences(of: "{year}", with: "\(components.year!)")
                try NetworkingHelper().startLoad([WeatherForecast].self, "\(finalURL)", funcSucessWeatherForecast, funcError)
            } catch {
                self.funcAlert(alertMessage: "Error WeatherForecast not is Decodable")
                activityIndicator.stopAnimating()
            }
        } else {
            self.funcAlert(alertMessage: "Error select city")
        }
    }

    func funcSucessWeatherForecast(weatherForecast: [WeatherForecast])  {
        if (!self.data.weather.isEmpty) {
            self.weatherForecast = weatherForecast.filter({ (item) -> Bool in
                self.data.weather.contains(where: { $0.name == item.weather})
            })
            
            self.formatter.dateFormat = "yyyy-MM-dd"
            
            var after: WeatherForecast? = nil
            var elements: [WeatherForecast] = Array()
            
            self.weatherForecast.forEach({ (item) in
                if let after = after {
                    if self.formatter.date(from: item.date) != self.formatter.date(from: after.date)?.addingTimeInterval(86400) {
                        self.periods.append(elements)
                        elements = Array()
                    }
                }
                elements.append(item)
                after = item
            })
            self.periods.append(elements)
            
            self.periods = self.periods.filter({ (item) -> Bool in
                item.count >= self.day
            })
            
            if (self.periods.isEmpty) {
                self.funcAlert(alertMessage: "Error no period found")
            }
        } else {
            self.funcAlert(alertMessage: "Error select weather")
        }

        DispatchQueue.main.async {
            self.periodsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.locale = Locale(identifier: "pt_BR")

        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        dayPickerView.tag = 0

        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        cityPickerView.tag = 1

        dayField.inputView = dayPickerView
        cityField.inputView = cityPickerView
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)

        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.tag = 0

        periodsTableView.delegate = self
        periodsTableView.dataSource = self
        periodsTableView.tag = 1

        do {
            activityIndicator.startAnimating()
            try NetworkingHelper().startLoad([City].self, "\(citiesURL)", funcSucessCities, funcError)
        } catch {
            self.funcAlert(alertMessage: "Error City not is Decodable")
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
            day = days[row]
            dayField.text = "\(days[row])"
            dayField.resignFirstResponder()
        } else if (pickerView.tag == 1) {
            city = cities[row]
            cityField.text = "\(cities[row].district) - \(cities[row].stateAcronym.localizedUppercase)"
            cityField.resignFirstResponder()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 0) {
            return titles.count
        } else if (tableView.tag == 1) {
            return periods.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.tag == 0) {
            let cell = weatherTableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = titles[indexPath.row].capitalized
            cell?.detailTextLabel?.text = String(data.weather.count)
            return cell!
        } else if (tableView.tag == 1) {
            let cell = periodsTableView.dequeueReusableCell(withIdentifier: "periodCell")
            if let initial = periods[indexPath.row].first?.date,
                let final = periods[indexPath.row].last?.date {

                formatter.dateFormat = "yyyy-MM-dd"
                let initialDate = formatter.date(from: initial)
                let finalDate = formatter.date(from: final)

                formatter.dateFormat = "dd 'de' MMMM"
                let initialDateString = formatter.string(from: initialDate!)
                let finalDateString = formatter.string(from: finalDate!)
                cell?.textLabel?.text = "De \(initialDateString) a \(finalDateString)"
            }
            return cell!
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.tag == 0) {
            performSegue(withIdentifier: "showWeather", sender: self)
        }
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

    func funcSucessCities(cities: [City])  {
        DispatchQueue.main.async {
            self.cities = cities
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
    
    func funcAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
