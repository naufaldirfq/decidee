//
//  ViewController.swift
//  Decidee
//
//  Created by Naufaldi Athallah Rifqi on 04/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var decisionTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var addDecisionButton: UIBarButtonItem!
    @IBOutlet weak var noDataImageView: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var decisionItems:[Decision]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        decisionTableView.dataSource = self
        decisionTableView.delegate = self
        
        //Get Items from Core Data
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }

    func fetchData() {
        self.decisionItems = try! context.fetch(Decision.fetchRequest())
        DispatchQueue.main.async {
            self.decisionTableView.reloadData()
        }
        self.initView()
    }
    
    func initView() {
        if self.decisionItems?.count == 0 {
            print("no data")
            decisionTableView.isHidden = true
            noDataLabel.isHidden = false
            noDataImageView.isHidden = false
            
        } else {
            print("has data")
            decisionTableView.isHidden = false
            noDataLabel.isHidden = true
            noDataImageView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "decisionCell", for: indexPath) as? DecisionTableViewCell
        
        let decision = self.decisionItems![indexPath.row]
        
        cell?.decisionTitleLabel?.text = decision.name
        
        if decision.prosPercentage > decision.consPercentage {
            cell?.argumentLabel.text = "Pros : \(decision.prosPercentage)%"
            cell?.argumentImageView.tintColor = .green
        } else if decision.prosPercentage < decision.consPercentage {
            cell?.argumentLabel.text = "Cons : \(decision.consPercentage)%"
            cell?.argumentImageView.tintColor = .red
        } else {
            cell?.argumentLabel.text = "Tie"
            cell?.argumentImageView.tintColor = .systemBlue
        }
        
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        decisionItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completionHandler) in
            
            //which decision to remove
            let decisionToRemove = self.decisionItems![indexPath.row]
            
            //remove the decision
            self.context.delete(decisionToRemove)
            
            //save the data
            try! self.context.save()
            
            //refetch data
            self.fetchData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let decision = self.decisionItems![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Decisions", message: "What is your decision?", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = decision.name
        
        let editButton = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            //Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            //create decision object
            decision.name = textfield.text
            
            //save data
            try! self.context.save()
            
            //refetch data
            self.fetchData()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let decisionViewController = storyBoard.instantiateViewController(identifier: "decisionStoryboard") as DecisionViewController
            decisionViewController.decisionItem = decision
            self.navigationController?.pushViewController(decisionViewController, animated: true)
        }
        
        alert.addAction(editButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    @IBAction func addTapped(_ sender: Any) {
        //Create alert
        
        let alert = UIAlertController(title: "Add Decisions", message: "What is your decision?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            //create decision object
            let newDecision = Decision(context: self.context)
            newDecision.name = textfield.text
            
            //save data
            try! self.context.save()
            
            //refetch data
            self.fetchData()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let decisionViewController = storyBoard.instantiateViewController(identifier: "decisionStoryboard") as DecisionViewController
            decisionViewController.decisionItem = newDecision
            self.navigationController?.pushViewController(decisionViewController, animated: true)
            
            
        }
        
        //add button
        alert.addAction(submitButton)
        
        //show alert
        self.present(alert, animated: true, completion: nil)
    }

}

