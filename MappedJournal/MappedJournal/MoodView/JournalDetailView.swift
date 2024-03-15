import SwiftUI
import _AVKit_SwiftUI
import CoreData

struct JournalDetailView: View {
    
    let journal: Journal
    
    @State private var player: AVPlayer?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) { // Center the rounded rectangle
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color(journal.backgroundColor.map {
                        Color($0) } ?? Color.blue)))

                VStack(alignment: .leading, spacing: 10) {
                    
                    // MARK: Text
                    Text(journal.title ?? "Untitled")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .padding()
                    
//                    Text("Journal ID: \(journal.journalID?.uuidString ?? "N/A")")
//                        .foregroundColor(.gray)
//                        .font(.system(size: 12, weight: .regular))
//                        .padding()
                    
                    // MARK: Date
                    HStack {
                        Image(systemName: "calendar")
                        Text(journal.date?.formattedString ?? "")
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .foregroundColor(.black)
                    }

                    // MARK: Location
                    if let location = journal.location {
                        HStack {
                            Image(systemName: "pin")
                            Text(location.location ?? "Location not specified")
                                .font(.system(size: 16, weight: .regular, design: .monospaced))
                                .foregroundColor(.black)
                        }
                    }
    
                    // MARK: Images
                    if let images = journal.images?.allObjects as? [Images] {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(images, id: \.self) { image in
                                    if let imageData = image.imageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: Text
                    Text(journal.text ?? "")
                        .font(.system(size: 18, weight: .regular, design: .monospaced))
                        .foregroundColor(.black)
                        .padding()

                    // MARK: Video
                    if let videosSet = journal.videos as? Set<Videos>,
                       let video = videosSet.first,
                       let videoData = video.videoData,
                       let videoURL = saveVideoDataToFile(videoData) {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .onAppear {
                                player?.play()
                            }
                            .onDisappear {
                                player?.pause()
                            }
                            .frame(width: geometry.size.width - 40, height: 200)
                            .cornerRadius(10)
                    }

                    Spacer()
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            }
            .navigationBarTitle("My Travel Journal")
        }
    }
    
    // Function to save video data to a temporary file and return the URL
    private func saveVideoDataToFile(_ videoData: Data) -> URL? {
        do {
            let temporaryDirectoryURL = FileManager.default.temporaryDirectory
            let videoURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
            try videoData.write(to: videoURL)
            return videoURL
        } catch {
            print("Error saving video data to file: \(error.localizedDescription)")
            return nil
        }
    }
    
}

