//
//  Homepage.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 05/12/24.
//

import SwiftUI

struct Homepage: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Text("Choose your menu")
                    .font(.title)
                
                VStack(spacing: 16){
                    // 1. search bar
                    HStack{
                        Image(systemName: "magnifyingglass")
                        //                TextField("Search", text: nil) should be from api
                        Text("Search") // currently placeholder for textfield
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // 2. list of menu from API and implement for filtering
                    // should be for each base on how many menu from api and there's on tap doing filtering ('or' logic, and can be select multiple, maybe can using !disjoint for this case) for bottom section content (3)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 80, height: 32)
                                .foregroundColor(.gray.opacity(0.4)) // selected gonna change into this color
                                .overlay{
                                    Text("Indian")
                                        .font(.subheadline.bold())
                                }
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 80, height: 32)
                                .foregroundColor(.white)
                                .overlay{
                                    Text("Chinese")
                                        .font(.subheadline)
                                }
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 80, height: 32)
                                .foregroundColor(.white)
                                .overlay{
                                    Text("Japanese")
                                        .font(.subheadline)
                                }
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 80, height: 32)
                                .foregroundColor(.white)
                                .overlay{
                                    Text("French")
                                        .font(.subheadline)
                                }
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 80, height: 32)
                                .foregroundColor(.white)
                                .overlay{
                                    Text("Moroccan")
                                        .font(.subheadline)
                                }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 3
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            HStack(spacing: 16){
                                Rectangle()
                                    .frame(height: UIScreen.main.bounds.height*0.3)
                                    .foregroundColor(.white)
                                    .overlay{
                                        VStack(spacing: 0){
                                            Rectangle()
                                                .foregroundStyle(.red)
                                                .overlay{
                                                    // gonna from api menu image: strMealThumb, scaletofit, but without padding
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding()
                                                }
                                            
                                            VStack(alignment: .leading, spacing: 4){
                                                // gonna from api menu name: strMeal
                                                Text("Chicken Handi")
                                                    .font(.headline)
                                                RoundedRectangle(cornerRadius: 12)
                                                    .frame(width: 80, height: 32)
                                                    .foregroundColor(.gray.opacity(0.4))
                                                    .overlay{
                                                        // gonna from api Badge menu area: strArea
                                                        Text("Indian")
                                                            .font(.subheadline.bold())
                                                    }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top, 4)
                                            .padding([.horizontal, .bottom], 8)
                                        }
                                    }
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                                Rectangle()
                                    .frame(height: UIScreen.main.bounds.height*0.3)
                                    .foregroundColor(.white)
                                    .overlay{
                                        VStack(spacing: 0){
                                            Rectangle()
                                                .foregroundStyle(.red)
                                                .overlay{
                                                    // gonna from api menu image: strMealThumb, scaletofit, but without padding
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding()
                                                }
                                            
                                            VStack(alignment: .leading, spacing: 4){
                                                // gonna from api menu name: strMeal
                                                Text("Chicken Congee")
                                                    .font(.headline)
                                                RoundedRectangle(cornerRadius: 12)
                                                    .frame(width: 80, height: 32)
                                                    .foregroundColor(.gray.opacity(0.4))
                                                    .overlay{
                                                        // gonna from api Badge menu area: strArea
                                                        Text("Chinese")
                                                            .font(.subheadline.bold())
                                                    }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top, 4)
                                            .padding([.horizontal, .bottom], 8)
                                        }
                                    }
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                                    .onTapGesture{
                                        // change into detail menu
                                    }
                            }
                            HStack(spacing: 16){
                                Rectangle()
                                    .frame(height: UIScreen.main.bounds.height*0.3)
                                    .foregroundColor(.white)
                                    .overlay{
                                        VStack(spacing: 0){
                                            Rectangle()
                                                .foregroundStyle(.red)
                                                .overlay{
                                                    // gonna from api menu image: strMealThumb, scaletofit, but without padding
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding()
                                                }
                                            
                                            VStack(alignment: .leading, spacing: 4){
                                                // gonna from api menu name: strMeal
                                                Text("Chicken Handi")
                                                    .font(.headline)
                                                RoundedRectangle(cornerRadius: 12)
                                                    .frame(width: 80, height: 32)
                                                    .foregroundColor(.gray.opacity(0.4))
                                                    .overlay{
                                                        // gonna from api Badge menu area: strArea
                                                        Text("Indian")
                                                            .font(.subheadline.bold())
                                                    }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.top, 4)
                                            .padding([.horizontal, .bottom], 8)
                                        }
                                    }
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                                Rectangle()
                                    .frame(height: UIScreen.main.bounds.height*0.3)
                                    .foregroundColor(.clear) // if the list of menu odd, maybe can set like this, so the position not change
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .frame(maxHeight:.infinity, alignment:.top)
                .background(.gray.opacity(0.4))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct DetailMenu: View {
    var title: String = "DetailMenu" // placeholder, when parsing from section 3 should be pass tittle (strMeal)
    var photos: Image = Image(systemName: "photo") // placeholder, when parsing from section 3 should be pass image (strMealThumb)
    var menuArea: String = "Area" // placeholder, when parsing from section 3 should be pass area (strArea)
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                VStack(alignment: .leading, spacing: 16){
                    Rectangle()
//                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.red)
                        .overlay{
                            // scaletofit, but without padding
                            photos
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 80, height: 32)
                            .foregroundColor(.gray.opacity(0.4))
                            .overlay{
                                // gonna from api Badge menu area: strArea
                                Text(menuArea)
                                    .font(.subheadline.bold())
                            }
                        ScrollView(.vertical, showsIndicators: false){
                            // gonna be content from API, maybe u can create it as much as u can
                            //example
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Ingredient")
                                        .font(.headline.bold())
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("1.2 kg of chicken")
                                        Text("5 thinly sliced of Onion")
                                        Text("...")
                                    }
                                    .font(.subheadline)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Instructions")
                                        .font(.headline.bold())
                                    Text("""
Take a large pot or wok, big enough to cook all the chicken, and heat the oil in it. Once the oil is hot, add sliced onion and fry them until deep golden brown. Then take them out on a plate and set aside

To the same pot, add the chopped garlic and saute for a minute. Then add the chopped tomators and cook until tomatoes turn soft. This would take about 5 minutes.
...
""")
                                    .font(.subheadline)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Available on the Youtube")
                                        .font(.headline.bold())
                                    // link to strYoutube
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .padding(.top)
                .frame(maxHeight:.infinity, alignment:.top)
                .background(.gray.opacity(0.4))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .navigationTitle(title)
        }
    }
}

#Preview {
    Homepage()
}
