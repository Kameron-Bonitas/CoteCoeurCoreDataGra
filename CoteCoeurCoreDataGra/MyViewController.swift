//
//  MyViewController.swift
//  CoteCoeurCoreDataGra
//
//  Created by Ben on 16.02.2020.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import CoreData
import MGSwipeTableCell

class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate  {

    //MARK: - Properties
            let backgroundImage = UIImageView()
            let titleLabel = UILabel()
            var plusButton = UIButton()
   
    var myAffis : [MyAffirmationItem] = []
    
       private let cellIdentifier = "MyTableViewCell"
    
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
        tableview.reloadData()
        zaraza()
        view.backgroundColor = .white
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print(myAffis)
    }
    
    
    //  MARK: - Button ACTIONS
       @objc  func plusPopUpAction(){
           let popaVC = PopUpViewController ()
               popaVC.modalPresentationStyle = .overCurrentContext
        popaVC.editingAffi = false
              self.present(popaVC, animated: true, completion: nil)
              print("Dupa!")
          }
    
    
    func setupTableView() {
              tableview.delegate = self
              tableview.dataSource = self
        
        tableview.register(MyTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            
            tableview.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 34),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        
        }
    
    //  MARK: Setup Layout
           private func setupLayout() {
          
       
           //titleLabel
           titleLabel.text = "My Affirmations"
           titleLabel.textAlignment = .center
           titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 40)
           self.view.addSubview(titleLabel)
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
               titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:0.0)
           ])
           
           //plusButton
            plusButton.addTarget(self, action: #selector( plusPopUpAction), for: .touchUpInside)
           plusButton.setImage(UIImage(named: "bitmap.png"), for: .normal)
            view.addSubview(plusButton)
           
            plusButton.translatesAutoresizingMaskIntoConstraints = false
          
            NSLayoutConstraint.activate([
               plusButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
               plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:0.0)
           ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // 1
          return myAffis.count
       }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyTableViewCell
//        /Prozzorist' of cell
        cell.backgroundColor = .clear
        cell.numberLabel.text = "\(indexPath.row+1)"
        
        //    Coreeeeeeeeeeeeeeeeeeeeeeeeee
        let myAffi = myAffis[indexPath.row]
        cell.noteLabel.text = myAffi.name
        //        Selection of cell is off
                cell.selectionStyle = .none
        
        //  SWIPE CONFIGURATION
//configure left button Reminder
cell.leftButtons =
                [MGSwipeButton(title: "", icon: UIImage(named:"bitmap" ), backgroundColor: .green){
                                       [weak self] sender in

                                       return true
    },
//MARK:   EDIT
MGSwipeButton(title: "Edit", backgroundColor: .blue){
                                   [weak self] sender in

        let popaVC = PopUpViewController ()
       popaVC.modalPresentationStyle = .overCurrentContext
    popaVC.transferedAffi = self!.myAffis[indexPath.row]
    
    popaVC.editingAffi = true
    popaVC.textNewAffirmation.text = self!.myAffis[indexPath.row].name
    
    
    
  
        self?.present(popaVC, animated: true, completion: nil)
        print("Popa!")

        return true

                    }]

                cell.leftSwipeSettings.transition = .rotate3D

//configure right button Delete
                cell.rightButtons =
                [MGSwipeButton(title: "Delete", backgroundColor: .red, padding: 50) {
                            [weak self] sender in
//                    let myAffi = self?.myAffis[indexPath.row]
//                    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//                        context.delete(myAffi!)
//                                                 (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
//                                                self?.zaraza()
//                        }
                    print("Delete myAffi")
                            return true
                                       }]
                cell.rightSwipeSettings.transition = .rotate3D
                cell.rightExpansion.buttonIndex = 0


        return cell
    }
    
    
    
    //MARK:- Navigation. Making Navigation Bar Prozzoroyu UND Fetching all Affis
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
       
        
        }
    
    
    
    //  MARK: FUNCTIONS
    
    func reloadTable() -> () {
           zaraza()
                 print("Relodnula Table")
             }
    
//      MARK: - Fetching z perezavantazhennyam stola
    //   Coreeeeeeeeeeeeeeeeeeeeeeeeee
    func zaraza ()-> (){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let coreDataMyAffirmationItems = try? context.fetch(MyAffirmationItem.fetchRequest()) as? [MyAffirmationItem] {
            myAffis = coreDataMyAffirmationItems
        tableview.reloadData()
            print("Fetching")
                }
            }
        }
    
   
}
