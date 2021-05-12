//
//  Date+Ext.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 11/05/2021.
//

import Foundation

extension Date {

  static func getFirstDateOfCurrentYearAsString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"

    let currentYear = formatter.string(from: Date())

    return  currentYear + "01-01"
  }
}
