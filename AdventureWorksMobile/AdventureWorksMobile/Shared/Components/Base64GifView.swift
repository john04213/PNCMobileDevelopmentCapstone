//
//  Base64GifView.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 10/1/26.
//


import SwiftUI
import WebKit

struct Base64GifView: UIViewRepresentable {
    let base64String: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Clean up base64 string if it contains a data URI prefix (e.g., data:image/gif;base64,)
        let pureBase64 = base64String.components(separatedBy: ",").last ?? base64String
        
        if let gifData = Data(base64Encoded: pureBase64, options: .ignoreUnknownCharacters) {
            uiView.load(
                gifData,
                mimeType: "image/gif",
                characterEncodingName: "utf-8",
                baseURL: URL(string: "about:blank")!
            )
        }
    }
}
