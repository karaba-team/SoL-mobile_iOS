//
//  Shape.swift
//  Karaba
//
//  Created by Rem Remy on 14/11/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias Paths = [CGPoint]
typealias Points = [Point]
typealias Shapes = [ShapeModel]

struct ShapeModel {
    var pathCount: Int = 0
    var shapeID: Int = 0
    var path: Paths = []
    
    init(path: Paths){
        self.pathCount = path.count
        self.shapeID = 123
        self.path = path
    }
    init(_ data: NSManagedObject){
        if let d = data as? Shape {
            self.pathCount = Int(d.path_count)
            self.shapeID = Int(d.shapeID)
            
            d.points?.forEach({ point in
                let point = point as! Point
                let path = CGPoint(x: Int(point.x), y: Int(point.y))
                self.path.append(path)
            })
            print("TRANSFORM: PATH COUNT", self.pathCount)
            print("TRANSFORM: PATH", self.path)
        }
    }
}
struct ShapePath{
    let x: Float
    let y: Float
}
enum IntType: Codable {
    case int(Int)
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            throw DecodingError.typeMismatch(IntType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "err"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        }
    }
}

class ShapeBentuk {
    let model: ShapeModel
    
    init(newModel: ShapeModel) {
        model = newModel
    }
    func insert(){
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let shape = Shape(context: managedContext)
        shape.path_count = Int16(model.pathCount)
        shape.shapeID = Int32(model.shapeID)
        
        var array:[Point] = []
        
        model.path.forEach{ pointz in
            let point = Point(context: managedContext)
            
            point.setValue(pointz.x , forKey: "x")
            point.setValue(pointz.y, forKey: "y")
            point.setValue(shape, forKey: "shape")
            
            print("SAVING: POINT:", point.x, point.y)
        }
        print("SAVING: SHAPE ", shape)
        print("SAVING: TOTAL POINT", array.count)
        
        do {
            print("DB: saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    static func getAllShape() -> Shapes {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        var shapes = Shapes()
        
        do {
            let fetch: NSFetchRequest = Shape.fetchRequest()
            let shape = try managedContext.fetch(fetch)
            print("LOADING:", shape)
            
            shape.forEach { data in
                let s = ShapeModel(data)
                shapes.append(s)
            }
            return shapes
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return shapes
    }
    
    static func deleteAllShape() -> Shapes {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        var shapes = Shapes()
        
        do {
            let fetch: NSFetchRequest = Shape.fetchRequest()
            let shape = try managedContext.fetch(fetch)
            print("LOADING:", shape)
            
            shape.forEach { data in
                let s = ShapeModel(data)
                shapes.removeAll()
            }
            return shapes
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return shapes
    }
}
