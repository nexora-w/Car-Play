import Foundation
import AVFoundation
import UIKit
import CarPlay

@objc enum CarplayType: Int {
    case video
    case web
    case rawVideo
    case IOSAPP
}

@objc class CarplayComClass: NSObject {
    @objc var type: CarplayType
    @objc var URL: URL?
    @objc var AVplayer: AVPlayer?
    var reloadWeb: (() -> Void)?
    
    @objc init(type: CarplayType, URL: URL? = nil, AVplayer: AVPlayer? = nil, reloadWeb: (() -> Void)? = nil) {
        self.type = type
        self.URL = URL
        self.AVplayer = AVplayer
        self.reloadWeb = reloadWeb
    }
}

@objc class TDSVideoShared: NSObject {
    @objc static let shared = TDSVideoShared()
    
    @objc var VideoPlayerForFile: AVPlayer?
    @objc var window: UIWindow?
    @objc var CarPlayComp: ((CarplayComClass) -> Void)?
    
    private override init() {
        super.init()
    }
} 