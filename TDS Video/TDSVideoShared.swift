import Foundation
import AVFoundation

class TDSVideoShared {
    static let shared = TDSVideoShared()
    
    var VideoPlayerForFile: AVPlayer?
    
    private init() {}
} 