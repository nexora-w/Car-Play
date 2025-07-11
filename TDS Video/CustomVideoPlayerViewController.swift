//
//  CustomVideoPlayerViewController.swift
//  TDS Video
//
//  Created by Nexora on 05/08/2024.
//

import UIKit
import AVFoundation
import MediaPlayer
import Foundation

class CustomVideoPlayerViewController: UIViewController {
    private var playerLayer: AVPlayerLayer?
    private weak var videoPlayer: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupRemoteCommandCenter()
    }

    func setupPlayer(url: URL) {
        TDSVideoShared.shared.VideoPlayerForFile = AVPlayer(url: url)
        videoPlayer = TDSVideoShared.shared.VideoPlayerForFile
        playerLayer = AVPlayerLayer(player: videoPlayer)
        
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspect
        view.layer.insertSublayer(playerLayer, at: 0)
        
        setupNowPlayingInfo()
    }
    
    func setupPlayer(player: AVPlayer) {
        TDSVideoShared.shared.VideoPlayerForFile = player
        videoPlayer = TDSVideoShared.shared.VideoPlayerForFile
        playerLayer = AVPlayerLayer(player: videoPlayer)
        
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resize
        view.layer.insertSublayer(playerLayer, at: 0)
        
        setupNowPlayingInfo()
    }
    
    func setupPlayerlayer(playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resize
        view.layer.insertSublayer(playerLayer, at: 0)
        
        setupNowPlayingInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPlayer?.play()
        updateNowPlayingInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayer?.pause()
    }

    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            if self.videoPlayer?.rate == 0.0 {
                self.videoPlayer?.play()
                self.updateNowPlayingInfo()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            if self.videoPlayer?.rate != 0.0 {
                self.videoPlayer?.pause()
                self.updateNowPlayingInfo()
                return .success
            }
            return .commandFailed
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            if self.videoPlayer?.rate == 0.0 {
                self.videoPlayer?.play()
            } else {
                self.videoPlayer?.pause()
            }
            self.updateNowPlayingInfo()
            return .success
        }

        commandCenter.skipForwardCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            self.skipForward()
            self.updateNowPlayingInfo()
            return .success
        }

        commandCenter.skipBackwardCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            self.skipBackward()
            self.updateNowPlayingInfo()
            return .success
        }

        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard
                let self = self,
                let player = self.videoPlayer,
                let positionEvent = event as? MPChangePlaybackPositionCommandEvent
            else { return .commandFailed }

            let newTime = CMTimeMakeWithSeconds(positionEvent.positionTime, preferredTimescale: 1)
            player.seek(to: newTime) { _ in
                self.updateNowPlayingInfo()
            }
            return .success
        }
    }

    private func setupNowPlayingInfo() {
        guard let currentItem = videoPlayer?.currentItem else { return }

        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "TDS Video In Car Player"
        nowPlayingInfo[MPMediaItemPropertyArtist] = ""
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(currentItem.asset.duration)
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(videoPlayer?.currentTime() ?? .zero)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = videoPlayer?.rate ?? 0.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func updateNowPlayingInfo() {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()

        if let player = videoPlayer, let currentItem = player.currentItem {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        }

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    private func skipForward() {
        guard let player = videoPlayer, let currentItem = player.currentItem else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 15.0
        if newTime < CMTimeGetSeconds(currentItem.duration) {
            let time = CMTimeMakeWithSeconds(newTime, preferredTimescale: currentItem.asset.duration.timescale)
            player.seek(to: time)
        }
    }

    private func skipBackward() {
        guard let player = videoPlayer else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = max(currentTime - 15.0, 0)
        let time = CMTimeMakeWithSeconds(newTime, preferredTimescale: player.currentItem?.asset.duration.timescale ?? 1)
        player.seek(to: time)
    }
}
