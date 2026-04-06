//
//  CountriesFetch.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//
// countries API KEY


import Foundation
import Combine

final class CountriesFetch: ObservableObject {
    static let shared = CountriesFetch()
    
    @Published var fetchedSend: [Country] = []
    @Published var allCountries: [Country] = []
    
    var cancellables = Set<AnyCancellable>()
    
    var sendCountries = ["tanzania", "rwanda", "uganda", "zambia", "malawi", "botswana", "burundi", "pakistan", "bangladesh"]
    
    func fetchSendCountries() async throws {
        for country in sendCountries {
            // extract each country and fetch its details
            guard let url = URL(string: "https://restcountries.com/v3.1/name/\(country)") else { return }
//            let (data, result) = URLSession.shared.data(from: url)
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap(downlaodData)
                .decode(type: [Country].self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Finished \(completion)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] countries in
                    self?.fetchedSend.append(contentsOf: countries)
                }
                .store(in: &cancellables)
        }
    }

    func fetchAllCountries() async throws {
            guard let url = URL(string: "https://restcountries.com/v3.1/all") else { return }
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap(downlaodData)
                .decode(type: [Country].self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Finished \(completion)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: {  _ in
                    // append here
                }
                .store(in: &cancellables)
    }

    func downlaodData(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw URLError(.badServerResponse)
              }
        return output.data
    }
    
}


final class AllCountries {
    static let shared = AllCountries()
    var cancellables = Set<AnyCancellable>()

    var allCountries: [Country] = []
    
    // Add the missing countryCurrencyArray
    var countryCurrencyArray: [String: String] = [
        "Afghanistan": "AFN", "Albania": "ALL", "Algeria": "DZD", "Andorra": "EUR", "Angola": "AOA",
        "Argentina": "ARS", "Armenia": "AMD", "Australia": "AUD", "Austria": "EUR", "Azerbaijan": "AZN",
        "Bahamas": "BSD", "Bahrain": "BHD", "Bangladesh": "BDT", "Barbados": "BBD", "Belarus": "BYN",
        "Belgium": "EUR", "Belize": "BZD", "Benin": "XOF", "Bermuda": "BMD", "Bhutan": "BTN",
        "Bolivia": "BOB", "Botswana": "BWP", "Brazil": "BRL", "Brunei": "BND", "Bulgaria": "BGN",
        "Burundi": "BIF", "Cambodia": "KHR", "Cameroon": "XAF", "Canada": "CAD", "Cape Verde": "CVE",
        "Central African Republic": "XAF", "Chad": "XAF", "Chile": "CLP", "China": "CNY", "Colombia": "COP",
        "Comoros": "KMF", "Costa Rica": "CRC", "Croatia": "HRK", "Cuba": "CUP", "Cyprus": "EUR",
        "Czech Republic": "CZK", "Denmark": "DKK", "Djibouti": "DJF", "Dominica": "XCD", "Dominican Republic": "DOP",
        "Ecuador": "USD", "Egypt": "EGP", "El Salvador": "USD", "Equatorial Guinea": "XAF", "Eritrea": "ERN",
        "Estonia": "EUR", "Ethiopia": "ETB", "Fiji": "FJD", "Finland": "EUR", "France": "EUR",
        "Gabon": "XAF", "Gambia": "GMD", "Georgia": "GEL", "Germany": "EUR", "Ghana": "GHS",
        "Greece": "EUR", "Grenada": "XCD", "Guatemala": "GTQ", "Guinea": "GNF", "Guinea-Bissau": "XOF",
        "Guyana": "GYD", "Haiti": "HTG", "Honduras": "HNL", "Hong Kong": "HKD", "Hungary": "HUF",
        "Iceland": "ISK", "India": "INR", "Indonesia": "IDR", "Iran": "IRR", "Iraq": "IQD",
        "Ireland": "EUR", "Israel": "ILS", "Italy": "EUR", "Jamaica": "JMD", "Japan": "JPY",
        "Jordan": "JOD", "Kazakhstan": "KZT", "Kenya": "KES", "Kiribati": "AUD", "Kuwait": "KWD",
        "Kyrgyzstan": "KGS", "Laos": "LAK", "Latvia": "EUR", "Lebanon": "LBP", "Lesotho": "LSL",
        "Liberia": "LRD", "Libya": "LYD", "Liechtenstein": "CHF", "Lithuania": "EUR", "Luxembourg": "EUR",
        "Macao": "MOP", "Madagascar": "MGA", "Malawi": "MWK", "Malaysia": "MYR", "Maldives": "MVR",
        "Mali": "XOF", "Malta": "EUR", "Marshall Islands": "USD", "Mauritania": "MRU", "Mauritius": "MUR",
        "Mexico": "MXN", "Micronesia": "USD", "Moldova": "MDL", "Monaco": "EUR", "Mongolia": "MNT",
        "Montenegro": "EUR", "Morocco": "MAD", "Mozambique": "MZN", "Myanmar": "MMK", "Namibia": "NAD",
        "Nauru": "AUD", "Nepal": "NPR", "Netherlands": "EUR", "New Zealand": "NZD", "Nicaragua": "NIO",
        "Niger": "XOF", "Nigeria": "NGN", "North Korea": "KPW", "North Macedonia": "MKD", "Norway": "NOK",
        "Oman": "OMR", "Pakistan": "PKR", "Palau": "USD", "Palestine": "ILS", "Panama": "PAB",
        "Papua New Guinea": "PGK", "Paraguay": "PYG", "Peru": "PEN", "Philippines": "PHP", "Poland": "PLN",
        "Portugal": "EUR", "Qatar": "QAR", "Romania": "RON", "Russia": "RUB", "Rwanda": "RWF",
        "Saint Kitts and Nevis": "XCD", "Saint Lucia": "XCD", "Saint Vincent and the Grenadines": "XCD", "Samoa": "WST", "San Marino": "EUR",
        "Sao Tome and Principe": "STN", "Saudi Arabia": "SAR", "Senegal": "XOF", "Serbia": "RSD", "Seychelles": "SCR",
        "Sierra Leone": "SLL", "Singapore": "SGD", "Slovakia": "EUR", "Slovenia": "EUR", "Solomon Islands": "SBD",
        "Somalia": "SOS", "South Africa": "ZAR", "South Korea": "KRW", "South Sudan": "SSP", "Spain": "EUR",
        "Sri Lanka": "LKR", "Sudan": "SDG", "Suriname": "SRD", "Sweden": "SEK", "Switzerland": "CHF",
        "Syria": "SYP", "Taiwan": "TWD", "Tajikistan": "TJS", "Tanzania": "TZS", "Thailand": "THB",
        "Timor-Leste": "USD", "Togo": "XOF", "Tonga": "TOP", "Trinidad and Tobago": "TTD", "Tunisia": "TND",
        "Turkey": "TRY", "Turkmenistan": "TMT", "Tuvalu": "AUD", "Uganda": "UGX", "Ukraine": "UAH",
        "United Arab Emirates": "AED", "United Kingdom": "GBP", "United States": "USD", "Uruguay": "UYU", "Uzbekistan": "UZS",
        "Vanuatu": "VUV", "Vatican City": "EUR", "Venezuela": "VES", "Vietnam": "VND", "Yemen": "YER",
        "Zambia": "ZMW", "Zimbabwe": "ZWL"
    ]
    
    func fetchAllCountries() async throws {
            guard let url = URL(string: "https://restcountries.com/v3.1/all") else { return }
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap(downlaodData)
                .decode(type: [Country].self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Finished \(completion)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: {  receivedCountries in
                    self.allCountries = receivedCountries
                }
                .store(in: &cancellables)
    }
    
    func downlaodData(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw URLError(.badServerResponse)
              }
        return output.data
    }
}
