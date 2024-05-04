//
//  Extensions.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseCore
import WeatherKit
import Combine
import MapKit
import CoreLocation


extension View {
    
    func customTextfield() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .foregroundColor(.gray)
            .padding(1)
        
    }
    
    func customText() -> some View {
        self
            .padding(.horizontal)
            .overlay(Rectangle().frame(height: 1))
            .foregroundColor(Color.gray)
        
    }
    
    
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func myImageModifier() -> some View {
        modifier(MyImageFrameModifier())
    }


}


struct MyImageFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .frame(width: 80, height: 80)
        .foregroundColor(Color.accentColor)
        .clipShape(Circle())
        .cornerRadius(40)
        .scaledToFill()
        
        
    }
}

struct Lining : View {
    
    public let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundStyle(Color.secondary)
            .padding(.leading, 50)
    }
}




struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage, presentationMode: presentationMode)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        private let presentationMode: Binding<PresentationMode>
        
        init(selectedImage: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
            _selectedImage = selectedImage
            self.presentationMode = presentationMode
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                return
            }
            self.selectedImage = selectedImage
            presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}




//MARK: FOR WEATHER STATUS
@MainActor
class CurrentWeather: ObservableObject {
    @Published var weatherData : Weather?
    @Published var temp: String = "N/A"
    @Published var symbol: String = "sun"
        
  
    
    func getWeather(latitude: Double, longitude: Double) async {
        do {
            let fetchedWeather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            DispatchQueue.main.async {
                self.weatherData = fetchedWeather
                self.temp = fetchedWeather.currentWeather.temperature.converted(to: .celsius).description
                self.symbol = fetchedWeather.currentWeather.symbolName
            }
        } catch {
            fatalError("\(error)")
        }
    }
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
       @Published var authorizationStatus: CLAuthorizationStatus?
       
       var latitude: Double {
           locationManager.location?.coordinate.latitude ?? 0.0
       }
       var longitude: Double {
           locationManager.location?.coordinate.longitude ?? 0.0
       }
       
       
       override init() {
           super.init()
           locationManager.delegate = self
       }
       
       func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           
           switch manager.authorizationStatus {
               
           case .notDetermined:        // Authorization not determined yet.
               print("You must provide location to run this app properly.")
               authorizationStatus = .notDetermined
               manager.requestWhenInUseAuthorization()
               break
               
           case .authorizedWhenInUse:  // Location services are available.
               print("Updating Location")
               authorizationStatus = .authorizedWhenInUse
               locationManager.requestLocation()
               break
               
               
           case .denied:  // Location services currently unavailable.
               print("Please allow location to locate nearby places.")
               authorizationStatus = .denied
               break
               
           
           default:
               break
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           // Insert code to handle location updates
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error: \(error.localizedDescription)")
       }
       
       
    
    
    
}



struct CustomCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}




