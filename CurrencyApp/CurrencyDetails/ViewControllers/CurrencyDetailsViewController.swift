//
//  CurrencyDetailsViewController.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 22/11/2020.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class CurrencyDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    //MARK: - Private properties
    
    private var viewModel: CurrencyDetailsViewModel!
    private var lineChart = LineChartView()
    private let disposeBag = DisposeBag()
    private let datePicker = UIDatePicker()
    
    public var rates: Rates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = rates?.currency
        lineChart.delegate = self
        populateViews()
        createDatePicker()
    }
    
}

//MARK: Fetch results

extension CurrencyDetailsViewController {
    func populateViews() {
        guard let rates = rates?.code else { return }
        let resources = Resource<GraphRatesResponse>(url: URL(string: "http://api.nbp.pl/api/exchangerates/rates/a/\(rates)/\(startDateTextField.text!)/\(endDateTextField.text!)/?format=json")!)
        URLRequest.load(resource: resources)
            .subscribe(onNext: { ratesResponse in
                self.viewModel = CurrencyDetailsViewModel(ratesResponse.rates)
                DispatchQueue.main.async { [self] in
                    self.setupChartView()
                }
            }, onError: { error in
                print("error\(error)")
            }).disposed(by: disposeBag)
    }
}

//MARK: - Chart

extension CurrencyDetailsViewController: ChartViewDelegate {
    func setupChartView() {
        
        //View Configuration
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        for x in 1..<self.viewModel.ratesGraphViewModel.count{
            let x = x
            let y = viewModel.ratesGraphViewModel[x].rates.mid
            entries.append(ChartDataEntry(x: Double(x), y:y))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
}

//MARK: DatePicker

extension CurrencyDetailsViewController {
    
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        startDateTextField.inputView = datePicker
        startDateTextField.inputAccessoryView = createToolBar()
        endDateTextField.inputView = datePicker
        endDateTextField.inputAccessoryView = createToolBar()
        
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if self.startDateTextField.isFirstResponder {
            self.startDateTextField.text = dateFormatter.string(from: datePicker.date)}
        else if self.endDateTextField.isFirstResponder {
            self.endDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        populateViews()
        self.view.endEditing(true)
    }
}
