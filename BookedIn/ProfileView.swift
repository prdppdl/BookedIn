//
//  ProfileView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 2/3/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
import SDWebImageSwiftUI


struct ProfileView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerSheetPresented = false
    @Binding var isCustomerProfile: Bool
    @Binding var isBusinessProfile: Bool
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    let currentUserEmail = Auth.auth().currentUser?.email
    public let screenSize: CGRect = UIScreen.main.bounds
    @State var profilePhotoURL: String?
    
    
    var body: some View {
        ZStack {
            if isCustomerProfile == true {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .scaledToFill()
                            .padding(.top, 180)
                            
                            .onTapGesture {
                                isImagePickerSheetPresented = true
                            }
                    }
                    
                    else if let urlimage = profilePhotoURL {
                        WebImage(url: URL(string: urlimage))
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .scaledToFill()
                            .padding(.top, 180)
                            .onTapGesture {
                                isImagePickerSheetPresented = true
                            }
                    }
                    
                    else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .scaledToFill()
                            .padding(.top, 180)
                            .onTapGesture {
                                isImagePickerSheetPresented = true
                            }
                    }
                    Spacer()
                }
                .frame(width: screenSize.width)
                .background(Color.accentColor)
                .sheet(isPresented: $isImagePickerSheetPresented){
                    ImagePickerView(selectedImage: $selectedImage)
                }
                
                .onAppear{
                    retrieveCustomerDetails.retrieveCustomerData(){}
                    retrieveImages()
                }
               
                .ignoresSafeArea(.all, edges: .top)
           
                VStack {
                    
                    ForEach(retrieveCustomerDetails.customerDetails) {details in
                        if currentUserEmail == details.userEmail {
                            
                            Text("\(details.userName)")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accentColor)
                                .font(.system(size: 18))
                                .shadow(radius: 10)
                            Text("\(details.userLastName)")
                                .font(.system(size: 15))
                                .font(.subheadline)
                                .foregroundStyle(Color.black)
                                .padding(.bottom)
                            Spacer()
                        }
                    }
                    
                    
                    if selectedImage != nil {
                        
                        Button(action: {
                            
                            uploadImageToFirebaseStorage(image: selectedImage!) { result in
                                switch result {
                                case .success(let url):
                                    print("Image uploaded successfully at \(url.absoluteString)")
                                    
                                case .failure(let error):
                                    print("Failed to upload image \(error.localizedDescription)")
                                }
                                
                            }
                            
                        }) {
                            Text("Save")
                                .fontWeight(.semibold)
                                .frame(width: 320,height: 25)
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                            
                        }
                        .background(Color.accentColor)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(5)
                        .padding(.bottom, 15)
                    }
                }
                .scaledToFill()
                .frame(width: screenSize.width)
                .background(Color.color)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .shadow(radius: 20)
                .padding(.top, 180)
                .ignoresSafeArea(.all, edges: .bottom)
                
                
                
            }
            
            else {
                
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: screenSize.width, height: screenSize.height / 3)
                        .scaledToFit()
                    Spacer()
                    
                    
                }
                .onAppear{
                    retrieveBusinessDetails.retrieveBusinessData(){}
                    retrieveImages()
                }
                .ignoresSafeArea(.all, edges: .top)
                
                VStack {
                    ForEach(retrieveBusinessDetails.businessDetails) {details in
                        if currentUserEmail == details.businessEmail {
                            Text("\(details.businessName)")
                                .fontWeight(.semibold)
                                .font(.system(size: 15))
                                .foregroundStyle(.accent)
                                .shadow(radius: 10)
                            
                        }
                    }
                    Spacer()
                }
                .scaledToFill()
                .frame(width: screenSize.width)
                .background(Color.color)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .shadow(radius: 20)
                .padding(.top, 180)
                .ignoresSafeArea(.all, edges: .bottom)
                
               
                
                
                
            }
          
            
         
            
        }
        .navigationBarItems(leading: CustomBackButton())
        .navigationBarBackButtonHidden()
    }
    
    
    
    //MARK: THIS FUNCTION IS TO UPLOAD IMAGE TO FIREBASE
    
    public func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])))
            return
        }
        // let uid = Auth.auth().currentUser?.uid
        let email = Auth.auth().currentUser?.email
        let path = "Profile Picture/profilepicture.jpg"
        
        let storageRef = Storage.storage().reference().child("Images/\(String(describing: email))/\(path)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
            
        }
    }

    
    
    
    
    //MARK: THIS FUNCTION IS TO RETRIEVE IMAGE FROM DATABASE
    
   public func retrieveImages() {
       Storage.storage().reference().child("Images/\(String(describing: currentUserEmail))/Profile Picture/profilepicture.jpg").downloadURL { (url, error) in
            if error != nil {
                
             
                
                return
            }
            profilePhotoURL = url?.absoluteString
        }
    }
}

