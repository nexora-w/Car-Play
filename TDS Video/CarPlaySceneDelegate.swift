import CarPlay
import UIKit
import AVKit
import ReplayKit

extension CPTemplateApplicationScene {
    func _shouldCreateCarWindow() -> Bool {
        print("CPTemplateApplicationScene")
        return true
    }
}

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate, CPMapTemplateDelegate {
    var window: UIWindow?
    var interfaceController: CPInterfaceController?
    var player: AVPlayer?
    var playerViewController: CustomVideoPlayerViewController?
    var webViewController: CarPlayViewControllerProtocol?
    var templateApplicationScene: CPTemplateApplicationScene?
    var mapTemplate: CPMapTemplate?
    var CarPlayVideoImageView: UIImageView = UIImageView()
    let offsetStyle: SingleEdgeOffset = .left(40)
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        if TDSCarplayAccess.shared.ShowTDSCarPlaySettings == false {
            return
        }
        
        let bool: Bool = templateApplicationScene._shouldCreateCarWindow()
        print(bool)
        
        self.interfaceController = interfaceController
        print(templateApplicationScene.carWindow.isUserInteractionEnabled)
        window.windowLevel = .alert
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        self.window?.isUserInteractionEnabled = false
        self.window?.isMultipleTouchEnabled = false
        TDSVideoShared.shared.window = window
        print("keys")
        print(window.isKeyWindow)
        print(window.canBecomeKey)
        window.makeKeyAndVisible()
        loadIOS()
        
        TDSVideoShared.shared.CarPlayComp = { (url: CarplayComClass) in
            ScreenCaptureManager.shared.IncomingVideoDetected = false
            switch url.type {
            case .video:
                self.playVideo(url: url.URL!)
            case .web:
                self.loadWebPage()
            case .rawVideo:
                self.rawVideo(player: url.AVplayer)
            case .IOSAPP:
                DispatchQueue.main.async {
                    self.loadIOS()
                }
            }
        }
        
        TDSVideoURlFromOutSideOFAppListener.shared.onUpdate = { (url: String) in
            print(url)
            if let url = URL(string: url) {
                CustomWebViewController.shared.loadURL(url)
                TDSVideoShared.shared.CarPlayComp?(CarplayComClass(type: .web, URL: url, AVplayer: nil, reloadWeb: nil))
            }
        }
    }
    
    func rawVideo(player: AVPlayer?) {
        guard let player else { return }
        let newPlayer = CustomVideoPlayerViewController()
        
        if let rootViewController = self.window?.rootViewController {
            rootViewController.addChild(newPlayer)
            rootViewController.view.addSubview(newPlayer.view)
            newPlayer.view.frame = rootViewController.view.bounds
            newPlayer.didMove(toParent: rootViewController)
            newPlayer.setupPlayer(player: player)
        }
    }
    
    func playVideo(url: URL) {
        self.playerViewController = nil
        self.window?.rootViewController = UIViewController()
        
        self.playerViewController = CustomVideoPlayerViewController()
        
        guard let playerViewController = playerViewController else {
            print("no root view")
            return
        }
        
        if let rootViewController = self.window?.rootViewController {
            rootViewController.addChild(playerViewController)
            rootViewController.view.addSubview(playerViewController.view)
            playerViewController.view.frame = rootViewController.view.bounds
            playerViewController.didMove(toParent: rootViewController)
            playerViewController.setupPlayer(url: url)
        }
    }
    
    func loadWebPage() {
        webViewController = CustomWebViewController.shared.loadViewIncar(self.window)
    }
    
    func loadIOS() {
        for subview in window!.subviews {
            subview.removeFromSuperview()
            print(subview)
        }
        
        self.window?.isUserInteractionEnabled = true
        self.window?.rootViewController = UIViewController()
        self.window?.rootViewController?.view.isUserInteractionEnabled = true
        
        if let rootViewController = self.window?.rootViewController {
            CarPlayVideoImageView.backgroundColor = .black
            CarPlayVideoImageView.contentMode = .scaleAspectFill
            rootViewController.view.addSubview(CarPlayVideoImageView)
            CarPlayVideoImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                CarPlayVideoImageView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor, constant: offsetStyle.topValue),
                CarPlayVideoImageView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor, constant: offsetStyle.bottomValue),
                CarPlayVideoImageView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor, constant: offsetStyle.leftValue),
                CarPlayVideoImageView.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor, constant: offsetStyle.rightValue)
            ])
            CarPlayVideoImageView.backgroundColor = .black
            ScreenCaptureManager.shared.addImageView(imageView: CarPlayVideoImageView, orientation: .left)
        }
    }
}

enum SingleEdgeOffset {
    case none
    case top(CGFloat)
    case bottom(CGFloat)
    case left(CGFloat)
    case right(CGFloat)
}

extension SingleEdgeOffset {
    var topValue: CGFloat {
        if case .top(let v) = self { return v } else { return 0 }
    }
    var bottomValue: CGFloat {
        if case .bottom(let v) = self { return -v } else { return 0 }
    }
    var leftValue: CGFloat {
        if case .left(let v) = self { return v } else { return 0 }
    }
    var rightValue: CGFloat {
        if case .right(let v) = self { return -v } else { return 0 }
    }
}

extension SingleEdgeOffset {
    // Presets
    static let leftDefault: SingleEdgeOffset = .left(40)
    static let rightDefault: SingleEdgeOffset = .right(40)
    static let topDefault: SingleEdgeOffset = .top(40)
    static let bottomDefault: SingleEdgeOffset = .bottom(40)
    static let noneDefault: SingleEdgeOffset = .none
}

extension SingleEdgeOffset {
    var rawValue: String {
        switch self {
        case .none: return "none"
        case .top(let v): return "top:\(v)"
        case .bottom(let v): return "bottom:\(v)"
        case .left(let v): return "left:\(v)"
        case .right(let v): return "right:\(v)"
        }
    }
    
    init?(rawValue: String) {
        if rawValue == "none" {
            self = .none
            return
        }
        let parts = rawValue.split(separator: ":")
        guard parts.count == 2,
              let value = Double(parts[1]) else {
            return nil
        }
        switch parts[0] {
        case "top": self = .top(CGFloat(value))
        case "bottom": self = .bottom(CGFloat(value))
        case "left": self = .left(CGFloat(value))
        case "right": self = .right(CGFloat(value))
        default: return nil
        }
    }
}

enum OffsetOption: String, CaseIterable, Identifiable {
    case none, top, bottom, left, right
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .top: return "Top "
        case .bottom: return "Bottom "
        case .left: return "Left"
        case .right: return "Right"
        }
    }
    
    var offset: SingleEdgeOffset {
        switch self {
        case .none: return .none
        case .top: return .top(40)
        case .bottom: return .bottom(40)
        case .left: return .left(40)
        case .right: return .right(40)
        }
    }
    
    static func from(offset: SingleEdgeOffset) -> OffsetOption {
        switch offset {
        case .none: return .none
        case .top: return .top
        case .bottom: return .bottom
        case .left: return .left
        case .right: return .right
        }
    }
} 