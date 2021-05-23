//
//  DecisionViewController.swift
//  Decidee
//
//  Created by Naufaldi Athallah Rifqi on 04/05/21.
//

import UIKit

class DecisionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var argumentTextField: UITextField!
    @IBOutlet weak var argumentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var prosTableView: UITableView!
    @IBOutlet weak var consTableView: UITableView!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var prosPercentageLabel: UILabel!
    @IBOutlet weak var consPercentageLabel: UILabel!
    @IBOutlet weak var importanceSlider: UISlider!
    @IBOutlet weak var addMoreButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var decisionItem : Decision?
    
    var decisionType : String = "Pros"
    var importance : Float = 0.0
    
    var prosItems:[Pros]?
    var consItems:[Cons]?
    
    var currentProsItems:[Pros] = []
    var currentConsItems:[Cons] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prosTableView.delegate = self
        prosTableView.dataSource = self
        consTableView.delegate = self
        consTableView.dataSource = self
        fetchData()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        self.prosItems = try! context.fetch(Pros.fetchRequest())
        self.consItems = try! context.fetch(Cons.fetchRequest())
        currentProsItems.removeAll()
        currentConsItems.removeAll()
        filterProsCons()
        DispatchQueue.main.async {
            self.prosTableView.reloadData()
            self.consTableView.reloadData()
        }
        calculatePercentage()
    }
    
    func initView() {
        self.title = decisionItem?.name
        self.addMoreButton?.layer.cornerRadius = 10
    }
    
    @IBAction func onChangedSlider(_ sender: UISlider) {
        importance = round(importanceSlider.value)
        importanceLabel.text = String(format: "%.0f", importance)
    }
    
    @IBAction func onChangedArgumentSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            decisionType = "Pros"
        case 1:
            decisionType = "Cons"
        default:
            decisionType = "Pros"
        }
    }
    
    
    @IBAction func onTapAddMore(_ sender: Any) {
        if decisionType == "Pros" {
            let newPros = Pros(context: self.context)
            newPros.name = argumentTextField.text
            newPros.importance = importance
            newPros.decision = decisionItem
//            decisionItem?.addToPros(newPros)
        } else if decisionType == "Cons" {
            let newCons = Cons(context: self.context)
            newCons.name = argumentTextField.text
            newCons.importance = importance
            newCons.decision = decisionItem
//            decisionItem?.addToCons(newCons)
        }
        try! self.context.save()
        self.fetchData()
        calculatePercentage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == prosTableView {
            return decisionItem?.pros?.count ?? 0
        }; return decisionItem?.cons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == prosTableView {
            let pros = currentProsItems[indexPath.row]
            if pros.decision == decisionItem {
                let cell = prosTableView.dequeueReusableCell(withIdentifier: "prosTableViewCell", for: indexPath)
                cell.textLabel?.text = pros.name
                cell.detailTextLabel?.text = String(format: "%.0f", pros.importance)
                return cell
            }
            
        } else if tableView == consTableView {
            let cons = currentConsItems[indexPath.row]
            if cons.decision == decisionItem {
                let cell = consTableView.dequeueReusableCell(withIdentifier: "consTableViewCell", for: indexPath)
                cell.textLabel?.text = cons.name
                cell.detailTextLabel?.text = String(format: "%.0f", cons.importance)
                return cell
            }
        };
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == prosTableView {
            return "Pros"
        } else {
            return "Cons"
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            
            if tableView == self.prosTableView {
                let prosToRemove = self.currentProsItems[indexPath.row]
                
//                if prosToRemove.decision == self.decisionItem {
                    //remove the pros
                self.context.delete(prosToRemove)
                self.currentProsItems.remove(at: indexPath.row)
                    
                    //save the data
                try! self.context.save()
                    
                    //refetch data
                self.fetchData()
//                }
                
            } else if tableView == self.consTableView {
                let consToRemove = self.currentConsItems[indexPath.row]
                
//                if consToRemove.decision == self.decisionItem {
                    //remove the cons
                self.context.delete(consToRemove)
                self.currentConsItems.remove(at: indexPath.row)
                    
                    //save the data
                try! self.context.save()
                    
                    //refetch data
                self.fetchData()
//                }
                
            }
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        print("back pressed")
//    }
    
    func calculatePercentage() {
        var totalPros : Float = 0.0
        var totalCons : Float = 0.0
        var totalProsCons : Float = 0.0
        var prosDivided : Float = 0.0
        var consDivided : Float = 0.0
        var prosPercentage = decisionItem?.prosPercentage
        var consPercentage = decisionItem?.consPercentage
        
        for pros in prosItems ?? [] {
            if pros.decision == decisionItem {
                totalPros += pros.importance
            }
            
        }
        for cons in consItems ?? [] {
            if cons.decision == decisionItem {
                totalCons += cons.importance
            }
            
        }
        
        totalProsCons = totalPros + totalCons
        
        prosDivided = Float(totalPros / totalProsCons)
        consDivided = Float(totalCons / totalProsCons)
        prosPercentage = round(prosDivided.isNaN ? 0 : prosDivided * 100.0)
        consPercentage = round(consDivided.isNaN ? 0 : consDivided * 100.0)
        prosPercentageLabel.text = String(format: "%.0f", prosPercentage ?? 0) + "%"
        consPercentageLabel.text = String(format: "%.0f", consPercentage ?? 0) + "%"
        
        decisionItem?.prosPercentage = prosPercentage ?? 0
        decisionItem?.consPercentage = consPercentage ?? 0
        
        try! self.context.save()
        
        
    }
    
    func filterProsCons() {
        for pros in self.prosItems ?? [] {
            if pros.decision == decisionItem {
                print(pros)
                currentProsItems.append(pros)
                print("masuk filter pros")
                print(currentProsItems.count)
            }
        }
        for cons in self.consItems ?? [] {
            if cons.decision == decisionItem {
                currentConsItems.append(cons)
                print("masuk filter cons")
                print(currentConsItems.count)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            print("back pressed")
            self.fetchData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
