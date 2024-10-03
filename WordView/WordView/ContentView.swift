import SwiftUI

struct ContentView: View {
    @State private var word: String = ""
    @State private var move: Bool = false
    @State private var definition: String = ""
    @EnvironmentObject var dict: DictionaryViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color("lightgray")
                GeometryReader { geometry in
                    VStack{
                        VStack (spacing: 5){
                            HStack {
                                Text("dictionary")
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.02, brightness: 0.363))
                                    .font(.system(size: 35, weight: .bold))
                                    .frame(width: geometry.size.width, alignment: .leading) // Align the text to the leading edge
                            }
                            ZStack{
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(.white)
                                    .frame(width: geometry.size.width, height: 60)

                                TextField("", text: $word)
                                    .font(.system(size: 20, weight: .semibold))
                                    .textCase(.lowercase)
                                    .frame(width: geometry.size.width-20, height: 50) // Use the view's width from GeometryReader
                                
                            }
                        }
                        HStack{
                            VStack (alignment: .leading){
                                if !dict.recent.isEmpty {
                                    Text("Recent searches")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.gray)
                                    ForEach(dict.recent, id: \.self) { word in
                                        Text("\(word)")
                                    }
                                }
                            }.padding(.top)

                            Spacer()
                            NavigationLink(destination: DetailWordView(word: word)) {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1))
                            }
                        }.frame(width: geometry.size.width)
                        

                    }
                }.padding()
                    .padding(.top, UIScreen.main.bounds.height/3)
                            }
            .ignoresSafeArea()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DictionaryViewModel()) // Provide a DictionaryViewModel instance

    }
}
