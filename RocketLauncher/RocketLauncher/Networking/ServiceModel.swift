//
//  ServiceModel.swift
//  RocketLauncher
//
//  Created by Coskun Caner on 19.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import Foundation

// MARK: - Launch
struct Launch {
    var flightNumber: Int
    var missionName: String
    var missionID: [String]
    var upcoming: Bool
    var launchYear: String
    var launchDateUnix: Int
    var launchDateUTC: String
    var launchDateLocal: Date
    var isTentative: Bool
    var tentativeMaxPrecision: TentativeMaxPrecision
    var tbd: Bool
    var launchWindow: Int?
    var rocket: Rocket
    var ships: [String]
    var telemetry: Telemetry
    var launchSite: LaunchSite
    var launchSuccess: Bool?
    var launchFailureDetails: LaunchFailureDetails?
    var links: Links
    var details, staticFireDateUTC: String?
    var staticFireDateUnix: Int?
    var timeline: [String: Int?]?
    var crew: [Any?]?
    var lastDateUpdate: String?
    var lastLlLaunchDate, lastLlUpdate: String?
    var lastWikiLaunchDate, lastWikiRevision, lastWikiUpdate: String?
    var launchDateSource: LaunchDateSource?
}

enum LaunchDateSource {
    case launchLibrary
    case wiki
}

// MARK: - LaunchFailureDetails
struct LaunchFailureDetails {
    var time: Int
    var altitude: Int?
    var reason: String
}

// MARK: - LaunchSite
struct LaunchSite {
    var siteID: SiteID
    var siteName: SiteName
    var siteNameLong: SiteNameLong
}

enum SiteID {
    case ccafsSlc40
    case kscLc39A
    case kwajaleinAtoll
    case vafbSlc4E
}

enum SiteName {
    case ccafsSlc40
    case kscLc39A
    case kwajaleinAtoll
    case vafbSlc4E
}

enum SiteNameLong {
    case capeCanaveralAirForceStationSpaceLaunchComplex40
    case kennedySpaceCenterHistoricLaunchComplex39A
    case kwajaleinAtollOmelekIsland
    case vandenbergAirForceBaseSpaceLaunchComplex4E
}

// MARK: - Links
struct Links {
    var missionPatch, missionPatchSmall: String?
    var redditCampaign: String?
    var redditLaunch: String?
    var redditRecovery, redditMedia: String?
    var presskit: String?
    var articleLink: String?
    var wikipedia, videoLink: String?
    var youtubeID: String?
    var flickrImages: [String]
}

// MARK: - Rocket
struct Rocket {
    var rocketID: RocketID
    var rocketName: RocketName
    var rocketType: RocketType
    var firstStage: FirstStage
    var secondStage: SecondStage
    var fairings: Fairings?
}

// MARK: - Fairings
struct Fairings {
    var reused, recoveryAttempt, recovered: Bool?
    var ship: Ship?
}

enum Ship {
    case gomschief
    case gomstree
    case gosearcher
}

// MARK: - FirstStage
struct FirstStage {
    var cores: [Core]
}

// MARK: - Core
struct Core {
    var coreSerial: String?
    var flight, block: Int?
    var gridfins, legs, reused, landSuccess: Bool?
    var landingIntent: Bool?
    var landingType: LandingType?
    var landingVehicle: LandingVehicle?
}

enum LandingType {
    case asds
    case ocean
    case rtls
}

enum LandingVehicle {
    case jrti
    case jrti1
    case lz1
    case lz2
    case lz4
    case ocisly
}

enum RocketID {
    case falcon1
    case falcon9
    case falconheavy
}

enum RocketName {
    case falcon1
    case falcon9
    case falconHeavy
}

enum RocketType {
    case ft
    case merlinA
    case merlinC
    case v10
    case v11
}

// MARK: - SecondStage
struct SecondStage {
    var block: Int?
    var payloads: [Payload]
}

// MARK: - Payload
struct Payload {
    var payloadID: String
    var noradID: [Int]
    var reused: Bool
    var customers: [String]
    var nationality: String?
    var manufacturer: String?
    var payloadType: PayloadType
    var payloadMassKg, payloadMassLbs: Double?
    var orbit: String?
    var orbitParams: OrbitParams
    var capSerial: String?
    var massReturnedKg, massReturnedLbs: Double?
    var flightTimeSEC: Int?
    var cargoManifest: String?
    var uid: String?
}

// MARK: - OrbitParams
struct OrbitParams {
    var referenceSystem: ReferenceSystem?
    var regime: Regime?
    var longitude, semiMajorAxisKM, eccentricity, periapsisKM: Double?
    var apoapsisKM, inclinationDeg, periodMin, lifespanYears: Double?
    var epoch: String?
    var meanMotion, raan: Double?
    var argOfPericenter, meanAnomaly: Double?
}

enum ReferenceSystem {
    case geocentric
    case heliocentric
    case highlyElliptical
}

enum Regime {
    case geostationary
    case geosynchronous
    case highEarth
    case highlyElliptical
    case l1Point
    case lowEarth
    case mediumEarth
    case semiSynchronous
    case subOrbital
    case sunSynchronous
    case veryLowEarth
}

enum PayloadType {
    case crewDragon
    case dragon10
    case dragon11
    case dragonBoilerplate
    case lander
    case satellite
}

// MARK: - Telemetry
struct Telemetry {
    var flightClub: String?
}

enum TentativeMaxPrecision {
    case hour
    case month
}
