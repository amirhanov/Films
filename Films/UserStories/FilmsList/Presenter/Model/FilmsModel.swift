//
//  FilmsModel.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 05.04.2021.
//

import Foundation

struct Films: Decodable {
  let count: Int
  let all:   [Film]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
