//
//  MIError.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 12/05/2021.
//

import Foundation

enum MIError: String, Error {
  case unableToComplete = "Unable to complete your request. Please check your internet connection."
  case invalidData = "The data received from the server is invalid. Please try again."
  case unableToUpdateFavoriteList = "Unable to update your favorite list right now. Please try again."
}
