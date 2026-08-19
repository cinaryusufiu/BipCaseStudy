//
//  LoadingView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.2)
                .padding(BipSpacing.large)
                .background(
                    RoundedRectangle(cornerRadius: BipSpacing.medium)
                        .fill(Color.black.opacity(0.7))
                )
        }
    }
}
