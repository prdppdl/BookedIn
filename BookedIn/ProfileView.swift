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
    @State private var selectedCoverImage: UIImage?
    @State private var isImagePickerSheetPresented = false
    @State private var isImagePickerSheetPresentedCover = false
    @Binding var isCustomerProfile: Bool
    @Binding var isBusinessProfile: Bool
    @State private var retrieveCustomerDetails = RetrievingCustomerDetails()
    @State private var retrieveBusinessDetails = RetrievingBusinessDetails()
    @State private var profilePhotoURL: String?
    @State private var coverPhotoURL: String?
    @State private var emailIsVerified = false
    
    let screenSize: CGRect = UIScreen.main.bounds
    let currentUserEmail = Auth.auth().currentUser?.email
    
    
    var body: some View {
        if isCustomerProfile {
            ZStack {
                Color.color.ignoresSafeArea()
                
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
                                    .foregroundStyle(Color.black)
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
                                    .foregroundStyle(Color.black)
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
                                        .foregroundStyle(Color.black)
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
            .navigationBarItems(leading: CustomBackButton())
            .navigationBarBackButtonHidden()
            
        }
        
        //
        //
        //
        //
        //
        //
        //MARK: BUSINESS PROFILE
        
        else {
            ZStack {
                VStack{
                    if let image = selectedCoverImage {
                        Image(uiImage: image)
                            .resizable()
                            .ignoresSafeArea(.all, edges: .top)
                            .frame(width: screenSize.width, height: screenSize.height / 3.5)
                            .overlay {
                                HStack {
                                    Spacer ()
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .bold()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.accentColor)
                                        .onTapGesture {
                                            isImagePickerSheetPresentedCover = true
                                        }
                                    
                                }
                                .offset(x: 5, y: 50)
                                .padding(.trailing, 20)
                            }
                    }
                    else if let urlimage = coverPhotoURL {
                        WebImage(url: URL(string: urlimage))
                            .resizable()
                            .ignoresSafeArea(.all, edges: .top)
                            .frame(width: screenSize.width, height: screenSize.height / 3.5)
                            .overlay {
                                HStack {
                                    Spacer ()
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .bold()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.accentColor)
                                        .onTapGesture {
                                            isImagePickerSheetPresentedCover = true
                                        }
                                    
                                }
                                .offset(x: 5, y: 50)
                                .padding(.trailing, 20)
                            }
                    }
                
                    else {
                        Image("backgroundImageBusiness")
                            .resizable()
                            .ignoresSafeArea(.all, edges: .top)
                            .frame(width: screenSize.width, height: screenSize.height / 3.5)
                            .overlay {
                                HStack {
                                    Spacer ()
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .bold()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.accentColor)
                                        .onTapGesture {
                                            isImagePickerSheetPresentedCover = true
                                        }
                                    
                                }
                                .offset(x: 5, y: 50)
                                .padding(.trailing, 20)
                            }
                    }
                    Spacer()
                    
                }
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color.color)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .padding(.top, screenSize.height / 4.5)
                
                
                
                VStack{
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                            .onTapGesture {
                                print("Tapped")
                                isImagePickerSheetPresented = true
                            }
                    }
                    else if let urlimage = profilePhotoURL {
                        WebImage(url: URL(string: urlimage))
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .scaledToFill()
                            .onTapGesture {
                                print("Tapped")
                                isImagePickerSheetPresented = true
                            }
                    }
                    
                    else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .myImageModifier()
                            .onTapGesture {
                                print("Tapped")
                                isImagePickerSheetPresented = true
                            }
                            .onAppear{
                                retrieveImages()
                                retrieveCoverImages()
                                retrieveBusinessDetails.retrieveBusinessData() {}
                            }
                        
                    }
                    
                    
                    
                    ForEach(retrieveBusinessDetails.businessDetails) { details in
                        
                        
                        Text("\(details.businessName)")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                            .font(.system(size: 18))
                            .shadow(radius: 10)
                        
                        HStack {
                            Text("YOUR DETAILS")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .font(.system(size: 11))
                                .padding(.vertical, 12)
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
                            Text("\(details.businessEmail)")
                                .foregroundStyle(.black)
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
                            Text("\(details.businessContactNumber)")
                                .foregroundStyle(.black)
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
                            Text("\(details.businessAddress)")
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .padding(.leading, 20)
                        Lining()
                        
                        
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.accentColor)
                            Text("\(details.businessABN)")
                                .foregroundStyle(.black)
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
                                    .foregroundStyle(.black)
                                    .padding(.leading, 20)
                                
                            }
                            Spacer()
                            
                        }
                        .padding(.leading, 20)
                    }
                    Spacer()
                    if selectedImage != nil || selectedCoverImage != nil {
                        
                        Button(action: {
                            
                            if selectedImage != nil {
                                uploadImageToFirebaseStorage(image: selectedImage!) { result in
                                    switch result {
                                    case .success(let url):
                                        print("Image uploaded successfully at \(url.absoluteString)")
                                        
                                    case .failure(let error):
                                        print("Failed to upload image \(error.localizedDescription)")
                                    }
                                    
                                }
                            }
                            else {
                                uploadImageToFirebaseStorage(image: selectedCoverImage!) { result in
                                    switch result {
                                    case .success(let url):
                                        print("Image uploaded successfully at \(url.absoluteString)")
                                        
                                    case .failure(let error):
                                        print("Failed to upload image \(error.localizedDescription)")
                                    }
                                    
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
                        .padding(.top, 50)
                    }
                }
                
                .sheet(isPresented: $isImagePickerSheetPresented){
                    
                    ImagePickerView(selectedImage: $selectedImage)
                }
                .sheet(isPresented: $isImagePickerSheetPresentedCover){
                    
                    ImagePickerView(selectedImage: $selectedCoverImage)
                }
                .frame(width: screenSize.width, height: screenSize.height / 2)
                
            }
            
        }
        
        
        
    }
    
    
    
    //MARK: THIS FUNCTION IS TO UPLOAD IMAGE TO FIREBASE
    
    public func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        if selectedImage != nil {
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
        
        
        //UPLOADING COVER PHOTO
        
        else {
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])))
                return
            }
            // let uid = Auth.auth().currentUser?.uid
            let email = Auth.auth().currentUser?.email
            let path = "Cover Picture/coverpicture.jpg"
            
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
    
    public func retrieveCoverImages() {
        
        Storage.storage().reference().child("Images/\(String(describing: currentUserEmail))/Cover Picture/coverpicture.jpg").downloadURL { (url, error) in
            if error != nil {
                
                
                
                return
            }
            coverPhotoURL = url?.absoluteString
        
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
    ProfileView(isCustomerProfile: .constant(false), isBusinessProfile: .constant(true))
}
