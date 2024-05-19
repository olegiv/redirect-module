//
//  RedirectRuleAdminController.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Vapor
import Fluent
import Feather
import RedirectObjects

struct RedirectRuleAdminController: AdminController {
    typealias ApiModel = RedirectObjects.Redirect.Rule
    typealias DatabaseModel = RedirectRuleModel
    
    typealias CreateModelEditor = RedirectRuleEditor
    typealias UpdateModelEditor = RedirectRuleEditor 
    
    func findBy(_ id: UUID, on db: Database) async throws -> DatabaseModel {
        guard let model = try await DatabaseModel.find(id, on: db) else {
            throw Abort(.notFound)
        }
        return model
    }

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "source",
            "destination"
        ], defaultSort: .desc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$source ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("source"),
            .init("destination"),
            .init("statusCode"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.source),
            .init(model.destination),
            .init(String(model.statusCode)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("source", model.source, label: "Source path"),
            .init("destination", model.destination, label: "Destination URL or path"),
            .init("statusCode", String(model.statusCode), label: "HTTP status code"),
            .init("notes", model.notes)
        ]
    }

    func deleteInfo(_ model: DatabaseModel) -> String {
        model.source
    }
}
