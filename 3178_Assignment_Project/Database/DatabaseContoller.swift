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
    func changeBudgetValueFor(category: Category, newValue: Double) {
        category.value = newValue
        
        cleanup()
    }
    
    func markLendingAsPaid(lending: Lending) {
        lending.paid = true
        lending.paidBy = Date()

        cleanup()
        
        // create a new transaction to reflect this
        if let category = getCategory(name: DEFAULT_REPAYMENT)
        {
            let _ = addTransaction(transactionType: .lending, amount: abs(lending.amount), toFrom: lending.to ?? "", currency: .AUD, date: Date(), category: category, note: lending.note ?? "", recurring: .none)
        }
        
        allLendings = fetchAllLending()
    }
    
    
    var listeners = MulticastDelegate<DatabaseListener>()

    var balance: Double = 0
    
    var allTransactions: [Transaction] = []
    var allTransactionsFetchedResultsController: NSFetchedResultsController<Transaction>?
    var allCategoriesFetchedResultsController: NSFetchedResultsController<Category>?
    var allLendingsFetchedResultsController: NSFetchedResultsController<Lending>?
    var persistentContainer: NSPersistentContainer
    var categories: [Category] = []
    var allLendings: [Lending] = []
    let BALANCE_USER_DEFAULT_KEY = "Balance"
    
    
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
        allLendings = fetchAllLending()
        
        
        
        // create user default for balance

        if UserDefaults.standard.object(forKey: BALANCE_USER_DEFAULT_KEY) != nil {
            // User default exists
            balance = getBalance()
        } else {
            // User default does not exist
            UserDefaults.standard.set(balance, forKey: BALANCE_USER_DEFAULT_KEY)
        }
        
            
        
    }
    
    func addTransaction(transactionType: TransactionType, amount: Double, toFrom: String, currency: Currency, date: Date, category: Category, note: String, recurring: Recurring) -> Transaction {
        
        //let transaction = Transaction(transactionType: transactionType, amount: amount, toOrFrom: toFrom, date: //date, note: note, recurring: recurring, category: category)
//        allTransactions.append(transaction)
//        print(allTransactions[0].amount)
//        return transaction
        
        let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: persistentContainer.viewContext) as! Transaction
        
        transaction.transactionType = transactionType.rawValue
        transaction.toFrom = toFrom
        transaction.date = date
        transaction.category = category
        transaction.note = note
        transaction.recurring = recurring.rawValue
        transaction.id = UUID().uuidString
        
        // set amount base on transaction type
        if transactionType == .income
        {
            transaction.amount = amount
        }
        else if transactionType == .expense
        {
            transaction.amount = -amount
        }
        else
        {
            transaction.amount = amount
        }
        
        // update balance
        let _ = setBalance(value: getBalance() + transaction.amount)
    
        // clean up
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
    
    func createNewLending(amount: Double, date: Date, dueDate: Date, note: String, to: String) {
        let lending = NSEntityDescription.insertNewObject(forEntityName: "Lending", into: persistentContainer.viewContext) as! Lending
        
        lending.dueDate = dueDate
        lending.amount = -amount
        lending.date = date
        lending.note = note
        lending.to = to
        lending.repayments = []
        lending.id = UUID().uuidString
        lending.paid = false
        

        cleanup()
        allLendings = fetchAllLending()
        
        print(lending.amount)
        // create new transaction to reflect the lending
        if let category = getCategory(name: DEFAULT_LENDING)
        {
            print(lending.amount)
            let transaction = addTransaction(transactionType: .lending, amount: -amount, toFrom: to, currency: .AUD, date: lending.date ?? Date(), category: category, note: note, recurring: .none)
            
            // set local notification
            // set up local notification for the due date
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lending.dueDate ?? Date())
        }
        

        

        
    }
    
    func fetchAllLending() -> [Lending]
    {
        if allLendingsFetchedResultsController == nil {
            let request: NSFetchRequest<Lending> = Lending.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allLendingsFetchedResultsController =
            NSFetchedResultsController<Lending>(fetchRequest: request,
                                                  managedObjectContext: persistentContainer.viewContext,
                                                  sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allLendingsFetchedResultsController?.delegate = self
            
            do {
                try allLendingsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
            
        }
        if let lendings = allLendingsFetchedResultsController?.fetchedObjects {
            return lendings
        }
        return [Lending]()
    }
    

    
    
    func addDefaultCategory()
    {
        addCategory(name: DEFAULT_OTHER, value: 0)
        addCategory(name: DEFAULT_LENDING, value: 0)
        addCategory(name: DEFAULT_REPAYMENT, value: 0)
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
        // edit balance
        let _ = setBalance(value: getBalance() - transaction.amount)
        
        
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
        listeners.addDelegate(listener)
        if listener.listenerType == .all {
            listener.onTransactionChange(change: .update, transactions: [])
        }
    
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
        
        if let categoryTransactions = category.transaction?.allObjects as? [Transaction] {
            for transaction in categoryTransactions {
                if let category = getCategory(name: "Default: Other")
                {
                    transaction.category = category
                }
            }
        }
        
        else
        {
            print("error when trying to delete a category")
        }
        
        cleanup()
        categories = fetchAllCategories()
    }
    
    func removeLending(lending: Lending) {
        persistentContainer.viewContext.delete(lending)
        
    

        
        cleanup()
        allLendings = fetchAllLending()
    }
    
    func setBalance(value: Double) -> Double
    {
        var updatedValue = UserDefaults.standard.double(forKey: BALANCE_USER_DEFAULT_KEY)
        updatedValue = value
        
        // Save the updated value
        UserDefaults.standard.set(updatedValue, forKey: BALANCE_USER_DEFAULT_KEY)
        UserDefaults.standard.synchronize() // Optional - Forces immediate save
        
        print(UserDefaults.standard.double(forKey: BALANCE_USER_DEFAULT_KEY))
        return  UserDefaults.standard.double(forKey: BALANCE_USER_DEFAULT_KEY)
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func getCategory(name: String) -> Category?
    {
        for category in categories{
            if category.name == name
            {
                return category
            }
        }
        return nil
    }
    

    
    
    
}


