//
//  CreateSongs.swift
//  
//
//  Created by Myo Thura Zaw on 29/11/2022.
//

import Fluent

struct CreateSong: AsyncMigration {
	func prepare(on database: FluentKit.Database) async throws  {
		try await database.schema("songs")
			.id()
			.field("title", .string, .required)
			.create()
	}
	
	func revert(on database: FluentKit.Database) async throws {
		try await database.schema("songs").delete()
	}
}
