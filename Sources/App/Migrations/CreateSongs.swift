//
//  CreateSongs.swift
//  
//
//  Created by Myo Thura Zaw on 29/11/2022.
//

import Fluent

struct CreateSong: Migration {
	func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
		return database.schema("songs")
			.id()
			.field("title", .string, .required)
			.create()
	}
	
	func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
		return database.schema("songs").delete()
	}
}
