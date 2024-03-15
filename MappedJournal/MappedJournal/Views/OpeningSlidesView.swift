import SwiftUI


struct OpeningSlidesView: View {
    @Binding var isShowingOpeningView: Bool
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()

    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    Spacer()
                    PageView(page: page)
                        .onTapGesture {
                            if page == pages.last {
                                isShowingOpeningView = false
                            } else {
                                incrementPage()
                            }
                        }
                    Spacer()
                    if page == pages.last {
                        VStack {
                            Button("Start!") {
                                isShowingOpeningView = false
                            }.accessibility (identifier: "Start")
                            .buttonStyle(.bordered)
                            .onTapGesture {
                                pageIndex = pages.count  // Set the index to the last page
                            }
                        }
                    } else {
                        Button("Next", action: incrementPage)
                            .buttonStyle(.borderedProminent)
                            .accessibility (identifier: "Next")
                    }
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .background(Color(red: 1.0, green: 0.8, blue: 0.8))
        //.background(Color(red: 0.8, green: 1.0, blue: 0.8))
        //.background(Color(red: 0.8, green: 0.8, blue: 1.0))

        .animation(.easeInOut, value: pageIndex)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())

        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .black
            dotAppearance.pageIndicatorTintColor = .gray
        }
    }

    func incrementPage() {
        pageIndex += 1
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
