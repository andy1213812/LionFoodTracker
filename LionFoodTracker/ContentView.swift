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
                .background(Color(UIColor(hex: "#fffff")))
                .cornerRadius(5.0)
                .padding(.top, 30)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(UIColor(hex: "#fffff")))
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
struct ImagePicker: UIViewControllerRepresentable {
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

///-----------------------Menu View-----------------------


///-----------------------Camera View-----------------------



struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

/// Food Waste --------------

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

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Our Purpose")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("Our team is dedicated to reducing food waste in order to promote a more sustainable future. We believe that everyone can do their part to make a positive impact on the environment, and we're committed to making it easy and accessible for everyone to do so.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
            Text("Team Members: ")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Text("Andy Chen, Minseo Kim, Ling Qiu, PeiDong liu, Jude Bislig, Britney Wang")
                .multilineTextAlignment(.center)
        
            
            Spacer()
        }
        .navigationBarTitle("About")
        .background(Color(UIColor(hex: "#C7F6B6")))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

struct FoodView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Choose a direction:")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            HStack(spacing: 30) {
                Link(destination: URL(string: "http://menu.hfs.psu.edu/shortmenu.aspx?sName=Penn+State+Housing+and+Food+Services&locationNum=17&locationName=South+Food+District&naFlag=1#middle-content")!) {
                    Button(action: {
                        // Handle South button action here
                    }) {
                        Text("South")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.green)
                )
                
                Button(action: {
                    // Handle East button action here
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
                    // Handle North button action here
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
                    // Handle West button action here
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
                    // Handle Pollock button action here
                }) {
                    Text("p o l  l o ck")
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
    

    var body: some View {
            NavigationView {
                VStack {
                    Spacer()
                    Image("HomePage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 300, alignment: .bottom)
                    Spacer()
    
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
                            Button(action: {
                                CameraView = true
                            }) {
                                Image(systemName: "camera")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().foregroundColor(Color(UIColor(hex: "#eea47f"))))
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 30)
                
                            .padding(.bottom, 20)
                            .sheet(isPresented: $CameraView) {
                                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                            }
    
                            NavigationLink(destination: FoodWasteView()) {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().foregroundColor(Color(UIColor(hex: "#eea47f"))))
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 30)
                
                            .padding(.bottom, 20)
                            NavigationLink(destination: AboutView()) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Circle().foregroundColor(Color(UIColor(hex: "#eea47f"))))
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom, 20)
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
                .navigationBarTitle("LionFoodTracker")
                            .navigationBarTitleDisplayMode(.inline)
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(UIColor(hex: "#C7F6B6")))
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

