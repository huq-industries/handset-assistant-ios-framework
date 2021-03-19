//
//  ContentView.swift
//  SampleApplication
//
//  Created by Isambard Poulson on 17/03/2021.
//

import SwiftUI
import HandsetAssistant

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Button("start recording") {
                startRecording()
            }
            Button("stop recording") {
                stopRecording()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func startRecording()
{
    let assistant: HandsetRecorder = HandsetRecorder.shared
    assistant.startRecording(apiKey: "6f3b4909-3bea-48a2-8390-35b1a72f207c")
}

func stopRecording()
{
    let assistant: HandsetRecorder = HandsetRecorder.shared
    assistant.stopRecording()
}
