import SwiftUI
import CoreData

struct EmojiJournalView: View {
    let emojiName: String

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Journal.entity(), sortDescriptors: []) var journals: FetchedResults<Journal>

    var body: some View {
        List {
            ForEach(journals.filter { $0.mood?.emojiCategory == emojiName }) { journal in
                NavigationLink(destination: JournalDetailView(journal: journal)) {
                    EmojiJournalRowView(journal: journal)
                        .swipeActions {
                            Button(action: {
                                deleteJournal(journal)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
            }
            .onDelete(perform: deleteJournals)
        }
        .navigationTitle(emojiName)
    }

    private func deleteJournal(_ journal: Journal) {
        withAnimation {
            viewContext.delete(journal)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting journal: \(error.localizedDescription)")
            }
        }
    }

    private func deleteJournals(offsets: IndexSet) {
        withAnimation {
            offsets.map { journals[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting journals: \(error.localizedDescription)")
            }
        }
    }
}

