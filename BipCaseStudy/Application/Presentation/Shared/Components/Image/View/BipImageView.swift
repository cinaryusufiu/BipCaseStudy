//
//  BipImageView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipImageView: View {

    let provider: BipImageViewProviderProtocol

    @State private var remoteImage: UIImage?
    @State private var isLoading = false

    // MARK: - Body

    var body: some View {
        Group {
            imageContent
        }
        .applyOptionalFrame(style: provider.style)
        .applyClipping(using: provider.style.shape)
        .applyBorder(from: provider.style)
        .task(id: provider.imageURL) {
            await loadRemoteImageIfNeeded()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var imageContent: some View {
        if let remoteImage {
            Image(uiImage: remoteImage)
                .resizable()
                .aspectRatio(contentMode: provider.style.contentMode)
        } else if isLoading {
            placeholder
        } else if let systemName = provider.systemName {
            systemImage(systemName)
        } else if let name = provider.imageName {
            localImage(name)
        } else if provider.imageURL != nil {
            placeholderIcon
        }
    }

    // MARK: - Image Variants

    private func systemImage(_ name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .renderingMode(provider.style.tintColor != nil ? .template : .original)
            .aspectRatio(contentMode: provider.style.contentMode)
            .applyTint(provider.style.tintColor)
    }

    private func localImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .renderingMode(provider.style.tintColor != nil ? .template : .original)
            .aspectRatio(contentMode: provider.style.contentMode)
            .applyTint(provider.style.tintColor)
    }

    // MARK: - Placeholder

    private var placeholder: some View {
        ZStack {
            provider.style.backgroundColor ?? Color.clear
            ProgressView()
        }
    }

    private var placeholderIcon: some View {
        Image(systemName: BipIcons.photo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.gray.opacity(0.4))
            .padding(20)
    }

    // MARK: - Remote Loading

    private func loadRemoteImageIfNeeded() async {
        guard let urlString = provider.imageURL, urlString.isNotEmpty else { return }

        isLoading = true
        defer { isLoading = false }
        remoteImage = await ServiceLocator.shared.imageCache?.loadImage(from: urlString)
    }
}
