//
//  Date+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 11/05/2021.
//

import Foundation

extension Date {

  static func getCurrentYearAsString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return  formatter.string(from: Date())
  }
}
