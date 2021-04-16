//
//  FilmModel.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

struct Film: Decodable {
    let id:       Int
    let overview: String
    let title:    String
    let language: String
    let poster:   String
    let popular:  Double
    let vote:     Double
}
