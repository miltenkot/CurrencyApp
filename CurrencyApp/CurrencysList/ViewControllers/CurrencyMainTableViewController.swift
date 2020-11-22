//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Bartek Lanczyk on 21/11/2020.
//
import Foundation
import UIKit
import RxSwift

class CurrencyMainTableViewController: UITableViewController {
    
    //MARK: - Private properties
    
    private let disposeBag = DisposeBag()
    private var viewModel: CurrencyListViewModel!
    private var parameter: String = "a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120;
        setupUI()
        setupTableView()
        populateViews(parameter)
    }
    
    //MARK: - Setups
    
    private func setupTableView() {
        let nib = UINib(nibName: "CurrencyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "currencyTableViewCell")
    }
    
    func setupUI() {
        title = "currency.app.barTitle".localized
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupRefreshControll()
    }
    
    func setupRefreshControll() {
        
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "refresh.spinner".localized)
        refreshControl.addTarget(self, action: #selector(refreshCoins), for: .valueChanged)
    }
    
    //MARK: - Update
    
    func updateUIWithCoins() {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    @objc func refreshCoins() {
        self.populateViews(parameter)
    }
    
}

//MARK: - Fetch results

extension CurrencyMainTableViewController {
    @objc func populateViews(_ parameter: String) {
        let resources = Resource<[RatesResponse]>(url: URL(string: "http://api.nbp.pl/api/exchangerates/tables/\(parameter)/?format=json")!)
        URLRequest.load(resource: resources)
            .subscribe(onNext: { ratesResponse in
                guard let rates = ratesResponse.first?.rates, let date = ratesResponse.first?.effectiveDate else { return }
                self.viewModel = CurrencyListViewModel(date, rates)
                
                DispatchQueue.main.async { [self] in
                    self.updateUIWithCoins()
                }
            }).disposed(by: disposeBag)
    }
}

//MARK: TableView Controller

extension CurrencyMainTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rates = viewModel.ratesViewModel[indexPath.row].rates
        
        guard let destinationViewController = (storyboard?.instantiateViewController(withIdentifier: "currencyDetailsViewController")) as? CurrencyDetailsViewController else { return }
        
        destinationViewController.rates = rates
        
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel == nil ? 0 : self.viewModel.ratesViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyTableViewCell", for: indexPath) as? CurrencyTableViewCell else { fatalError("currencyTableViewCell.error".localized) }
        
        let currencyViewModel = self.viewModel.ratesAt(indexPath.row)
        currencyViewModel.currency.asDriver(onErrorJustReturn: "").drive(cell.currencyLabel.rx.text).disposed(by: disposeBag)
        currencyViewModel.code.asDriver(onErrorJustReturn: "").drive(cell.codeLabel.rx.text).disposed(by: disposeBag)
        currencyViewModel.mid.asDriver(onErrorJustReturn: "").drive(cell.midLabel.rx.text).disposed(by: disposeBag)
        cell.dateLabel.text = self.viewModel.date
        
        return cell
    }
}

//MARK: Switch

extension CurrencyMainTableViewController {
    
    //MARK: Switch IBAction
    
    @IBAction func switchTableViewContent(_ sender: UISwitch) {
        
        if (sender.isOn == true) {
            parameter = "a" } else {
                parameter = "b"
            }
        
        DispatchQueue.main.async {
            self.populateViews(self.parameter)
            self.updateUIWithCoins()
        }
    }
}

