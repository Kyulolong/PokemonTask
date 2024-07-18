//
//  PhoneBook+CoreDataProperties.swift
//  PokemonTask
//
//  Created by 김인규 on 7/18/24.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImage: Data?

}

extension PhoneBook : Identifiable {

}
