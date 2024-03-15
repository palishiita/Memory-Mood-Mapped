import SwiftUI
import AVKit
import PhotosUI

class VideoPicker: ObservableObject {
    
    @Published private (set) var videoImportState: VideoImportState = .empty
    
    enum VideoImportState {
        case empty
        case loading(Progress)
        case success(AVPlayer)
        case failure(Error)
    }
    
    struct VideoType: Transferable {
        
        let url: URL
        
        static private func documentDirectory() -> String {
            let documentDirectory = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
            ).first ?? ""
            return documentDirectory
        }
        
        static var transferRepresentation: some TransferRepresentation {
            FileRepresentation(contentType: .movie) { movie in
                SentTransferredFile(movie.url)
            }
            importing: { received in
                let fileName = received.file.lastPathComponent
                let copy = URL(fileURLWithPath: "\(documentDirectory())/\(fileName)")

                // Check if the file already exists, and remove it if necessary
                if FileManager.default.fileExists(atPath: copy.path) {
                    try? FileManager.default.removeItem(at: copy)
                }

                do {
                    try FileManager.default.copyItem(at: received.file, to: copy)
                    return Self.init(url: copy)
                } catch {
                    // Handle the copying error
                    print("Error copying file: \(error)")
                    // Return a default or placeholder value
                    return Self.init(url: URL(fileURLWithPath: ""))
                }
            }
        }
    }
   
    @Published var videoSelection: PhotosPickerItem? = nil {
        didSet {
            if let videoSelection = videoSelection {
                let progress = loadTransferableVideo(from: videoSelection)
                videoImportState = .loading(progress)
            } else {
                videoImportState = .empty
            }
        }
    }
    
    private func loadTransferableVideo(from videoSelection: PhotosPickerItem) -> Progress {
        return videoSelection.loadTransferable(type: VideoType.self) {
            result in
            DispatchQueue.main.async {
                guard videoSelection == self.videoSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileVideo?):
                    let player = AVPlayer(url: profileVideo.url)
                    self.videoImportState = .success(player)
                case .success(nil):
                    self.videoImportState = .empty
                case .failure(let error):
                    self.videoImportState = .failure(error)
                }
            }
        }
    }
    
    func clearVideoImportState() {
        videoImportState = .empty
    }

}
