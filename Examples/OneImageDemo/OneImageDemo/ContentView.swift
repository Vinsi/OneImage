import OneImageView
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Local — your assets") {
                    row(title: "Asset catalog") {
                        ImageView(.local(.asset("sample")))
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    row(title: "Asset catalog (explicit bundle)") {
                        ImageView(.local(.asset("sample", bundle: .main)))
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    row(title: "SF Symbol") {
                        ImageView(.local(.system("star.fill")))
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                }

                Section("Remote — built-in renderer") {
                    row(title: "AsyncImage default") {
                        ImageView(.remote(.urlString("https://picsum.photos/200")))
                            .placeholderLoading { ProgressView() }
                            .placeholderFailure {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.orange)
                            }
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                }

                Section("Remote — Kingfisher renderer") {
                    row(title: "KFImage injected") {
                        ImageView(
                            .remote(.urlString("https://picsum.photos/200")),
                            renderer: KingfisherRenderer()
                        )
                        .placeholderLoading { ProgressView() }
                        .placeholderFailure {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.orange)
                        }
                        .resizable()
                        .frame(width: 64, height: 64)
                    }
                }
            }
            .navigationTitle("OneImage Demo")
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

#Preview {
    ContentView()
}
