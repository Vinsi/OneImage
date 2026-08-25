import SwiftUI
import Testing

@testable import View

@MainActor
struct ImageViewRenderingTests {

    @Test func localSystemImageRenders() {
        let view = ImageView(.local(.system("star")))
        let renderer = ImageRenderer(content: view)

        #expect(renderer.cgImage != nil)
    }

    @Test func resizableRendersAtProposedSize() {
        let view = ImageView(.local(.system("star"))).resizable()
        let renderer = ImageRenderer(content: view)
        renderer.proposedSize = .init(width: 100, height: 100)

        let image = renderer.cgImage
        #expect(image != nil)
        #expect(image?.width == 100)
        #expect(image?.height == 100)
    }

    @Test func invalidRemoteURLFallsBackToFailurePlaceholder() {
        let view = ImageView(.remote(.urlString("")))
            .placeholderFailure { Text("Failed") }
        let renderer = ImageRenderer(content: view)

        #expect(renderer.cgImage != nil)
    }

    @Test func resizableModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).resizable()

        #expect(view.configuration.style.resize != nil)
    }

    @Test func renderingModeModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).renderingMode(.template)

        #expect(view.configuration.style.renderingMode == .template)
    }

    @Test func interpolationModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).interpolation(.none)

        #expect(view.configuration.style.interpolation == .some(.none))
    }

    @Test func antialiasedModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).antialiased(false)

        #expect(view.configuration.style.isAntialiased == false)
    }

    @Test func setCornerRadiusModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).setCornerRadius(8)

        #expect(view.configuration.cornerRadius == 8)
    }

    @Test func styleSurvivesPlaceholderReplacement() {
        let view = ImageView(.local(.system("star")))
            .resizable()
            .renderingMode(.template)
            .placeholderFailure { Text("Failed") }

        #expect(view.configuration.style.resize != nil)
        #expect(view.configuration.style.renderingMode == .template)
    }

    @Test func defaultRendererPinsAsyncImage() {
        let view: ImageView<EmptyView, EmptyView, AsyncImageRenderer> =
            ImageView(.remote(.urlString("https://example.com/a.png")))

        let renderer = ImageRenderer(content: view)
        _ = renderer.cgImage
    }
}

private final class RendererCallBox: @unchecked Sendable {
    var urls: [URL] = []
    var style: ImageStyle?
}

private struct FakeRenderer: RemoteImageRenderer {
    let box: RendererCallBox

    @MainActor
    func makeRemoteImage<Loading: View, Failure: View>(
        url: URL,
        loading: ImagePlaceholder<Loading>,
        failure: ImagePlaceholder<Failure>,
        style: ImageStyle
    ) -> Text {
        box.urls.append(url)
        box.style = style
        return Text("remote")
    }
}

@MainActor
struct RemoteImageRendererInjectionTests {

    @Test func rendererIsInvokedWithURLAndStyle() {
        let box = RendererCallBox()
        let view = ImageView(
            .remote(.url(URL(string: "https://example.com/a.png")!)),
            renderer: FakeRenderer(box: box)
        )
        .resizable()

        let renderer = ImageRenderer(content: view)
        _ = renderer.cgImage

        #expect(box.urls.first?.absoluteString == "https://example.com/a.png")
        #expect(box.style?.resize != nil)
    }

    @Test func rendererSurvivesPlaceholderReplacement() {
        let box = RendererCallBox()
        let view = ImageView(
            .remote(.urlString("https://example.com/a.png")),
            renderer: FakeRenderer(box: box)
        )
        .placeholderFailure { Text("Failed") }

        let renderer = ImageRenderer(content: view)
        _ = renderer.cgImage

        #expect(box.urls.count == 1)
    }

    @Test func asyncImageRendererBuildsRemoteView() {
        let view = AsyncImageRenderer().makeRemoteImage(
            url: URL(string: "https://picsum.photos/200")!,
            loading: .none,
            failure: .none,
            style: ImageStyle()
        )

        let renderer = ImageRenderer(content: view)
        _ = renderer.cgImage
    }
}
