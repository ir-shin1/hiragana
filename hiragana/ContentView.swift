//
//  ContentView.swift
//  hiragana
//
//  Created by ir-shin1 on 2021/05/05.
//

import SwiftUI
import AVFoundation

struct StringState {
    var str: String = ""

    mutating func appendChar(_ char: String) {
        if char == "消" {
            str = ""
        } else if char == "゛" {
            if str.count > 0 {
                let range = "かきくけこさしすせそたちつてとはひふへほ".range(of: String(str.suffix(1)))
                if range != nil {
                    str = String(str.prefix(str.count - 1)) + "がぎぐげござじずぜぞだぢづでどばびぶべぼ"[range!]
                }
            }
        } else if char == "゜" {
            if str.count > 0 {
                let range = "はひふへほ".range(of: String(str.suffix(1)))
                if range != nil {
                    str = String(str.prefix(str.count - 1)) + "ぱぴぷぺぽ"[range!]
                }
            }
        } else if char == "←" {
            if str.count > 0 {
                str = String(str.prefix(str.count - 1))
            }
        } else {
            str = str + char
        }
    }
}

struct ContentView: View {
    @State var state = StringState()
    @State var wordList: WordLists
    @State var offset: Int = 0
    @State var kirakiraSound = AVAudioPlayer()

    init() {
        var words = WordLists()
        words.FileLoad()
        _wordList = State(initialValue: words)

        if let asset = NSDataAsset(name: wordList.list[offset].yomi) {
            kirakiraSound = try! AVAudioPlayer(data: asset.data)
        }
    }

    var body: some View {
        let hirakana: [[String]] = [
             ["あ", "い", "う", "え", "お"],
             ["か", "き", "く", "け", "こ"],
             ["さ", "し", "す", "せ", "そ"],
             ["た", "ち", "つ", "て", "と"],
             ["な", "に", "ぬ", "ね", "の"],
             ["は", "ひ", "ふ", "へ", "ほ"],
             ["ま", "み", "む", "め", "も"],
             ["や", "ゆ", "よ", "゛", "゜"],
             ["ら", "り", "る", "れ", "ろ"],
             ["わ", "を", "ん", "←", "消"]
        ]
             
        VStack(alignment: .trailing, spacing: 10){
            HStack {
                Text(wordList.list[offset].yomi)
                    .font(.system(size:96, weight: .black, design: .default)) //
                    .lineLimit(3)      //
                    .padding(.bottom, 64) //
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.red)
                    .onTapGesture {
                        self.kirakiraSound.stop()
                        self.kirakiraSound.currentTime = 0.0
                        self.kirakiraSound.play()
                    }
                Text(wordList.list[offset].ji)
                    .font(.system(size:192, weight: .light, design: .rounded)) //
                    .lineLimit(3)      //
                    .padding(.bottom, 64) //
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
            }
            Spacer()
            HStack {
                Text(state.str)
                    .font(.system(size:96, weight: .black, design: .default)) //
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/) //
                    .lineLimit(3)      //
                    .padding(.bottom, 64) //
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        state.appendChar("←")
                    }
            }
            Spacer()

            HStack {
                ForEach(0 ..< 10, id: \.self) { l in
                    VStack(spacing: 10) {
                        ForEach(0 ..< 5) { c in
                            CharView(char: hirakana[l][c], state: $state)
                        }
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Button(action: {
                    state.str = ""
                    let offset_old = offset
                    repeat {
                        offset = Int.random(in: 0..<wordList.list.count)
                    } while offset_old == offset || wordList.list[offset].yomi == ""

                    if let asset = NSDataAsset(name: wordList.list[offset].yomi) {
                        self.kirakiraSound = try! AVAudioPlayer(data: asset.data)
                    }
                }) {
                    Text("次")
                        .font(.system(size:60, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 256, height: 64)
                        .background(Color.gray)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.9), radius: 5, x: 5, y: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(30)
                }
            }
        }
    }
}

struct CharView: View {
    var char: String
    @Binding var state: StringState

    var body: some View {
        Button(action: {
            state.appendChar(self.char)
        }) {
            Text(char)
                .font(.system(size:60, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(Color.blue)
                .cornerRadius(20)
                .shadow(color: Color.blue.opacity(0.9), radius: 5, x: 5, y: 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
