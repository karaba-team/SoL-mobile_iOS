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

struct ShapeModel {
    var pathCount: Int = 0
    var shapeID: Int = 0
    var path: Paths = []
    
    init(path: Paths){
        self.pathCount = path.count
        self.shapeID = 3123
        self.path = path
    }
    init(_ data: NSManagedObject){
        if let d = data as? Shape {
            self.pathCount = Int(d.path_count)
            self.shapeID = Int(d.shapeID)
            self.path = (Array(d.points!) as! Paths).map{ CGPoint(x: $0.x, y: $0.y) }
        }
    }
}
struct ShapePath{
    let x: Float
    let y: Float
}

class ShapeBentuk {
    let model: ShapeModel
    
    init(newModel: ShapeModel) {
        model = newModel
    }
    
    func insert(){
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let shapeEntity = NSEntityDescription.entity(forEntityName: "Shape",
                                                in: managedContext)!
        let pointEntity = NSEntityDescription.entity(forEntityName: "Point",
                                                in: managedContext)!
        
        let shape = NSManagedObject(entity: shapeEntity,
                                    insertInto: managedContext)
        
        shape.setValue(model.pathCount,forKey: "path_count")
        shape.setValue(model.shapeID, forKey: "shapeID")
        shape.setValue(model.path, forKey: "points")

        
        model.path.forEach { point in
            let pointObj = NSManagedObject(entity: pointEntity, insertInto: managedContext)
            pointObj.setValue(point.x, forKey: "x")
            pointObj.setValue(point.y, forKey: "y")
        }
        
        do {
            try managedContext.save()
            print("DB: saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //    func get(){
    //        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    //        let getRequest = NSFetchRequest<NSManagedObject>(entityName: "Shape")
    //
    //        do{
    //            var shapes = try managedContext.fetch(getRequest) as! [NSManagedObject]
    ////            shapes.forEach{ shape in
    ////                shapes.append(
    ////                    ShapeModel(
    ////                        pathCount: shape.value(forKey:  "path_count") as! Int,
    ////                        shapeID: shape.value(forKey: "shapeID") as! Int,
    ////                        path:
    ////                )
    ////            }
    //        }catch let err{
    //            print(err)
    //        }
    //
    //    }
    //
    static func getAllShape(){
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let getRequest = NSFetchRequest<NSManagedObject>(entityName: "Shape")
        do {
            let shape = try managedContext.fetch(getRequest)
            shape.forEach { data in
                let s = ShapeModel(data)
                print(s.path)
                print("shape", s)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
