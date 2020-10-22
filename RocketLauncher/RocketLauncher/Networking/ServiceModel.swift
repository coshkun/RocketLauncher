//
//  ServiceModel.swift
//  RocketLauncher
//
//  Created by Coskun Caner on 19.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AllLaunchesDTO {
    let result:[Launch]
    
    init?(json:JSON) throws {
        guard let items = json.array else { throw ServiceMessage.jsonParsingErr }
        
        let sonuc = items.compactMap { return Launch(json: $0) }
        self.result = sonuc
    }
}

struct UpcomingLaunchesDTO {
    let result:[Launch]
    
    init?(json:JSON) throws {
        guard let items = json.array else { throw ServiceMessage.jsonParsingErr }
        // make any changes here if the structure differs,
        // lucky us, it's the same ;)
        let sonuc = items.compactMap { return Launch(json: $0) }
        self.result = sonuc
    }
}


// MARK: - Launch
struct Launch: Codable {
    var flightNumber: Int = 0
    var missionName: String = ""
    var missionID: [String] = [String]()
    var upcoming: Bool = false
    var launchYear: String = ""
    var launchDateUnix: Int64 = 0
    var launchDateUTC: String = ""
    var launchDateLocal: String = ""
    var isTentative: Bool = false
    var tentativeMaxPrecision: TentativeMaxPrecision = .unknown
    var tbd: Bool = false
    var launchWindow: Int?
    var rocket: Rocket?
    var ships: [String] = [String]()
    var telemetry: Telemetry = Telemetry()
    var launchSite: LaunchSite = LaunchSite()
    var launchSuccess: Bool?
    var launchFailureDetails: LaunchFailureDetails?
    var links: Links = Links()
    var details, staticFireDateUTC: String!
    var staticFireDateUnix: Int64! = 0
    //var timeline: [String: Int?]?
    //var crew: [Any?]?
    var lastDateUpdate: String!
    var lastLlLaunchDate, lastLlUpdate: String!
    var lastWikiLaunchDate, lastWikiRevision, lastWikiUpdate: String!
    var launchDateSource: LaunchDateSource! = .unknown
    
    func serialize() -> String {
        guard let data = try? JSONEncoder().encode(self)
        else { return "" }
        
        let json = JSON(data)
        return json.rawString() ?? ""
    }
    
    static func deserialize(from:String) -> Launch? {
        guard let data = from.data(using: .utf8) else {return nil}
        let item = try? JSONDecoder().decode(Launch.self, from: data)
        return item
    }
}

extension Launch {
    init(json:JSON) {
        flightNumber          = json["flight_number"].intValue
        missionName           = json["mission_name"].stringValue
        if let items          = json["mission_id"].arrayObject as? [String] { missionID = items }
        upcoming              = json["upcoming"].boolValue
        launchYear            = json["launch_year"].stringValue
        launchDateUnix        = json["launch_date_unix"].int64Value
        launchDateUTC         = json["launch_date_utc"].stringValue
        launchDateLocal       = json["launch_date_local"].stringValue
        isTentative           = json["is_tentative"].boolValue
        tentativeMaxPrecision = TentativeMaxPrecision(rawValue: json["tentative_max_precision"].stringValue.camelized) ?? .unknown
        tbd          = json["tbd"].boolValue
        launchWindow = json["launch_window"].intValue
        rocket       = Rocket(json: json["rocket"])
        if let items = json["ships"].arrayObject as? [String] { ships = items }
        if let _ = json["telemetry"].dictionary { telemetry = Telemetry(json: json["telemetry"]) }
        if let _ = json["launch_site"].dictionary { launchSite = LaunchSite(json: json["launch_site"]) }
        launchSuccess = json["launch_success"].boolValue
        if let _ = json["launch_failure_details"].dictionary {
            launchFailureDetails = LaunchFailureDetails(json: json["launch_failure_details"])
        }
        if let _ = json["links"].dictionary { links = Links(json: json["links"]) }
        details = json["details"].string ?? ""
        staticFireDateUTC = json["static_fire_date_utc"].stringValue
        staticFireDateUnix = json["static_fire_date_unix"].int64 ?? 0
        //some removed params was here
        lastDateUpdate = json["last_date_update"].stringValue
        lastLlLaunchDate = json["last_ll_launch_date"].stringValue
        lastLlUpdate = json["last_ll_update"].stringValue
        lastWikiLaunchDate = json["last_wiki_launch_date"].stringValue
        lastWikiRevision = json["last_wiki_revision"].stringValue
        lastWikiUpdate = json["last_wiki_update"].stringValue
        launchDateSource = LaunchDateSource(rawValue: json["launch_date_source"].stringValue.camelized) ?? .unknown
    }
}

enum LaunchDateSource:String, Codable {
    case unknown
    case launchLibrary = "launch_date_source"
    case wiki = "wiki"
}

// MARK: - LaunchFailureDetails
struct LaunchFailureDetails: Codable {
    var time: Int64 = 0
    var altitude: Int64? = nil
    var reason: String = ""
}
extension LaunchFailureDetails {
    init(json:JSON) {
        time     = json["time"].int64Value
        altitude = json["altitude"].int64
        reason   = json["reason"].stringValue
    }
}

// MARK: - LaunchSite
struct LaunchSite: Codable {
    var siteID: String = ""
    var siteName: String = ""
    var siteNameLong: String = ""
}
extension LaunchSite {
    init(json:JSON) {
        siteID       = json["site_id"].stringValue
        siteName     = json["site_name"].stringValue
        siteNameLong = json["site_name_long"].stringValue
    }
}
//struct LaunchSite {
//    var siteID: SiteID
//    var siteName: SiteName
//    var siteNameLong: SiteNameLong
//}
//
//enum SiteID {
//    case ccafsSlc40
//    case kscLc39A
//    case kwajaleinAtoll
//    case vafbSlc4E
//}
//
//enum SiteName {
//    case ccafsSlc40
//    case kscLc39A
//    case kwajaleinAtoll
//    case vafbSlc4E
//}
//
//enum SiteNameLong {
//    case capeCanaveralAirForceStationSpaceLaunchComplex40
//    case kennedySpaceCenterHistoricLaunchComplex39A
//    case kwajaleinAtollOmelekIsland
//    case vandenbergAirForceBaseSpaceLaunchComplex4E
//}

// MARK: - Links
struct Links: Codable {
    var missionPatch, missionPatchSmall: String?
    var redditCampaign: String?
    var redditLaunch: String?
    var redditRecovery, redditMedia: String?
    var presskit: String?
    var articleLink: String?
    var wikipedia, videoLink: String?
    var youtubeID: String?
    var flickrImages: [String] = [String]()
}
extension Links {
    init(json:JSON) {
        missionPatch = json["mission_patch"].string
        missionPatchSmall = json["mission_patch_small"].string
        redditCampaign = json["reddit_campaign"].string
        redditLaunch = json["reddit_launch"].string
        redditRecovery = json["reddit_recovery"].string
        redditMedia = json["reddit_media"].string
        presskit = json["presskit"].string
        articleLink = json["article_link"].string
        wikipedia = json["wikipedia"].string
        videoLink = json["video_link"].string
        youtubeID = json["youtube_id"].string
        if let images = json["flickr_images"].arrayObject as? [String] { flickrImages = images }
    }
}

// MARK: - Rocket
struct Rocket: Codable {
//    var rocketID: String // RocketID
//    var rocketName: String // RocketName
//    var rocketType: String // RocketType
    var rocketID: RocketID
    var rocketName: RocketName
    var rocketType: RocketType
    var firstStage: FirstStage
    var secondStage: SecondStage
    var fairings: Fairings?
}
extension Rocket {
    init(json:JSON) {
        rocketID = RocketID(rawValue: json["rocket_id"].stringValue.camelized) ?? .unknown
        rocketName = RocketName(rawValue: json["rocket_name"].stringValue.camelized) ?? .unknown
        rocketType = RocketType(rawValue: json["rocket_type"].stringValue.camelized) ?? .unknown
//        rocketID    = json["rocket_id"].stringValue
//        rocketName  = json["rocket_name"].stringValue
//        rocketType  = json["rocket_type"].stringValue
        
        firstStage  = FirstStage(json: json["first_stage"])
        secondStage = SecondStage(json: json["second_stage"])
        
        if let _ = json["fairings"].dictionary { fairings = Fairings(json: json["fairings"]) }
    }
}

// MARK: - Fairings
struct Fairings: Codable {
    var reused, recoveryAttempt, recovered: Bool?
    var ship: Ship?
}
extension Fairings {
    init(json:JSON) {
        reused = json["reused"].boolValue
        recoveryAttempt = json["recovery_attempt"].boolValue
        recovered = json["recovered"].boolValue
        ship = Ship(rawValue: json["ship"].stringValue.camelized) ?? .unknown
    }
}

enum Ship: String, Codable {
    case unknown
    case gomschief
    case gomstree
    case gosearcher
}

// MARK: - FirstStage
struct FirstStage: Codable {
    var cores: [Core]
}
extension FirstStage {
    init(json:JSON) {
        if let items = json["cores"].array {
            cores = items.compactMap { Core(json: $0) }
        } else {
            cores = [Core]()
        }
    }
}

// MARK: - Core
struct Core: Codable {
    var coreSerial: String?
    var flight, block: Int?
    var gridfins, legs, reused, landSuccess: Bool?
    var landingIntent: Bool?
    var landingType: LandingType?
    var landingVehicle: LandingVehicle?
}
extension Core {
    init(json:JSON) {
        coreSerial     = json["core_serial"].stringValue
        flight         = json["flight"].intValue
        block          = json["block"].intValue
        gridfins       = json["gridfins"].bool
        legs           = json["legs"].bool
        reused         = json["reused"].bool
        landSuccess    = json["land_success"].bool
        landingIntent  = json["landing_intent"].bool
        landingType    = LandingType(rawValue: json["landing_type"].stringValue.camelized) ?? .unknown
        landingVehicle = LandingVehicle(rawValue: json["landing_vehicle"].stringValue.camelized) ?? .unknown
    }
}

enum LandingType:String, Codable {
    case unknown
    case asds
    case ocean
    case rtls
}

enum LandingVehicle:String, Codable {
    case unknown
    case jrti
    case jrti1
    case lz1
    case lz2
    case lz4
    case ocisly
}

enum RocketID:String, Codable {
    case unknown
    case falcon1
    case falcon9
    case falconheavy
}

enum RocketName:String, Codable {
    case unknown
    case falcon1
    case falcon9
    case falconHeavy
}

enum RocketType:String, Codable {
    case unknown
    case ft
    case merlinA
    case merlinC
    case v10
    case v11
}

// MARK: - SecondStage
struct SecondStage: Codable {
    var block: Int?
    var payloads: [Payload]
}
extension SecondStage {
    init(json:JSON) {
        block = json["block"].int
        if let items = json["payloads"].array {
            payloads = items.compactMap { Payload(json: $0) }
        } else {
            payloads = [Payload]()
        }
    }
}

// MARK: - Payload
struct Payload: Codable {
    var payloadID: String
    var noradID: [Int]
    var reused: Bool
    var customers: [String]
    var nationality: String?
    var manufacturer: String?
    var payloadType: PayloadType
    var payloadMassKg: Double! = 0.0
    var payloadMassLbs: Double! = 0.0
    var orbit: String! = ""
    var orbitParams: OrbitParams
    var capSerial: String?
    var massReturnedKg: Double! = 0.0
    var massReturnedLbs: Double! = 0.0
    var flightTimeSEC: Int64! = 0
    var cargoManifest: String?
    var uid: String?
}
extension Payload {
    init(json:JSON) {
        payloadID      = json["payload_id"].stringValue
        noradID        = json["norad_id"].arrayValue.compactMap { $0.intValue }
        reused         = json["reused"].boolValue
        customers      = json["customers"].arrayValue.compactMap { $0.stringValue }
        nationality    = json["nationality"].string
        manufacturer   = json["manufacturer"].string
        payloadType    = PayloadType(rawValue: json["payload_type"].stringValue.camelized) ?? .unknown
        payloadMassKg  = json["payload_mass_kg"].double ?? 0
        payloadMassLbs = json["payload_mass_lbs"].double ?? 0
        orbit          = json["orbit"].string ?? ""
        if let _ = json["orbit_params"].dictionary {
            orbitParams  = OrbitParams(json:json["orbit_params"])
        } else {
            orbitParams = OrbitParams()
        }
        capSerial       = json["cap_serial"].string
        massReturnedKg  = json["mass_returned_kg"].double ?? 0
        massReturnedLbs = json["mass_returned_lbs"].double ?? 0
        flightTimeSEC   = json["flight_time_sec"].int64 ?? 0
        cargoManifest   = json["cargo_manifest"].string
        uid             = json["uid"].string
    }
}

// MARK: - OrbitParams
struct OrbitParams: Codable {
    var referenceSystem: ReferenceSystem!
    var regime: Regime?
    var longitude, semiMajorAxisKM, eccentricity, periapsisKM: Double!
    var apoapsisKM, inclinationDeg, periodMin, lifespanYears: Double!
    var epoch: String?
    var meanMotion, raan: Double?
    var argOfPericenter, meanAnomaly: Double?
}
extension OrbitParams {
    init(json:JSON) {
        referenceSystem = ReferenceSystem(rawValue: json["reference_system"].stringValue.camelized) ?? .unknown
        regime          = Regime(rawValue: json["regime"].stringValue.camelized) ?? .unknown
        longitude       = json["longitude"].double ?? 0
        semiMajorAxisKM = json["semi_major_axis_km"].double ?? 0
        eccentricity    = json["eccentricity"].double ?? 0
        periapsisKM     = json["periapsis_km"].double ?? 0
        apoapsisKM      = json["apoapsis_km"].double ?? 0
        inclinationDeg  = json["inclination_deg"].double ?? 0
        periodMin       = json["period_min"].double ?? 0
        lifespanYears   = json["lifespan_years"].double ?? 0
        epoch           = json["epoch"].string
        meanMotion      = json["mean_motion"].double ?? 0
        raan            = json["raan"].double ?? 0
        argOfPericenter = json["arg_of_pericenter"].double ?? 0
        meanAnomaly     = json["mean_anomaly"].double ?? 0
    }
}

enum ReferenceSystem:String, Codable {
    case unknown
    case geocentric
    case heliocentric
    case highlyElliptical
}

enum Regime:String, Codable {
    case unknown
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

enum PayloadType:String, Codable {
    case unknown
    case crewDragon
    case dragon10
    case dragon11
    case dragonBoilerplate
    case lander
    case satellite
}

// MARK: - Telemetry
struct Telemetry:Codable {
    var flightClub: String?
}
extension Telemetry {
    init(json:JSON) {
        flightClub = json["flight_club"].string
    }
}

enum TentativeMaxPrecision:String, Codable {
    case unknown
    case hour
    case month
}
