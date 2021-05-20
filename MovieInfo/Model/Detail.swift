//
//  Detail.swift
//  MovieInfo
//
//  Created by Spencer Forrest on 13/05/2021.
//

import Foundation

/// Details of a video.
///
/// ## Properties:
///   - id: unique id
///   - Type of video: Trailer, Teaser, Clip, Featurette, Behind the Scenes or Bloopers
///   - name: title of the video
///   - site: Youtube or Vimeo
///   - key: unique id to use with its associated site
struct Detail: Decodable {
  var id: String
  var type: String
  var name: String
  var site: String
  var key: String
}
