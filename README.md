# LinkTextView
How to use.

    func addLink() {
        let termsOfUse = "Terms of Use"
        let privactPolicy = "Privacy Policy"
        linkTextView.text = "Please read the Some Company \(termsOfUse) and \(privactPolicy)"
         textView.addLinks([ termsOfUse: "https://some.com/tu",
            privactPolicy: "https://some.com/pp"
        ], linkColor: .blue)
        textView.allowTapOnly = true
        textView.onLinkTap = { url in
            print("url: \(url)")
            return false
        }
    }
