import SwiftUI
import CoreData

struct EmojiJournalRowView: View {
    let journal: Journal

    var body: some View {
        HStack {
            if let images = journal.images?.allObjects as? [Images], let firstImage = images.first,
               let imageData = firstImage.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(journal.backgroundColor ?? "Blue"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(journal.title ?? "Untitled")
                    .font(.headline)
                    .foregroundColor(.black)

                if let location = journal.location {
                    Text("Location: \(location.location ?? "Location not specified")")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }

                Text(journal.date?.formattedString ?? "")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .accessibility(identifier: "EmojiJournalRowView")
            Spacer()
        }
        
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10)
        .fill(Color(journal.backgroundColor ?? "Blue")))
    }
}



extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
}
