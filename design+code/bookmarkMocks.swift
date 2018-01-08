//
//  BookmarkMock.swift
//  DesignCodeApp
//
//  Created by Tiago Mergulhão on 19/12/17.
//  Copyright © 2017 Meng To. All rights reserved.
//

import Foundation

typealias BookmarkMocks = Array<BookmarkMock>

extension Array where Element == BookmarkMock {
    init() {
        guard let path = Bundle.main.path(forResource: "Bookmarks", ofType: "plist"),
            let array = NSArray(contentsOfFile: path) as Array<AnyObject>?,
            let bookmarks = array as? Array<Dictionary<String,AnyObject>> else {
                fatalError("Bundle.main.path(forResource: \"Bookmarks\", ofType: \"plist\")")
        }
        
        self = bookmarks.map { try! BookmarkMock($0) }
    }
}

struct BookmarkMock {
    var hasImage : Bool
    var content: String
    var partName : String
    var sectionName : String
    var chapterNumber : Int
}

extension BookmarkMock {
    init(_ dictionary : Dictionary<String,AnyObject>) throws {
        let hasImage = dictionary["hasImage"] as! Bool
        let content = dictionary["content"] as! String
        let partName = dictionary["partName"] as! String
        let sectionName = dictionary["sectionName"] as! String
        let chapterNumber = dictionary["chapterNumber"] as! Int
        
        self.init(
            hasImage: hasImage,
            content: content,
            partName: partName,
            sectionName: sectionName,
            chapterNumber: chapterNumber
        )
    }
}

