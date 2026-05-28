import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("SimplyNFC")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("A simple NFC library example app built from this repository.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
