//
//  ViewController.swift
//  APOD
//
//  Created by Venkatesh S on 15/04/22.
//

import UIKit
import SDWebImage

class ViewController: BaseViewController {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var apodImage: UIImageView!
    @IBOutlet weak var apodExplanation: UITextView!
    var datePicker: UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var favBtnImage: UIButton!
    
    var showFavAPODS = [APODModel]()
    var isFav = false
    var selectedDate : String {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: todaysDate)
    }
    private let viewModel: APODViewModel = APODDefaultViewModel(
        networkService: DefaultNetworkService()
    )
    var apod : APODModel?  = APODModel(){
        didSet {
            DispatchQueue.main.async{
                self.titleLbl.text = self.apod?.title
                self.dateLbl.text = self.apod?.date
                self.apodExplanation.text = self.apod?.explanation
                if let value = self.apod?.hdurl, self.apod?.media_type == "image" {
                    self.apodImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.apodImage.sd_setImage(with: URL(string:  value), placeholderImage: UIImage(named: "Placeholder"))
                }
                self.favBtnImage.isHidden = false
                if DBManager.shared.checkIfItemExist(date: self.apod?.date ?? "") {
                    let image = UIImage(named: "Fav")
                    self.favBtnImage.setImage(image, for: .normal)
                    self.isFav = true
                }else {
                    let image = UIImage(named: "NotFav")
                    self.favBtnImage.setImage(image, for: .normal)
                    self.isFav = false
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        fetchAPODData()
        bindViewModelEvent()
        self.favBtnImage.isHidden = true
        self.title = "APOD (NASA) Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchByDate))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(showFavourites))

        showFavAPODS = DBManager.shared.getsavedAPOD()
        // Do any additional setup after loading the view.
    }

    private func fetchAPODData() {
        viewModel.fetchAPOD()
    }
    
    private func bindViewModelEvent() {
        viewModel.onFetchAPODSucceed = { [weak self] in
            self?.apod = self?.viewModel.apod
        }
        viewModel.onFetchAPODFailure = { error in
            DispatchQueue.main.async {
                self.showAlert(message:error.localizedDescription )
            }
        }
    }
    
    @objc private func searchByDate(){
        // Create a DatePicker
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date() // today date
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: .valueChanged)
        // Add DataPicker to the view
        self.view.addSubview(datePicker)
    }

    @objc private func showFavourites(){
        showFavAPODS = DBManager.shared.getsavedAPOD()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesTableViewController") as? FavouritesTableViewController
        vc?.apods = showFavAPODS
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func favBtnImageAction(_ sender: Any) {

        if favBtnImage.currentImage == UIImage(named: "Fav") {
            let image = UIImage(named: "NotFav")
            favBtnImage.setImage(image, for: .normal)
            isFav = false
        } else {
            let image = UIImage(named: "Fav")
             favBtnImage.setImage(image, for: .normal)
             isFav = true
        }
        
        if isFav && !DBManager.shared.checkIfItemExist(date: apod?.date ?? "") {
            saveAPOD()
        }
        if !isFav  && DBManager.shared.checkIfItemExist(date: apod?.date ?? ""){
            DBManager.shared.deleteAPOD(date: apod?.date ?? "")
        }

    }
    
    func saveAPOD() {
        if let apodItem = apod {
            DBManager.shared.save(apod: apodItem)
            self.showAlert(message: "\(String(describing: apodItem.title ?? "")) -- Saved Successfully")
        }
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
        viewModel.searchByDate = selectedDate
        fetchAPODData()
        self.datePicker.removeFromSuperview()

    }
}

extension ViewController : SpinnerDelegates {
    func showLoading() {
        Util.shared.showLoader(view: self.view)
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            Util.shared.hideLoader()
        }
    }
    
    
}
