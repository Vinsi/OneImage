//
//  Previews.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import SwiftUI
import View

private struct PreviewRow<Content: View>: View {
    let title: String
    let content: Content

    var body: some View {
        VStack(spacing: 8) {
            content
                .frame(width: 120, height: 120)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview("Local System Image") {
    PreviewRow(
        title: "ImageReference.local(.system)",
        content: ImageView(.local(.system("star.fill")))
    )
}

#Preview("Resizable") {
    PreviewRow(
        title: ".resizable()",
        content: ImageView(.local(.system("heart.fill"))).resizable()
    )
}

#Preview("Rendering Mode") {
    PreviewRow(
        title: ".renderingMode(.template)",
        content: ImageView(.local(.system("bell.fill")))
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.red)
    )
}

#Preview("Interpolation") {
    PreviewRow(
        title: ".interpolation(.none)",
        content: ImageView(.local(.system("star"))).resizable().interpolation(.none)
    )
}

#Preview("Antialiased") {
    PreviewRow(
        title: ".antialiased(false)",
        content: ImageView(.local(.system("star.fill"))).resizable().antialiased(false)
    )
}

#Preview("Remote URL") {
    PreviewRow(
        title: ".remote(.urlString)",
        content: ImageView(.remote(.urlString("https://picsum.photos/200/200")))
            .resizable()
    )
}

#Preview("Remote Loading Placeholder") {
    PreviewRow(
        title: ".placeholderLoading",
        content: ImageView(.remote(.urlString("https://picsum.photos/200/200")))
            .placeholderLoading { ProgressView() }
            .resizable()
    )
}

#Preview("Remote Failure Placeholder") {
    PreviewRow(
        title: ".placeholderFailure",
        content: ImageView(.remote(.urlString("")))
            .placeholderFailure {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.orange)
            }
            .resizable()
    )
}

private struct StyledAsyncRenderer: RemoteImageRenderer {
    @MainActor
    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> any View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .applying(style)
                    .saturation(0.2)
            case .failure:
                Image(systemName: "wifi.exclamationmark")
            @unknown default:
                failure
            }
        }
    }
}

#Preview("Injected Remote Renderer") {
    PreviewRow(
        title: ".environment(\\.remoteImageRenderer, ...)",
        content: ImageView(.remote(.urlString("https://picsum.photos/200/200")))
            .resizable()
            .environment(\.remoteImageRenderer, StyledAsyncRenderer())
    )
}
