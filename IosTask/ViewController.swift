//
//  ViewController.swift
//  IosTask
//
//  Created by Pawan Dhull on 15/06/21.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- OUTLETS
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectedDocsButton: UIButton!
    @IBOutlet weak var suggestionButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var NewRequestButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!


    //MARK:- CLASS CONSTANTS AND VARIABLES
    var SelectedIndex = 0 // 0 for first ,1 for second and 2 for thrd
    var MyNetworks = [Connection]()
    var SearchedNetworks = [Connection]()
    var isSearched = false
    
    
    //MARK:- LIFE CYCLE METHOD
    override func viewDidLoad() {
        super.viewDidLoad()
        tfSearch.delegate = self
        tfSearch.addTarget(self, action: #selector(TextIsChanging), for: .editingChanged)
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.cornerRadius = 5
        searchView.layer.cornerRadius = 10
        tfSearch.attributedPlaceholder =
        NSAttributedString(string: "Search Doctors", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        for aView in stackView.arrangedSubviews {
            aView.layer.cornerRadius = 5
        }
        setupTable()
        setupButton()
        apiCallForGetNetwords()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topConstraint.constant = self.view.safeAreaInsets.top + 10
       
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- SETUP TABLE
    func setupTable(){
        tableView.register(UINib(nibName: "TableViewCellForMyNetwork", bundle: nil), forCellReuseIdentifier: "TableViewCellForMyNetwork")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.separatorStyle = .none
    }
    
    //MARK:- SEARCH TF TEXT CHANGE
    @objc func TextIsChanging(_ tf : UITextField) {
        SearchedNetworks = tf.text!.isEmpty ? MyNetworks : (MyNetworks.filter{ ($0.inviteeProvider?.fullName?.range(of: tf.text! , options: [.caseInsensitive]) != nil ) })
        
        if tf.text?.trimmingCharacters(in: .whitespaces) == "" {
            isSearched = false
        }else {
            isSearched = true
        }

        DispatchQueue.main.async {
            self.setupTable()
        }
    }
    
    //MARK:- BUTTON ACTIONS
    @IBAction func SegmentButtonAction(_ sender: Any) {
        SelectedIndex = (sender as! UIButton).tag
        setupButton()
    }
    
    //MARK:- SETUP BUTTONS
    func setupButton(){
        connectedDocsButton.titleLabel?.textAlignment = .center //   sender.titleLabel?.textAlignment = NSTextAlignment.center

        switch SelectedIndex {
        case 0:
            connectedDocsButton.backgroundColor = .white
            connectedDocsButton.setTitleColor(.systemBlue, for: UIControl.State.init())
            
            NewRequestButton.backgroundColor = .systemBlue
            NewRequestButton.setTitleColor(UIColor.white, for: UIControl.State.init())
            suggestionButton.backgroundColor = .systemBlue
            suggestionButton.setTitleColor(UIColor.white, for: UIControl.State.init())
        case 1:
            connectedDocsButton.backgroundColor = .systemBlue
            connectedDocsButton.setTitleColor(UIColor.white, for: UIControl.State.init())
            NewRequestButton.backgroundColor = .white
            NewRequestButton.setTitleColor(UIColor.systemBlue, for: UIControl.State.init())
            suggestionButton.backgroundColor = .systemBlue
            suggestionButton.setTitleColor(UIColor.white, for: UIControl.State.init())
        case 2:
            connectedDocsButton.backgroundColor = .systemBlue
            connectedDocsButton.setTitleColor(UIColor.white, for: UIControl.State.init())
            NewRequestButton.backgroundColor = .systemBlue
            NewRequestButton.setTitleColor(UIColor.white, for: UIControl.State.init())
            suggestionButton.backgroundColor = .white
            suggestionButton.setTitleColor(UIColor.systemBlue, for: UIControl.State.init())
        default : break
        }
    }


}


extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearched ? SearchedNetworks.count : MyNetworks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellForMyNetwork", for: indexPath) as? TableViewCellForMyNetwork {
            let thisNetwork = isSearched ? SearchedNetworks[indexPath.row].inviteeProvider : MyNetworks[indexPath.row].inviteeProvider
            cell.label1.text = thisNetwork?.fullName ?? ""
            let imageview =  cell.personimage
            if let url = URL(string: thisNetwork?.photoID ?? "") {
            imageview?.loadImageWithUrl(url)
            }else{
            imageview?.image = UIImage.init(named: "doctor")
            }
            cell.label2.text = thisNetwork?.title ?? "--"
            cell.label3.text = thisNetwork?.offices?.first?.name ?? "--"
            cell.label4.text = thisNetwork?.offices?.first?.fullAddressWithoutCountry ?? "--"
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
}



extension ViewController {
    //MARK:- API CALL
    func apiCallForGetNetwords(){
       
        startAnimating(self.view)
      
        let params = [String: Any]()
        PrintToConsole("parameters for create request \(params)")
        let urlString = "https://raw.githubusercontent.com/pwndhull/cityapi/main/Test-api.json"
        
        ApiManager.shared.Request(type: TaskModel.self, methodType: .Get, url: urlString , parameter: params) { (error, response, message, statusCode) in
            if statusCode == 200 {
                print("response of  api \(String(describing: response))")
                DispatchQueue.main.async {
                if response == nil {
                    Toast.show(message: "No Record Found", controller: self)
                    return
                }else {
                    self.MyNetworks = response?.data?.connections ?? []
                    //Connecting Delegates and Datasource of Table view
                    self.setupTable()
                    
            }
                }
            }else {
                if let msgStr = message {
                    Toast.show(message: msgStr, controller: self)
                }else {
                    Toast.show(message: "SOMETHING WENT WRONG !", controller: self)
                }
            }
        }
    }
    
}


