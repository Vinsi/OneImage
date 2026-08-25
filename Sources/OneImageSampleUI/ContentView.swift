//
//  ContentView.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI
import View

public struct ContentView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("Local") {
                    row(title: "SF Symbol") {
                        ImageView(.local(.system("star.fill")))
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    row(title: "Rendering Mode") {
                        ImageView(.local(.system("heart.fill")))
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.red)
                            .frame(width: 64, height: 64)
                    }
                }

                Section("Remote") {
                    row(title: "URL") {
                        ImageView(.remote(.urlString("https://picsum.photos/200")))
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    row(title: "With Placeholders") {
                        ImageView(.remote(.urlString("https://picsum.photos/200")))
                            .placeholderLoading { ProgressView() }
                            .placeholderFailure {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.orange)
                            }
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    row(title: "Invalid URL") {
                        ImageView(.remote(.urlString("")))
                            .placeholderFailure {
                                Image(systemName: "xmark.circle")
                                    .foregroundStyle(.red)
                            }
                            .resizable()
                            .frame(width: 64, height: 64)

                        ImageView(.remote(.urlString("https://picsum.photos/200")))
                            .placeholderLoading(image: .system("xmark.circle"))
                    }
                }

                Section("Kingfisher") {
                    row(title: "Injected Renderer") {
                        ImageView(
                            .remote(.urlString("https://picsum.photos/200")),
                            renderer: KingfisherRenderer()
                        )
                        .placeholderLoading { ProgressView() }
                        .resizable()
                        .frame(width: 64, height: 64)
                    }
                }
            }
            .navigationTitle("OneImage Sample")
        }
    }

    private func row(
        title: String,
        @ViewBuilder view: () -> some View
    ) -> some View {
        HStack(spacing: 16) {
            view()
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(title)
        }
        .padding(.vertical, 4)
    }
}

#Preview("Sample") {
    ContentView()
}
