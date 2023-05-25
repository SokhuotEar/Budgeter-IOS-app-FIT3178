//
//  databaseController.swift
//  3178_Assignment_Project
//
//  Created by Sokhuot Ear on 3/5/2023.
//

import Foundation
import CoreData

class DatabaseController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate
{


    


    var balance: Double = 0
    
    var allTransactions: [Transaction] = []
    var allTransactionsFetchedResultsController: NSFetchedResultsController<Transaction>?
    var allCategoriesFetchedResultsController: NSFetchedResultsController<Category>?
    var persistentContainer: NSPersistentContainer
    var categories: [Category] = []
    
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Database")
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
        
        
        if fetchAllCategories().count == 0
        {
            addDefaultCategory()
        }
        
        categories = fetchAllCategories()
        allTransactions = fetchAllTransactions()
        
        
        // create user default for balance
        UserDefaults.standard.set(balance, forKey: "Balance")
    }
    
    func addTransaction(transactionType: TransactionType, amount: Double, toFrom: String, currency: Currency, date: Date, category: Category, note: String, recurring: Recurring) -> Transaction {
        
        //let transaction = Transaction(transactionType: transactionType, amount: amount, toOrFrom: toFrom, date: //date, note: note, recurring: recurring, category: category)
//        allTransactions.append(transaction)
//        print(allTransactions[0].amount)
//        return transaction
        
        let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: persistentContainer.viewContext) as! Transaction
        
        transaction.transactionType = transactionType.rawValue
        transaction.amount = amount
        transaction.toFrom = toFrom
        transaction.date = date
        transaction.category = category
        transaction.note = note
        transaction.recurring = recurring.rawValue
        transaction.id = UUID().uuidString
    
        allTransactions = fetchAllTransactions()
        cleanup()
        
        return transaction
    }
    
    func addCategory(name: String, value: Double)
    {
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: persistentContainer.viewContext) as! Category
        
        category.name = name
        category.value = value
        
        categories = fetchAllCategories()
        cleanup()
        
    }
    
    
    func addDefaultCategory()
    {
        addCategory(name: "Food", value: 0)
        addCategory(name: "Gym", value: 0)
    }
    
    func fetchAllTransactions() -> [Transaction] {
        if allTransactionsFetchedResultsController == nil {
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allTransactionsFetchedResultsController =
            NSFetchedResultsController<Transaction>(fetchRequest: request,
                                                  managedObjectContext: persistentContainer.viewContext,
                                                  sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allTransactionsFetchedResultsController?.delegate = self
            
            do {
                try allTransactionsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
            
        }
        if let transactions = allTransactionsFetchedResultsController?.fetchedObjects {
            return transactions
        }
        return [Transaction]()
        
    }
    
    
    func fetchAllCategories() -> [Category] {
        if allCategoriesFetchedResultsController == nil {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allCategoriesFetchedResultsController =
            NSFetchedResultsController<Category>(fetchRequest: request,
                                                  managedObjectContext: persistentContainer.viewContext,
                                                  sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allCategoriesFetchedResultsController?.delegate = self
            
            do {
                try allCategoriesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
            
        }
        if let categories = allCategoriesFetchedResultsController?.fetchedObjects {
            return categories
        }
        
        cleanup()
        return [Category]()
        
    }
    
    func deleteTransaction(transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        cleanup()
        allTransactions = fetchAllTransactions()
    }
    
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        //none
    }
    
    func removeListener(listener: DatabaseListener) {
        //none
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categories = fetchAllCategories()
        allTransactions = fetchAllTransactions()
    }
    
    func getBalance() -> Double {
        let retrievedDouble = UserDefaults.standard.double(forKey: "Balance")
        return retrievedDouble
    }
    
    func removeCategory(category: Category) {
        persistentContainer.viewContext.delete(category)
        cleanup()
        categories = fetchAllCategories()
    }
    
    
    
    
}


