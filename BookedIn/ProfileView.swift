//
//  ProfileView.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 2/3/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI


struct ProfileView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerSheetPresented = false
    @Binding var isCustomerProfile: Bool
    @Binding var isBusinessProfile: Bool
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var profilePhotoURL: String?
    @State private var emailIsVerified = false
    
    let screenSize: CGRect = UIScreen.main.bounds
    let currentUserEmail = Auth.auth().currentUser?.email
    
    
    var body: some View {
        ZStack {
            Color.color.ignoresSafeArea()
            if isCustomerProfile {
                VStack {
                }
                .frame(width: screenSize.width)
                .background(
                    
                    Image("backgroundImage") // Replace "background_image_name" with the name of your image asset
                        .resizable()
                        .frame(width: screenSize.width, height: screenSize.height / 2)
                        .ignoresSafeArea(.all, edges: .top)
                        .opacity(0.7)
                        .padding(.bottom, 400)
                    
                    
                )
                .sheet(isPresented: $isImagePickerSheetPresented){
                    ImagePickerView(selectedImage: $selectedImage)
                }
                
                .onAppear{
                    retrieveCustomerDetails.retrieveCustomerData(){}
                    retrieveImages()
                    emailVerifier()
                }
                
                .ignoresSafeArea(.all, edges: .top)
                
                VStack {
                    ForEach(retrieveCustomerDetails.customerDetails) {details in
                        if currentUserEmail == details.userEmail {
                            
                            Text("\(details.userName)")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accentColor)
                                .font(.system(size: 18))
                                .padding(.top, 45)
                                .shadow(radius: 10)
                            
                            Text("\(details.userLastName)")
                                .font(.system(size: 15))
                                .font(.subheadline)
                                .foregroundStyle(Color.black)
                                .padding(.bottom)
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                Text("YOUR DETAILS")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 11))
                                Spacer()
                            }
                            .padding(.leading, 20)
                            
                            HStack {
                                if emailIsVerified == true {
                                    Image(systemName: "e.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color.accentColor)
                                    
                                }
                                else {
                                    Image(systemName: "e.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.gray)
                                    
                                }
                                Text("\(details.userEmail)")
                                    .padding(.horizontal)
                                Spacer()
                                
                            }
                            .padding(.leading, 20)
                            Lining()
                            
                            HStack {
                                Image(systemName: "phone.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.accentColor)
                                Text("\(details.contactNumber)")
                                    .padding(.horizontal)
                                Spacer()
                            }
                            .padding(.leading, 20)
                            Lining()
                            
                            
                            HStack{
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.accentColor)
                                
                                VStack{
                                    Text("Member Since")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                        .padding(.leading)
                                    Text("\(details.joinedDate)")
                                        .fontWeight(.bold)
                                        .padding(.trailing, 20)
                                    
                                }
                                Spacer()
                                
                            }
                            .padding(.leading, 20)
                            Spacer()
                        }
                        .frame(width: screenSize.width - 20)
                        
                        
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
                .frame(width: screenSize.width)
                .background(
                    Color.color
                )
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .frame(width: screenSize.width)
                .ignoresSafeArea(.all, edges: .bottom)
                .shadow(radius: 20)
                .overlay(
                    VStack{
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .scaledToFill()
                                .padding(.top, 150)
                            
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
                                .padding(.top, 150)
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
                                .padding(.top, 150)
                                .onTapGesture {
                                    isImagePickerSheetPresented = true
                                }
                        }
                        Spacer()
                    }
                        .padding(.bottom, screenSize.height / 1.2)
                )
                .padding(.top, 200)
                Spacer()
            }
            
            
            
    //MARK: BUSINESS PROFILE
            
            else {
                
                
                
                
                
                
                
                
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
    //MARK: THIS FUNCTION VERIFIES IF USER VERIFIED THEIR EMAIL OR NOT
    
    func emailVerifier(){
        
        guard let user = Auth.auth().currentUser else {
            
            return
        }
        if user.isEmailVerified {
            emailIsVerified = true
        }
        else {
            emailIsVerified = false
        }
        
        
    }
    
    
    
    
}


#Preview {
    ProfileView(isCustomerProfile: .constant(true), isBusinessProfile: .constant(false))
}
