//
//  DetailWordView.swift
//  WordView
//
//  Created by Phillip Le on 10/9/23.
//

import SwiftUI

struct DetailWordView: View {
    @State var word : String
    @State private var definition: String = ""
    @State private var rhymes: [String] = []
    @EnvironmentObject var dict: DictionaryViewModel
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("\(word)")
                    .textCase(.lowercase)
                    .font(.system(size: 40, weight: .semibold))
                    .padding(.bottom, 5)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                Text("DEFINITIONS")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                Text("1. \(definition)")
                    .padding(.bottom)
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))


                Text("Words that rhyme for your raps and poems ")
                    .textCase(.uppercase)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                
                VStack(alignment: .leading){
                    ForEach(rhymes, id: \.self) { rhyme in
                        Text(rhyme)
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                    }
                }
               
            }
           
        }.frame(width: UIScreen.main.bounds.width-10)
        .onAppear{
            dict.getDef(word: word) { result in
                switch result {
                case .success(let definition):
                    self.definition = definition
                case .error:
                    self.definition = "Hm, never heard of that one"
                }
            }
            dict.findRhymes(word: word){ result in
                switch result{
                case .success(let words):
                    print(words)
                    self.rhymes = words
                case .error:
                    print("oops")
                }
            }
        }
    }
}

#Preview {
    DetailWordView(word: "Hello")
        .environmentObject(DictionaryViewModel())
}
