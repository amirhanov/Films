//
//  FilmDetailModel.swift
//  Films
//
//  Created by Амирханов Рустам Аждарович on 01.05.2021.
//

import UIKit

struct Film: Decodable {
    let adult:          Bool
    let budget:         Int
    let homepage:       String
    let overview:       String
    let release_date:   String
    let vote_count:     Int
    let vote_average:   Double
    let revenue:        Int
    let poster_path:    String
    let original_title: String
    let runtime:        Int
    let tagline:        String
}
