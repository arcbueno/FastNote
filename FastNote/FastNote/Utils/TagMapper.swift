//
//  TagMapper.swift
//  FastNote
//
//  Created by pedro.bueno on 04/10/24.
//

import Foundation

struct TagMapper {
    static func tagListToString(tagList: [Label])-> String{
        do{
            return String(data: try JSONEncoder().encode(tagList), encoding: String.Encoding.utf8) ?? ""
        }
        catch{
            print("error encoding list of tags")
            return ""
        }
    }
    
    static func stringToTagList(listString:String) -> [Label]{
        if(listString.isEmpty){
            return []
        }
        do{
            return try JSONDecoder().decode([Label].self, from: listString.data(using: .utf8)!)
        }catch {
          print("Error decoding list")
            return []
        }
    }
}
