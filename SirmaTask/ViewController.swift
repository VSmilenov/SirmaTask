//
//  ViewController.swift
//  SirmaTask
//
//  Created by Vasil Smilenov on 9/8/24.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var byNameSearchBar: UISearchBar!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var countryPickerView: UIPickerView!
    var countries = [Country]()
    var filteredCountries = [Country]()
    var selectedLanguage: String = "BG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        fetchCountries(language: selectedLanguage)
    }
    
    // Called when the language is changed using the segmented control
    @IBAction func languageChanged(_ sender: Any) {
        selectedLanguage = languageSegmentedControl.titleForSegment(at: languageSegmentedControl.selectedSegmentIndex) ?? "EN"
        fetchCountries(language: selectedLanguage)
        
        // Clear the search bar text after changing the language
        byNameSearchBar.text = ""
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredCountries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredCountries[row].name
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountries(searchText: searchText)
    }
    
    // Filter countries based on the search text
    private func filterCountries(searchText: String) {
        if searchText.isEmpty {
            // If search bar is empty, show all countries
            filteredCountries = countries
        } else {
            // Filter countries based on the search text
            filteredCountries = countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        // Reload the picker view with the filtered countries
        countryPickerView.reloadAllComponents()
    }
    
    // Method to fetch the list of countries from the API
    private func fetchCountries(language: String) {
        CountryService.shared.fetchCountries(language: language) { result in
            switch result {
            case .success(let countries):
                // Handle successful response
                self.handleSuccess(countries: countries)
            case .failure(let error):
                // Handle error
                self.handleError(error: error)
            }
        }
    }
    
    
    private func handleSuccess(countries: [Country]) {
        self.countries = countries.sorted { $0.name < $1.name }
        self.filteredCountries = self.countries
        DispatchQueue.main.async {
            self.countryPickerView.reloadAllComponents()
        }
    }
    
    private func handleError(error: Error) {
        // Print or handle the error
        print("Request failed with error: \(error.localizedDescription)")
    }
}
