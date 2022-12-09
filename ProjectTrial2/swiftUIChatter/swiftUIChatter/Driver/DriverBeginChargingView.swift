//
//  DriverBeginChargingView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/6/22.
//

import SwiftUI

struct DriverBeginChargingView: View {
    @Binding var showChargingView: Bool
    @State private var labelText = "Start Charging"
    @State var about_me : HostAboutMe
    
    //my code   -   -   -   -
    @ObservedObject var stopWatch = Stop_Watch()
    @ObservedObject var costometer = Costometer()
    var name = ""
    @State var isTimerRunning = false
    //put testing api here
    //API.shared.getUser()
    //let user = API.shared.users[0]
    //Text("$\(user.first_name)")
    //  -   -   -   -   -   -   -   -   -   -   -
    
    private mutating func test_getUser() {
//        API.shared.getUser(id:1)
//        name = API.shared.users[0].first_name
    }
    func viewDidAppear() {
        //super.viewDidAppear()
        
    }
    
    var charge_duration = 2.0
    @State var cost = 4.1
   
    
    
    var body: some View {
        //  -   -   -   -   -   -
        let hours = String(format: "%02d", Int(round(Double(stopWatch.counter / 3600))*100)/100)
        let minutes = String(format: "%02d", (stopWatch.counter / 60) % 60)
        let seconds = String(format: "%02d", Int(round(Double(stopWatch.counter % 60))*100)/100)
        let union = hours + " : " + minutes + " : " + seconds
        
        let mon = String(format: "%.2f", round(costometer.counter*100)/100.0)
       
        
        
        
        
        //  -   -   -   -   -   -   -   -
        NavigationView{
            //ZStack {
                VStack(){
                    
                    ProgressView(value: 0.2){
                        Text("Start Charge")
                    }.padding()
                    Spacer()
                    
                    Text(about_me.first_name)
                    Text("Charger Cost / hour: $\(String(format: "%.2f", round(cost*100)/100.0))")
//                    let estimatedCost = charge_duration * cost
//                    Text("Estimated Total Cost: $\(String(format: "%.2f",round(estimatedCost*100)/100.0))")
                    
                    Spacer()
                    
                   
                    HStack {
                        
                        Text("Duration:")
                        Text("\(union)")
                            .foregroundColor(.teal)
                            .font(.custom("", size: 20))
                    }
                    //the cost
                    HStack {
                        
                        Text("Cost: $")
                        Text("\(mon)")
                            .foregroundColor(.teal)
                            .font(.custom("", size: 20))
                    }
                                
                    
                    
                    Spacer()
            HStack{
                //put testing api here
                //API.shared.getUser()
                //let user = API.shared.users[0]
                //Text("$\(user.first_name)")
                
                Button(
                    action: {
                        //self.test_getUser()
                        //start timer
                        if (isTimerRunning == false) {
                            self.stopWatch.start()
                            self.costometer.start(x: self.cost)
                            isTimerRunning = true
                            
                        } else {
                            
                            self.stopWatch.stop()
                            self.costometer.stop()
                            
                            Task{
                                await API.shared.updateChargerAvailablityToTrue(about_me.cid)
                            }
                            
                        }
                        
                        if(labelText == "Start Charging"){
                            labelText = "End Charge"
                        }
                        else{
                            labelText = "Start Charging"
                        }
                    },
                    label: {Text("\(labelText)")
                            .frame(width: 120, height: 40)
                            .foregroundColor(Color.white)
                    })
                .background(Color.blue)
                .cornerRadius(10.0)
                .padding(.bottom, 10)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                
                
                
                
                //go to next view
                NavigationLink(destination: DriverPaymentChargingView(showChargingView: self.$showChargingView, about_me: self.about_me, cost: mon, duration: union)){
                    Text("Next")
                    
                }
                
                //                .background(Color.blue)
                //                .cornerRadius(10.0)
                //                .padding(.trailing)
                //                .shadow(color: Color.black.opacity(0.3),
                //                        radius: 3,
                //                        x: 3,
                //                        y: 3)
                
            }//HStack
                    
                }//VStack
            
        }//NavigationView
    }//VieW
}



/*struct DriverBeginChargingView_Previews: PreviewProvider {
    static var previews: some View {
        DriverBeginChargingView(showChargingView: .constant(true))
    }
}*/

class Stop_Watch: ObservableObject {
    
    @Published var counter: Int = 0
    var timer = Timer()
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                   repeats: true) { _ in
            self.counter += 1
        }
    }
    
    func stop() {
        self.timer.invalidate()
    }
    func reset() {
        self.counter = 0
        self.timer.invalidate()
    }
}

class Costometer: ObservableObject {
    
    @Published var counter: Double = 0
    var timer = Timer()
    
    func start(x: Double) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                                   repeats: true) { _ in
            self.counter += x / 3600
        }
    }
    
    func stop() {
        self.timer.invalidate()
    }
    func reset() {
        self.counter = 0
        self.timer.invalidate()
    }
}
