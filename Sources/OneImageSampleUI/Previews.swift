//
//  Previews.swift
//  OneImage
//
//  Created by Vinsi on 23.8.26.
//

import OneImageView
import SwiftUI

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

#Preview("Kingfisher Renderer") {
    PreviewRow(
        title: "ImageView(..., renderer: KingfisherRenderer())",
        content: ImageView(
            .remote(.urlString("https://picsum.photos/200/200")),
            renderer: KingfisherRenderer()
        )
        .placeholderLoading { ProgressView() }
        .resizable()
    )
}
