import SwiftUI
import CoreData
import AVKit


struct MoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Mood.entity(), sortDescriptors: []) var moods: FetchedResults<Mood>
    @State public var selectedMood: Mood? = nil

    
    
    static func soundOption(for emojiCategory: String) -> SoundOption {
        return SoundOption(rawValue: emojiCategory) ?? .Happy
    }

    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns:
                            [GridItem(.flexible(), spacing: 18),
                             GridItem(.flexible(), spacing: 18),
                             GridItem(.flexible(), spacing: 18)],
                          spacing: 18) {
                    ForEach(moods, id: \.self) { mood in
                        NavigationLink(destination: EmojiJournalView(emojiName: mood.emojiCategory ?? "")) {
                            VStack {
                                Image(mood.emojiCategory ?? "")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 135)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                
                                    .accessibility(identifier: "Mood-Image-\(mood.emojiCategory ?? "")") // Set the identifier
                                
                                
                                Button(action: {
                                    SoundManager.instance.playSound(sound: MoodView.soundOption(for: mood.emojiCategory ?? ""))
                                }) {
                                    Text(mood.emojiCategory ?? "")
                                        .font(.caption)
                                }
                                .padding(.top, 4)

                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("What Mood Are You In?")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

class SoundManager {

    static let instance = SoundManager()
    var player: AVAudioPlayer?

    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3")
        else {
            return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }

}

