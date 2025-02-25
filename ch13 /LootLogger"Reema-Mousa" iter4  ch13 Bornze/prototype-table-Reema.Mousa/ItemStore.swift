//
//  ItemStore.swift
//  prototype-table-Reema.Mousa
//
//  Created by Reema Mousa on 10/04/1443 AH.
//

import UIKit

class ItemStore {
  var allItems = [Item]()
  
  let itemArchiveURL: URL = {
    let documentsDirectories =
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("items.plist")
  }()
  
  
  @discardableResult func createItem() -> Item{
    let newItem = Item(random: true)
    allItems.append(newItem)
    return newItem
  }
  
  func moveItem(from fromIndex: Int,to toIndex: Int){
    if fromIndex == toIndex{
      return
    }
    let movedItem = allItems[fromIndex]
    allItems.remove(at: fromIndex)
    allItems.insert(movedItem,at:toIndex)
  }
  
  func removeItem(_ item: Item){
    if let index = allItems.firstIndex(of: item){
      allItems.remove(at: index)
    }
  }
  @objc  func saveChanges() throws  {
    print("Saving items to: \(itemArchiveURL)")
    do {
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(allItems)
      
      try data.write(to: itemArchiveURL, options: [.atomic])
      print("Saved all of the items")
  
    } catch let encodingError {
      print("Error encoding allItems: \(encodingError)")
    }
 
  }
  
  init() {
    
    do {
      let data = try Data(contentsOf: itemArchiveURL)
      let unarchiver = PropertyListDecoder()
      let items = try unarchiver.decode([Item].self, from: data)
      allItems = items
    } catch {
      print("Error reading in saved items: \(error)")
    }
    
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   
                                   selector: #selector(saveChanges),
                                   name: UIScene.didEnterBackgroundNotification,
                                   object: nil)
  }
}
