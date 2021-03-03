//
//  03. Formatting Our Mission View.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation

//Now that we have all our data in place, we can look at the design for our first screen: a list of all the missions, next to their mission badges.

//The assets we added earlier contain pictures named "apollo1@2x.png" and similar, which means they are accessible in the asset catalot as "apollo1", "apollo12", and so on. Out Mission struct has an id integer providing the number part, so we could use string interpolation such as "apollo/(mission.id)" to get our image name and "Apollo \(mission.id)" to get the formatted display name of the mission.

//Here, though, we're going to take a different approach: we're going to add some computed properties to the Mission struct to sent that same data back. The result will be the same = "apollo1" and "Apollo 1" - but now the code is in one place: our Mission struct. This means any other views can use the same data without having to repeat our string interpolation code, which in turn means if we change the way these things are formatted - i.e., we change the image names to "apollo-1" or something - then we can just change the property in Mission and have all our code update.

//So, please add these two properties to the Mission struct now:

/*
 var displayName: String {
    "Apollo \(id)"
 
 var image: String {
    "apollo\(id)"
 }
 */

//With those two in place we can now take a first pass at filling in ContentView: it will have a NavigationView with a title, a List using our missions array as input, and each row inside there will be a NavigationLink containing the image, name, and aunch date of the mission. The only small complexity in there is that our launch date is an optional string, so we need to use nil coalescing to make sure there's a value for the text view to display.

//Here's the body code for ContentView:

/*
 NavigationView {
    List(missions) { mission in
        NavigationLink(destination: Text("Detail view")) {
            Image(mission.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44)
 
            VStack(alignment: .leading) {
                Text(mission.displayName)
                    .font(.headline)
                Text(mission.launchDate ?? "N/A"
            }
        }
    }
    .navigationBarTitle("Moonshot")
 }
 */

//As you can see, that uses resizable(), aspectRatio(contentMode: .fit), and frame() to make the image occupy a 44x44 space while also maintaining its original aspect ratio. This scenario is so common, SwiftUI actually gives us a small shortcut: rather than using aspectRatio(contentMode: .fit) we can just write scaledToFit() like this:

/*
 Image(mission.image)
    .resizable()
    .scaledToFit()
    .frame(width: 44, height: 44)
 */

//That will automatically cause the image to be scaled down proportionally to fill its container, which in this case is a 44x44 frame.

//Run the program no and you'll see it looks OK, but what about those dates? Although we can look at "1968-12-21" and understand it's the 21st of December 1968, it's still an unnatural date format for almost everyone. We can do better than this!

//Swift's JSONDecoder type has a property caled dateDecodingStrategy, which determines how it should decode dates. We can provide that with a DateFormatter intance that describes how our dates are formatted. In this instance, our dates are written as year-month-day, but things are rarely so simple in the world of dates: is the first month written as "1", "01", "Jan", or "January"? Are the years "1968" or "68"?

//We aready used the dateStyle and timeStyle properties of DateFormatter for using one of the built-in styles, but here we're goingot use its dateformat property to specify a precise format: "y-MM-dd". That's Swift's way of saying "a year, then a dash, then a zero-padded month, then a dash, then a zero-padded day", with "zero-padded" meaning that January is written as "01" rather than "1".

//Warning: Date formats are case sensitive! mm means "zero-padded minute" and MM menas "zero-padded month."

//So, open Bundle-Decodable and add this code directly after let decoder = JSONDecoder():

/*
 let formatter = DateFormatter()
 formatter.dateFormat = "y-MM-dd"
 decoder.dateDecodingStrategy = .formatted(formatter)
 */

//That tells the decoder to parse dates in the exact format we expect. And if you run the code now... things will look exactly the same. Yes, nothing has changed, but that's OK: nothing has changed because Swift doesn't realize that launchDate is a date. After all, we declared it like this:

//let launchDate: String?

//Now that our decoding code understand how our dates are formatted, we can change that property to be an optional Date:

//let launchDate: Date?

//...and now our code won't even compile!

//The problem now is this line of code in ContentView.swift:

//Text(mission.alunchDate ?? "N/A")

//That attempts to use an optional date inside a text view, or replace it with "N/A" if the date is empty. This si another place where a computed property works better: we can ask the mission itself to provide a formatted launch date that converts the optional date into a neatly formatted string or sends back "N/A" for missing dates.

//This uses the same DateFormatter and dateStyle properties we've used previously, so this should be somewhat familiar for you. Add this computed property to Mission now:

/*
 var formattedLaunchDate: String {
    if let launchDate = launchDate {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: launchDate)
    } else {
        return "N/A"
    }
 }
 */

///And now replace the broken text view in ContentView with this:

//Text(mission.formattedLaunchDate)

//With that change our dates will be rendered in a much more natural way, and, even better, will be rendered in whatever way is region-appropriate for the user - what you see isn't nevessarily what I see. 
