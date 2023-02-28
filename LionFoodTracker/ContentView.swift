//
//  ContentView.swift
//  LionFoodTracker
//
//  Created by yuan chen on 2/15/23.
//

import SwiftUI
import AVFoundation
import UIKit
import Charts
import Photos
import WebKit
import Foundation
import Alamofire


struct FancyLoadingView: View {
    let gradient = Gradient(colors: [.pink, .purple])
    let lineWidth: CGFloat = 4
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color(UIColor(hex: "#e9ffe9")) // background color
                .ignoresSafeArea()
            
            Circle()
                .trim(from: 0, to: isLoading ? 1 : 0)
                .stroke(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing), lineWidth: lineWidth)
                .rotationEffect(.degrees(-90))
                .animation(Animation.easeInOut(duration: 2).delay(0.5).repeatForever(autoreverses: false))
                .frame(width: 80, height: 80)
            
            Image(systemName: "leaf.arrow.circlepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
                .rotationEffect(.degrees(isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 2).delay(0.5).repeatForever(autoreverses: false))
        }
        .onAppear {
            isLoading = true
        }
    }
}








struct ProfileView: View {
    var body: some View {
        Text("Profile Page")
            .navigationBarTitle("Profile")
            .background(Color(UIColor(hex: "#D5CCC4")))
    }
}


/// ^^^ Profile Icon --- - - - - - - - - --  -  - -

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isSuccessfulLogin = false
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var loggedInUsername = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(5.0)
                .padding(.top, 30)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(5.0)
                .padding(.top, 10)

            Button(action: {
                isSuccessfulLogin = false
                if username.isEmpty || password.isEmpty {
                    isSuccessfulLogin = false
                } else {
                    isSuccessfulLogin = true
                }
                // Add authentication logic here

                // Dismiss the keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                name = ["Jack", "Andy", "Minseo","Brintny","Jude","QiuLing"].randomElement() ?? ""
                username = ""
                password = ""
                loggedInUsername = name

            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .padding(.top, 30)

            if isSuccessfulLogin {
                Text("Successfully logged in as \(name) !")
                    .foregroundColor(.green)
                    .padding(.top, 10)
                    .background(Color.white)
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Go back")
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            // Remove keyboard when the view appears
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}




/// ^^^ Login Page
/*
struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .denied || status == .restricted {
            imagePicker.sourceType = .photoLibrary
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    imagePicker.sourceType = .photoLibrary
                }
            }
        }
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
    }
}
 */
/*
struct Old_ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType

    // Add the following properties to allow the user to select an image from their photo library
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    typealias UIViewControllerType = UIImagePickerController

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // If the user selected an image, set the selectedImage property to the selected image
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage

                // Save the selected image to the photo library
                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
*/
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}


///-----------------------Menu View-----------------------


///-----------------------Camera View-----------------------


/*
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
*/
/// Food Waste --------------

/*
struct FoodWasteView: View {
    @State private var isShowingPhotoLibrary = false
    @State private var selectedImage: UIImage?
    @State private var foodWasteData: [String: String] = [:]
    
    let defaultFoodWasteData = [
        "Chicken": "0lbs",
        "Fruit": "0lbs",
        "Vegetables": "0lbs",
        "Bread": "0lbs",
        "Dairy": "0lbs"
    ]
    
    var body: some View {
        List(foodWasteData.sorted(by: <), id: \.key) { key, value in
            HStack {
                Text(key)
                Spacer()
                Text("Wasted \(value)")
            }
        }
        .navigationBarTitle(Text("Food Waste Data"))
        // Add a button that opens the photo library
        .navigationBarItems(trailing:
            Button(action: {
                isShowingPhotoLibrary = true
            }, label: {
                Image(systemName: "photo.on.rectangle")
                    .foregroundColor(.white)
                    .font(.title)
            })
            .sheet(isPresented: $isShowingPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
            }
        )
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .scaleEffect(3.0)
                Button(action: {
                    // Update food waste data here
                    for (key, value) in defaultFoodWasteData {
                        let randomWeight = Double.random(in: 0...2)
                        let final_randomWeight = Double(round(randomWeight * 100)/100)
                        if let intValue = Double(value.replacingOccurrences(of: "lbs", with: "")) {
                            let newWeight = intValue + final_randomWeight
                            foodWasteData[key] = "\(newWeight) lbs"
                        }
                    }

                        selectedImage = nil
                    }, label: {
                    Text("Add")
                            .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .clipShape(Capsule())
                })
                .padding(.bottom, 10)
            } else {
                Text("No image selected")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            // Add a button to remove the selected image
            if selectedImage != nil {
                Button("Remove", action: {
                    selectedImage = nil

                })
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.red)
                .cornerRadius(10)
                .clipShape(Capsule())
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Trash"))
        .navigationBarItems(trailing:
            Button(action: {
                isShowingPhotoLibrary = true
            }, label: {
                Image(systemName: "photo.on.rectangle")
                    .foregroundColor(.white)
                    .font(.title)
            })
        )

        .sheet(isPresented: $isShowingPhotoLibrary) {
            ImagePicker(sourceType: .savedPhotosAlbum, selectedImage: $selectedImage)
        }
    }
}
*/

/*struct LogMealFoodDish: Decodable {
    let foodFamily: [String]?
    
    enum CodingKeys: String, CodingKey {
        case foodFamily
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let foodFamilyArray = try? container.decode([String].self, forKey: .foodFamily) {
            foodFamily = foodFamilyArray
        } else {
            let foodFamilyDict = try? container.decode([String: String].self, forKey: .foodFamily)
            foodFamily = foodFamilyDict?.values.sorted()
        }
    }
}
*/

struct LogMealFoodDish: Decodable {
    let id: Int
    let name: String
    let prob: Double
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct FoodWasteView: View {
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var foodName = ""
    @State private var showingFoodAlert = false

    private let logmealAPIURL = "https://api.logmeal.es/v2/image/segmentation/complete"
    private let logmealAPIToken = "109a2a272e2656b5f55c6f25e2d8202c746094a4"

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                HStack {
                    Button("Remove Image") {
                        selectedImage = nil
                        foodName = ""
                    }
                    .padding()

                    Spacer()

                    Button(action: {
                        detectFoodDish()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.green)
                    })
                    .padding()
                }

                if !foodName.isEmpty {
                    Text("Detected food: \(foodName)")
                        .padding()
                }
                
                Spacer()
                
            } else {
                Spacer()
                
                Button("Select Image") {
                    self.isShowingImagePicker = true
                }
                .padding()
                .border(Color.blue, width: 2)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                    if let image = selectedImage {
                        detectFoodDish()
                    }
                }) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
        }
        .navigationTitle("Food Waste")
        .alert(isPresented: $showingFoodAlert) {
            Alert(title: Text("Food Detected"), message: Text("Detected food: \(foodName)"), dismissButton: .default(Text("OK")))
        }
    }

    private func detectFoodDish() {
            guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("Failed to convert image to data")
                return
            }

            let headers = ["Authorization": "Bearer \(logmealAPIToken)"]

            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: logmealAPIURL, headers: HTTPHeaders(headers))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let dict = value as? [String: Any], let foodFamily = dict["foodFamily"] as? [[String: Any]], let firstFood = foodFamily.first, let name = firstFood["name"] as? String {
                        print("Detected food: \(name)")
                        self.foodName = name
                        self.showingFoodAlert = true
                    } else {
                        print("No food detected")
                    }
                case .failure(let error):
                    print("API request failed: \(error)")
                }
            }
        }
}











struct FoodWasteView_Previews: PreviewProvider {
    static var previews: some View {
        FoodWasteView()
    }
}

struct FoodWasteItem: Identifiable {
    let id = UUID()
    let name: String
    let weight: Int
}

/// Food Waste ^^^
///
///


struct NutritionView: View {
    @Binding var nutritionInfo: String

    var body: some View {
        Text(nutritionInfo)
    }
}


struct AboutView: View {
    @State private var foodText: String = ""
    @State private var nutritionInfo: String = ""
    @State private var showingNutrition = false

    var body: some View {
        VStack {
            Text("Nutrition")
                .font(.largeTitle)
                .padding()

            Spacer()

            TextField("Enter food", text: $foodText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()

            Button(action: {
                let headers = [                    "X-RapidAPI-Key": "584781877amsh414a02f15f60592p112f38jsn5f7f037cb5a0",                    "X-RapidAPI-Host": "nutrition-by-api-ninjas.p.rapidapi.com"                ]

                let foodQuery = foodText.replacingOccurrences(of: " ", with: "%20")
                let request = NSMutableURLRequest(url: NSURL(string: "https://nutrition-by-api-ninjas.p.rapidapi.com/v1/nutrition?query=\(foodQuery)")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("error")
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse)
                        nutritionInfo = String(data: data!, encoding: .utf8)!
                        showingNutrition = true
                    }
                })
                dataTask.resume()

            }) {
                Text("Submit")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Food Tracker")
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingNutrition) {
            NutritionView(nutritionInfo: $nutritionInfo)
        }
    }
}




struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

struct FoodView: View {
    @State private var webView = WKWebView()
    var body: some View {
        VStack {
            Spacer()
            Text("Choose a direction:")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            HStack(spacing: 30) {
                Button(action: {
                    if let url = URL(string: "http://menu.hfs.psu.edu/shortmenu.aspx?sName=Penn+State+Housing+and+Food+Services&locationNum=17&locationName=South+Food+District&naFlag=1#middle-content") {
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                       }
                }) {
                    Text("South")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.green)
                )
                
                Button(action: {
                    if let url = URL(string: "http://menu.hfs.psu.edu/shortmenu.aspx?sName=Penn+State+Housing+and+Food+Services&locationNum=11&locationName=East+Food+District&naFlag=1#middle-content"){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("East")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.orange)
                )
                
                Button(action: {
                    if let url = URL(string: "http://menu.hfs.psu.edu/shortmenu.aspx?sName=Penn+State+Housing+and+Food+Services&locationNum=17&locationName=North+Food+District&naFlag=1#middle-content"){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("North")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.blue)
                )
                
                Button(action: {
                    if let url = URL(string: "http://menu.hfs.psu.edu/shortmenu.aspx?sName=Penn+State+Housing+and+Food+Services&locationNum=17&locationName=West+Food+District&naFlag=1#middle-content"){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("West")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.purple)
                )
                
                Button(action: {
                    if let url = URL(string: "http://menu.hfs.psu.edu/shortmenu.aspx?sName=Penn+State+Housing+and+Food+Services&locationNum=17&locationName=pollock+Food+District&naFlag=1#middle-content"){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Text("Pollock")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.red)
                )
            }
            Spacer()
        }
        .background(Color(UIColor(hex: "#C7F6B6")))
        
    }

}



struct ContentView: View {
    @State private var CameraView = false
    @State private var isShowingLogin = false
    ///@State private var isShowingSignup = false
    @State private var selectedImage: UIImage?
    @State private var showingNutrition = false
    @State private var showingImagePicker = false

    

    var body: some View {
            NavigationView {
                VStack {
                    Spacer()
                    Image("HomePage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 300, alignment: .bottom)
                    Spacer()
                    Text("[DATA GRAPH...]")
                            .foregroundColor(.black)
                            .font(.title)
                            .padding(.vertical, 20)
                    Spacer()
                            .frame(height: .infinity)
                        .padding(.horizontal)
                    Spacer()
                        .frame(height: .infinity)
                    ZStack {
                                    
                        Rectangle()
                            .fill(Color(UIColor(hex: "#4169e1")))
                            .frame(height: 60)
                            .cornerRadius(30)
                            .padding(.horizontal)

                        HStack {
                            Spacer()
                           
                            
                            NavigationLink(destination: FoodWasteView()) {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().foregroundColor(Color(UIColor(hex: "#eea47f"))))
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 50)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showingImagePicker) {
                                ImagePicker(selectedImage: $selectedImage)
                            }


                            
                            NavigationLink(destination: AboutView()) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().foregroundColor(Color(UIColor(hex: "#eea47f"))))
                                    .clipShape(Circle())
                            }
                        
                            .padding(.bottom, 20)
                            Spacer()
                            
                            
                            NavigationLink(destination: FoodView()) { // new button
                                Image(systemName: "leaf.arrow.circlepath")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Circle().foregroundColor(Color(UIColor(hex: "#eea47f"))))
                                .clipShape(Circle())
                            }
                        
                            .padding(.bottom, 20)
                            Spacer()
                        } /// Close of HStack
                    }
                    Spacer()
                }
                .navigationBarTitle("")
                            .navigationBarTitleDisplayMode(.inline)
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .accentColor(.white) // add this line
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(UIColor(hex: "#e9ffe9")))
                            .navigationBarTitleDisplayMode(.inline)
                            .ignoresSafeArea()
                            .sheet(isPresented: $isShowingLogin) {
                                LoginView()
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            isShowingLogin = true
                                        }) {
                                            Image(systemName: "person.crop.circle")
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .frame(width: 45, height: 45)
                                                .background(Circle().foregroundColor(Color(UIColor(hex: "#5d453d"))))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                            }

            }
        }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


