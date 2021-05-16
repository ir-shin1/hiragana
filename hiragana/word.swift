//
//  word.swift
//  hiragana
//
//  Created by ir.shin1 on 2021/05/08.
//

import Foundation

struct WordList {
    var yomi: String
    var ji: String
    var url: String
}

struct WordLists {
    var list: [WordList] = []
    
    mutating func FileLoad() {
        /// ①プロジェクト内にある"wordlist.csv"のパス取得
        guard let fileURL = Bundle.main.url(forResource: "wordlist", withExtension: "csv")  else {
            fatalError("ファイルが見つからない")
        }
         
        /// ②wordlist.csvファイルの内容をfileContents:Stringに読み込み
        guard let fileContents = try? String(contentsOf: fileURL) else {
            fatalError("ファイル読み込みエラー")
        }
                
        /// ③ファイルの内容を"\n"で分割、１行づつ処理
        for capital in fileContents.components(separatedBy: "\n") {
            let values = capital.components(separatedBy: ",")
            if values.count >= 3 {
                self.list.append(WordList(yomi: values[0], ji: values[1], url: values[2]))
            }
        }
    }
}

