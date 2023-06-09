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
    /**
     A function that changes the budget value for a particular category
     Arg:
     category: whose monthly budget (cash flow target ) to be updated
     newValue: the new monthly budget value
        
     */
    func changeBudgetValueFor(category: Category, newValue: Double) {
        category.value = newValue
        
        cleanup()
    }
    
    /**
        A function that marks a lending as fully paid.
        
     */
    func markLendingAsPaid(lending: Lending) {
        // date lending value and save context
        lending.paid = true
        lending.paidBy = Date()

        cleanup()
        
        // create a new transaction to reflect this lending repayment
        if let category = getCategory(name: DEFAULT_REPAYMENT)
        {
            let _ = addTransaction(transactionType: .lending, amount: abs(lending.amount), toFrom: lending.to ?? "", currency: .AUD, date: Date(), category: category, note: lending.note ?? "", recurring: .none)
        }
        
        // fetch all lending
        allLendings = fetchAllLending()
    }
    
    
    // the overall balance of the user
    var balance: Double = 0
    
    // all transaction list
    var allTransactions: [Transaction] = []
    
    // fetched result controller for transaction, categories and lending
    var allTransactionsFetchedResultsController: NSFetchedResultsController<Transaction>?
    var allCategoriesFetchedResultsController: NSFetchedResultsController<Category>?
    var allLendingsFetchedResultsController: NSFetchedResultsController<Lending>?
    
    // persistent container
    var persistentContainer: NSPersistentContainer
    
    // category and all lending arrays
    var categories: [Category] = []
    var allLendings: [Lending] = []
    
    // user default key for balance
    let BALANCE_USER_DEFAULT_KEY = "Balance"
    
    
    override init() {
        
        // create persistent container
        persistentContainer = NSPersistentContainer(name: "Database")
        persistentContainer.loadPersistentStores() { (description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
        
       // add default category if there aren't any in the database
        if fetchAllCategories().count == 0
        {
            addDefaultCategory()
        }
        
        // perform fetches from the database
        categories = fetchAllCategories()
        allTransactions = fetchAllTransactions()
        allLendings = fetchAllLending()
        
        
        
        // create user default for balance if there aren't any
        if UserDefaults.standard.object(forKey: BALANCE_USER_DEFAULT_KEY) != nil {
            // User default exists
            balance = getBalance()
        } else {
            // User default does not exist
            UserDefaults.standard.set(balance, forKey: BALANCE_USER_DEFAULT_KEY)
        }
        
            
        
    }
    
    /**
     A function for addeding a new transaction to the database
     transactionType: income, expense of lending
     amount: the amount of the transaction
     toFrom: who is it to/from
     currency: what currency is it done in
     date: date of transaction
     category: the category of the transaction
     note: note
     recurring: recurring valuue fo the transaction
     
     returns: transaction: that is added to persistent container
     
     */
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
        
        // set amount base on transaction type: income (positive), expense (negative), or lending (do nothing)
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
        
        // update user balance to reflect the transaction
        let _ = setBalance(value: getBalance() + transaction.amount)
    
        // clean up and save context
        allTransactions = fetchAllTransactions()
        cleanup()
        
        return transaction
    }
    
    /**
     Adds a new category to persistent container
     name: name of category
     value: budget ( monthly cash flow value) for the budget
     */
    func addCategory(name: String, value: Double)
    {
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: persistentContainer.viewContext) as! Category
        
        // set attributes
        category.name = name
        category.value = value
        
        // clean up
        categories = fetchAllCategories()
        cleanup()
        

    }
    
    /**
     create a new Lending and put it in  databse
     amount: amount of the lending
     date: the date of the lending
     due date: the due date for the lending
     note: note
     to: who it is to
     
     returns a transaction that reflects the new lending
     */
    func createNewLending(amount: Double, date: Date, dueDate: Date, note: String, to: String) -> Transaction? {
        let lending = NSEntityDescription.insertNewObject(forEntityName: "Lending", into: persistentContainer.viewContext) as! Lending
        
        // input attributes
        lending.dueDate = dueDate
        lending.amount = -amount
        lending.date = date
        lending.note = note
        lending.to = to
        lending.repayments = []
        lending.id = UUID().uuidString
        lending.paid = false
        
        // clean up
        cleanup()
        allLendings = fetchAllLending()
        
        print(lending.amount)
        
        // create new transaction to reflect the lending; every lending will have its own transaction
        if let category = getCategory(name: DEFAULT_LENDING)
        {
            print(lending.amount)
            let transaction = addTransaction(transactionType: .lending, amount: -amount, toFrom: to, currency: .AUD, date: lending.date ?? Date(), category: category, note: note, recurring: .none)

            return transaction
        }

        return nil
    }
    
    /**
     Fetches the lendings from database, and return the array of lending
     */
    
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
    

    /**
     Add defualt transaction categories into database
     */
    func addDefaultCategory()
    {
        addCategory(name: DEFAULT_OTHER, value: 0)
        addCategory(name: DEFAULT_LENDING, value: 0)
        addCategory(name: DEFAULT_REPAYMENT, value: 0)
    }
    
    /**
     Fetches the transactions from database, and return the array of transactions
     */
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
    
    /**
     Fetches the categories from database, and return the array of categories
     */
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
    
    // delete transaction
    func deleteTransaction(transaction: Transaction) {
        
        // update balance to reflect the transaction deletion
        let _ = setBalance(value: getBalance() - transaction.amount)
        
        // delete from database and clean up
        persistentContainer.viewContext.delete(transaction)
        cleanup()
        allTransactions = fetchAllTransactions()
    }
    
    // save contexts to database
    func cleanup() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    

    // retrieve "balance" from user defaults
    func getBalance() -> Double {
        let retrievedDouble = UserDefaults.standard.double(forKey: "Balance")
        return retrievedDouble
    }
    
    // remove a category from the database
    func removeCategory(category: Category) {
        // delete the category
        persistentContainer.viewContext.delete(category)
        
        // for all the transactions with the category as an attribute
        // it will now be updated to the default category: other
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
    
    /**
     Remove a lending from database
     pre-requisite: the lending must already be fully-repaid
     */
    func removeLending(lending: Lending) {
        persistentContainer.viewContext.delete(lending)
       
        cleanup()
        allLendings = fetchAllLending()
    }
    
    // update the "balance" and store it in the user default
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
    
    // get a certain category instance from all categories using its name
    func getCategory(name: String) -> Category?
    {
        // loop through all the categories
        for category in categories{
            if category.name == name
            {
                // if category is found, return it
                return category
            }
        }
        return nil
    }
    

    
    
    
}


