//
//  ContentView.swift
//  Auction Trading
//
//  Created by Hamza Amin on 12/11/2023.
//

import SwiftUI
import AVFoundation
import UIKit
import AVFoundation
import AnimateNumberText

let voice = Voice()
let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
var oneTimeTimer: Timer? = nil

var numberFormatter: NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.locale = .current
    numberFormatter.maximumFractionDigits = 0
    
    return numberFormatter
}

struct ContentView: View {
    @StateObject var properties = Properties()
    @FocusState var focused: Bool
   
    init() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor(rgb: 0x00B0F0)
    }
    
       /* .transition(.opacity).animation(
            .easeInOut(duration: 1)
                .repeatForever(autoreverses: false),
            value: properties.animationAmount
        ) */
    
    var title = "Bid Generator"
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        HeaderSection()
                        if properties.shouldShowAnimatedNumber {
                            let _ = print("Calling BottomListSection")
                            BottomListSection(properties: properties)
                        }
                        
                        MiddleFirstSection(properties: properties, focused: $focused)
                            .opacity(properties.shouldHideMiddleFirstSection ? 0 : 1)
                            .transition(.opacity)
                    }
                //    .animation(.easeInOut(duration: 1.0), value: properties.animationAmount)
                    BottomButtonSection(properties: properties, focused: $focused)
                }
            }
            .accentColor(Color.init(uiColor: UIColor(rgb: 0x00B0F0)))
            .preferredColorScheme(.light)
            .navigationTitle(title)
            .navigationBarHidden(false)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(
            perform: UIApplication.shared.addTapGestureRecognizer
        )
        .alert(isPresented: $properties.showAlert) {
            Alert(title: Text("Error"), message: Text(properties.error), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}

struct HeaderSection: View {
    var body: some View {
        Section {
            Text("Bid Generator")
                .font(Font.headline.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct MiddleFirstSection: View {
    @ObservedObject var properties: Properties
    @State private var startingNumberButtonText = "Generate"
    @State private var randomNumberButtonText = "Generate"
    @FocusState.Binding var focused: Bool
    
    private func format(string: String) -> String {
        let digits = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined()
       // let value = (Int(digits) ?? 0) / 100
        let value = (Int(digits) ?? 0)
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.currencySymbol = (Locale.current as NSLocale).object(forKey: .currencySymbol) as? String ?? ""
        let valueFormatted = currencyFormatter.string(from: NSNumber(value: value)) ?? ""
        return valueFormatted
    }

    var body: some View {
        VStack {
            HStack {
                Section {
                    Text("Opening Bid Range Minimum").frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                    Text("Opening Bid Range Maximum").frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                }
            }
            
            HStack {
                Section {
                    TextField("Input A", text: $properties.inputA)
                        .padding(.all)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.numberPad)
                        .focused($focused, equals: false)
                        .onChange(of: properties.inputA, perform: { newValue in
                            let valueFormatted = format(string: newValue)
                            if properties.inputA != valueFormatted {
                                properties.inputA = valueFormatted
                            }
                        })
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                $focused.wrappedValue = true
                            }
                        }
                    
                    
                    TextField("Input B", text: $properties.inputB)
                        .padding(.all)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: properties.inputB, perform: { newValue in
                            let valueFormatted = format(string: newValue)
                            if properties.inputB != valueFormatted {
                                properties.inputB = valueFormatted
                            }
                        })
                }
            }
            
            HStack {
                Section {
                    Text("Minimum Bid").frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                    Text("Maximum Bid").frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                }
            }
            
            HStack {
                Section {
                    TextField("Input C", text: $properties.inputC)
                        .padding(.all)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.numberPad)
                        .onChange(of: properties.inputC, perform: { newValue in
                            let valueFormatted = format(string: newValue)
                            if properties.inputC != valueFormatted {
                                properties.inputC = valueFormatted
                            }
                        })
                    
                    TextField("Input D", text: $properties.inputD)
                        .padding(.all)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: properties.inputD, perform: { newValue in
                            let valueFormatted = format(string: newValue)
                            if properties.inputD != valueFormatted {
                                properties.inputD = valueFormatted
                            }
                        })
                    
                }
            }
            
            HStack {
                Section {
                    Text("Number of bids").frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                    Text("Minimum Bid Increment").frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                }
            }
            
            HStack {
                Section {
                    TextField("Input G", text: $properties.inputG)
                        .padding(.all)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.numberPad)
                    
                    TextField("Input E", text: $properties.inputE)
                        .padding(.all)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: properties.inputE, perform: { newValue in
                            let valueFormatted = format(string: newValue)
                            if properties.inputE != valueFormatted {
                                properties.inputE = valueFormatted
                            }
                        })
                    
                }
            }
            
            HStack {
                Section {
                    Text("Seconds between bids").frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(UIColor.BlueView().render)
                        .font(Font.headline.weight(.bold))
                }
            }
            
            HStack {
                Section {
                    TextField("Input a number (1-10)", text: $properties.inputF)
                        .padding(.all)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
            }
        }
    }
}

struct BottomListSection: View {
    @ObservedObject var properties: Properties
    @State var speakingArray: [String] = []
    @State var textColor = Color(UIColor(rgb: 0x00B0F0))
    let notification = NotificationCenter.default.publisher(for: NSNotification.changeTextNow)

    var body: some View {
        VStack {
            let sum = properties.list.reduce(0, +)
            AnimateNumberText(font: .system(size: 40), weight: .bold, value: $properties.doubleNumber, textColor: $textColor, numberFormatter: numberFormatter)
                .frame(maxWidth: .infinity, alignment: .center)
            List(properties.list, id: \.self) { number in
                Text("$" + String(number))
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(properties.shouldShowList ? 1 : 0)
            Text("Total: " + String(sum))
                .opacity(properties.shouldShowList ? 1 : 0)
        }
        .onAppear() {
            print("onAppear got called")
            properties.shouldSpeak = true
            if !properties.appearedAlready {
                properties.appearedAlready = true
                properties.animationAmount = 1
                print("appearedAlready gotten true")
                if properties.shouldSpeak {
                    speakingArray.append("Auction Starting in")
                   // speakingArray.append("5")
                   // speakingArray.append("4")
                    speakingArray.append("3")
                    speakingArray.append("2")
                    speakingArray.append("1")
                    speakingArray.append("Opening bid")
                    
                    var i = 0
                    for sentence in speakingArray {
                        voice.speak(message: sentence)
                        i = i + 1
                    }
                 
                    speakingArray.removeAll()
                   
                    Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { time in
                        print("Inside 10 second delay timer: ", time.timeInterval)
                        print("Inside if as properties.shouldSpeak 0: ", properties.shouldSpeak)
                        print("Inside if as properties.timeRemaining 0: ", properties.timeRemaining)
                        properties.timeRemaining = 0
                        changeText(properties.index)
                    }
                }
            }
        }
        .onReceive(notification) { (object) in
            print("Got inside onReceive(notification)")
            if let userInfo = object.userInfo, let change = userInfo["change"] {
                print(change)
                properties.index = properties.index + 1
                changeText(properties.index)
            }
        }
    }
    
    
    func changeText(_ iteration: Int = 0) {
        if properties.shouldSpeak && properties.timeRemaining != -1 {
            print("Inside if as properties.shouldSpeak: ", properties.shouldSpeak)
            print("Inside if as properties.timeRemaining: ", properties.timeRemaining)
            if iteration < properties.list.count {
                let i = iteration
                let numberText = properties.list[i]
                self.delay(Double(properties.inputF)!) {
                    if properties.shouldSpeak && properties.timeRemaining != -1 {
                        print("Inside if as properties.shouldSpeak 2: ", properties.shouldSpeak)
                        print("Inside if as properties.timeRemaining 2: ", properties.timeRemaining)
                        properties.doubleNumber = Double(numberText)
                        voice.speak(message: String(numberText))
                       // changeText(i+1)
                    }
                }
            }
            else {
                if properties.shouldSpeak && properties.timeRemaining != -1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        if properties.shouldSpeak && properties.timeRemaining != -1 {
                            let sum = properties.list.reduce(0, +)
                          //  voice.speak(message: "Sound effect of a hammer going down")
                            voice.speak(message: "And total displayed on screen")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                if properties.shouldSpeak && properties.timeRemaining != -1 {
                                    print("Inside if as properties.shouldSpeak 3: ", properties.shouldSpeak)
                                    print("Inside if as properties.timeRemaining 3: ", properties.timeRemaining)
                                    properties.doubleNumber = Double(sum)
                                    voice.speak(message: String(sum))
                                    properties.shouldSpeak = false
                                    properties.shouldShowList = true
                                    properties.index = 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BottomButtonSection: View {
    @ObservedObject var properties: Properties
    @FocusState.Binding var focused: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                print("Start/Start Over tapped!")
                startOver(properties: properties)
                game(properties: properties)
                properties.startGameText = "Start Over"
            }, label: {
                Text(properties.startGameText)
                .frame(maxWidth: .infinity)
                .padding()
                .font(.system(size: 14))
                .foregroundColor(.white)
                .background(Color.init(UIColor(rgb: 0x00B0F0)))
                .cornerRadius(15)
            })
            .frame(maxWidth: .infinity)
            
            Button(action: {
                print("Repeat Game!")
                repeatGame(properties: properties)
                game(properties: properties)
            }, label: {
                Text("Repeat Game")
                .frame(maxWidth: .infinity)
                .padding()
                .font(.system(size: 14))
                .foregroundColor(.white)
                .background(Color.init(UIColor(rgb: 0x00B0F0)))
                .cornerRadius(15)
            })
            .frame(maxWidth: .infinity)
            
            Button(action: {
                print("New Game tapped!")
                startNewGame(properties: properties)
            }, label: {
                Text("New Game")
                .frame(maxWidth: .infinity)
                .padding()
                .font(.system(size: 14))
                .foregroundColor(.white)
                .background(Color.init(UIColor(rgb: 0x00B0F0)))
                .cornerRadius(15)
            })
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

func startNewGame(properties: Properties) {
    properties.inputA = ""
    properties.inputB = ""
    properties.inputC = ""
    properties.inputD = ""
    properties.inputG = ""
    properties.inputE = ""
    properties.inputF = "3"
    properties.timeRemaining = -1
    properties.doubleNumber = 0
    properties.index = 0
    properties.animationAmount = 2
    properties.shouldShowAnimatedNumber = false
    properties.shouldShowList = false
    properties.shouldSpeak = false
    properties.shouldHideMiddleFirstSection = false
    properties.appearedAlready = false
    properties.repeatGame = false
    properties.repeatGameList = []
    voice.stop()
   // timer.upstream.connect().cancel()
}

func repeatGame(properties: Properties) {
    properties.timeRemaining = -1
    properties.doubleNumber = 0
    properties.index = 0
    properties.animationAmount = 2
    properties.shouldShowAnimatedNumber = false
    properties.shouldShowList = false
    properties.shouldSpeak = false
    properties.shouldHideMiddleFirstSection = false
    properties.appearedAlready = false
    properties.repeatGame = true
    voice.stop()
}

func startOver(properties: Properties) {
    properties.timeRemaining = -1
    properties.doubleNumber = 0
    properties.index = 0
    properties.animationAmount = 2
    properties.shouldShowAnimatedNumber = false
    properties.shouldShowList = false
    properties.shouldSpeak = false
    properties.shouldHideMiddleFirstSection = false
    properties.appearedAlready = false
    properties.repeatGame = false
    properties.repeatGameList = []
    voice.stop()
   // timer.upstream.connect().cancel()
}

func game(properties: Properties) {
    var startingNumber = 0
    print(properties.inputA)
    print(properties.inputB)
    let inputA = Int.getInt(string: properties.inputA) ?? 0
    let inputB = Int.getInt(string: properties.inputB) ?? 0
    let inputAInt = Int("\(inputA)")
    let inputBInt = Int("\(inputB)")
    
    print(properties.inputC)
    print(properties.inputD)
    let inputC = Int.getInt(string: properties.inputC) ?? 0
    let inputD = Int.getInt(string: properties.inputD) ?? 0
    let inputCInt = Int("\(inputC)")
    let inputDInt = Int("\(inputD)")
    
    let inputG = properties.inputG
    let inputGInt = Int("\(inputG)")
    
    let inputE = Int.getInt(string: properties.inputE) ?? 0
    let inputEInt = Int("\(inputE)")
    
    let inputF = properties.inputF
    let inputFInt = Int("\(inputF)")
    
   /* print(inputAInt)
    print(inputBInt)
    print(inputCInt)
    print(inputDInt)
    print(inputGInt)
    print(inputEInt)
    print(inputFInt) */
    
    if((inputAInt != nil) && (inputBInt != nil) && (inputCInt != nil) && (inputDInt != nil) && (inputGInt != nil) && (inputEInt != nil) && (inputFInt != nil)) {
        if(inputAInt! >= 500 && inputBInt! >= 500) {
            if(inputAInt! < inputBInt!) {
                if(inputEInt! > 0) {
                    // startingNumber = (Int.random(in: inputAInt!...inputBInt!) + 1) * inputEInt!
                     startingNumber = Int.random(min: inputAInt!, max: inputBInt!, minIncrement: inputEInt!)
                     
                     if(inputCInt! >= 500 && inputDInt! >= 500) {
                         if(inputCInt! < inputDInt!) {
                             if(inputFInt! >= 1 && inputFInt! <= 10) {
                                 //$focused.wrappedValue = false
                                 // var uniqueNumbers = Int.getUniqueRandomNumbers(min: inputCInt!, max: inputDInt!, count: inputGInt!, minIncrement: inputEInt!)
                                 var uniqueNumbers = Int.random2(min: inputCInt!, max: inputDInt!, count: inputGInt!, minIncrement: inputEInt!)
                                 uniqueNumbers = Int.getRepeatedRandomNumbers(numbers: uniqueNumbers)
                                 uniqueNumbers.sort()
                                 uniqueNumbers.insert(startingNumber, at: 0)
                                 print(uniqueNumbers)
                                 
                                 if !properties.repeatGame {
                                     properties.list = uniqueNumbers
                                     properties.repeatGameList = uniqueNumbers
                                 }
                                 else {
                                     if properties.repeatGameList.count == 0 {
                                         properties.repeatGameList = uniqueNumbers
                                     }
                                     properties.list = properties.repeatGameList
                                 }
                                // properties.repeatGameList = uniqueNumbers
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                      properties.shouldShowAnimatedNumber = true
                                      properties.shouldHideMiddleFirstSection = true
                                     // properties.shouldSpeak = true
                                 }
                             }
                             else {
                                 properties.error = "Seconds between bids need to be between 1 and 10"
                                 properties.showAlert = true
                             }
                         }
                         else {
                             properties.error = "Input C needs to be smaller than Input D"
                             properties.showAlert = true
                         }
                     }
                     else {
                         properties.error = "Random Number inputs need to be >= 500"
                         properties.showAlert = true
                     }
                }
                else {
                    properties.error = "Input E can't be zero"
                    properties.showAlert = true
                }
            }
            else {
                properties.error = "Input A needs to be smaller than Input B"
                properties.showAlert = true
            }
           // print(startingNumber)
        }
        else {
            properties.error = "Starting number inputs need to be >= 500"
            properties.showAlert = true
        }
    }
    else {
        properties.error = "Please fill all fields"
        properties.showAlert = true
    }
}

class Properties: ObservableObject {
    @Published var shouldShowAnimatedNumber = false
    @Published var shouldShowList = false
    @Published var shouldSpeak = false
    @Published var shouldHideMiddleFirstSection = false
    @Published var inputA = ""
    @Published var inputB = ""
    @Published var inputC = ""
    @Published var inputD = ""
    @Published var inputG = ""
    @Published var inputE = ""
    @Published var inputF = "3"
    @Published var startGameText = "Start Game"
    @Published var timeRemaining = -1
    @Published var doubleNumber: Double = 0
    @Published var index: Int = 0
    @Published var animationAmount: Double = 2
    @Published var list: [Int] = []
    @Published var showAlert = false
    @Published var error = ""
    @Published var appearedAlready = false
    @Published var repeatGame = false
    @Published var repeatGameList:[Int] = []
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

class Voice: NSObject, AVSpeechSynthesizerDelegate {
    var synthesizer: AVSpeechSynthesizer? = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synthesizer?.delegate = self
    }
    
    func speak(message: String) {
        if synthesizer == nil {
            synthesizer = AVSpeechSynthesizer()
            synthesizer?.delegate = self
        }
        print("[TTS][Speak]\n\(message)")
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
        utterance.rate = 0.5
        utterance.postUtteranceDelay = 1.5
        synthesizer!.speak(utterance)
    }
    
    func stop() {
        if synthesizer != nil {
            if synthesizer!.isSpeaking {
                synthesizer!.stopSpeaking(at: .immediate)
                synthesizer = nil
            }
        }
    }
    
    func isSpeaking() -> Bool {
        return synthesizer!.isSpeaking
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish got called")
        print(utterance.speechString)
        
        if(String.isInt(utterance.speechString))() {
            print("Spoken word is an integer")
            let spokenInteger = Int(utterance.speechString)
            if(spokenInteger! >= 500) {
                print("Sending notification")
                NotificationCenter.default.post(name: NSNotification.changeTextNow, object: nil, userInfo: ["change": true])
            }
        }
        
    }
}
