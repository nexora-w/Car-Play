import Foundation
import AVFoundation
import UIKit

enum CarplayType {
    case video
    case web
    case rawVideo
    case IOSAPP
}

class CarplayComClass {
    var type: CarplayType
    var URL: URL?
    var AVplayer: AVPlayer?
    var reloadWeb: (() -> Void)?
    
    init(type: CarplayType, URL: URL? = nil, AVplayer: AVPlayer? = nil, reloadWeb: (() -> Void)? = nil) {
        self.type = type
        self.URL = URL
        self.AVplayer = AVplayer
        self.reloadWeb = reloadWeb
    }
}

class TDSVideoShared {
    static let shared = TDSVideoShared()
    
    var VideoPlayerForFile: AVPlayer?
    var window: UIWindow?
    var CarPlayComp: ((CarplayComClass) -> Void)?
    
    private init() {}
} 