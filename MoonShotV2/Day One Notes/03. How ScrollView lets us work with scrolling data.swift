//
//  03. How ScrollView lets us work with scrolling data.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation

////MARK: How ScrollView Lets Us Work with Scrolling Data

//You've seen how List and Form let us create scrolling tables of data, but for times when we want to scroll arbitrary data - i.e. just some views we've created by hand - we need to turn to SwiftUI's ScrollView.

//Scroll views can scroll horizontally, vertically, or in both directions, and you can also control whether the system should show scroll indicators next to them - those are the little scroll bars that appears to give users a sense of how big the content is. When we place views inside scrolls views, they automatically figure out the size of that content so users can scroll from one edge to the other.

//As an example, we could create a scrolling list of 100 text views like this:

/*
 ScrollView(.vertical) {
    VStack(Spacing: 10) {
        ForEach(0..<100) {
            Text("Item \($0)")
                .font(.title)
        }
    }
 }
 */

 //If you run that back in the simultator you'll see that you can drag the scroll view around freely, and if you scroll to the bottom you'll also see that ScrollView treats the safe area just like List and Form - their content goes under the home indicator, but they add some extra padding so the final views are fully visible.
 
//You might alos notice that it's a bit annoying having to tap directly in the center - it's more common to have the whole area scrollable. To get that behaviour, we should make the VStack take up more space while leaving the default centre alignment intact, like this:

/*
 ScrollView(.vertical) {
    VStack(spacing: 10) {
        ForEach(0..<100) {
            Text("Item \($0)")
                .font(.title)
        }
    }
    .frame(maxWidth: .infinity)
 */


//Now you can tap and drag anywhere on the screen, which is much more user-friendly.

//This all seems really straightforward, and it's true that ScrollView is significantly easier than the older UIScrollView we had to use with UIKit. However, there's an important catch that you need to be aware of: when we add views to a scroll view they get created immediately.

//To demonstrate this, we can create a simple wrapper around a regular text view, like this:

/*
 struct CustomText: View {
    var text: String
 
    var body: some View {
        Text(text)
    }
 
    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
 }
 */

//Now we can use that iside our ForEach:

/*
 ForEach(0..<100) {
    CustomText("Item \($0)")
        .font(.title)
}
 */

//The result will look identical, but now when you run the app you;ll see "Creating a new CustomText" printed a hundred times in Xcode's log - SwiftUI won't wait until you scroll down to see them, it will just create them immediately.

//You can try this same experiment with a List, like this:

/*
 List {
    ForEach(0..<100) {
        CustomText("Item \($0)")
            .font(.title)
    }
 }
 */

//When that code runs, you'll see it acts lazily: it creates instances of CustomText only when really needed. 
