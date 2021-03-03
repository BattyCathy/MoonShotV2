//
//  04. Pushing New Views Onto the Stack Using NavigationLink.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation


//MARK: 04. Pushing New Views Onto The Stack Using NavigationLink

//SwiftUI's NavigationView shows a navigation bar at the top of our views, but also does something else: it lets us push views onto a view stack. In fact, this is really the most fundamental form of iOS navigation - you can see it in Settings when you tap Wifi of General, or in Messages whenver you tap someone's name.

//This view stack system is very different from the sheets we've used preivously. Yes, both show some sort of new view, but there's a difference in the way they are presented that affects the ways users think about them.

//Let's start by looking at some code so you can see for yourself. If we wrap the default text ciew sith a navigation view and give it a title, we get this:

/*
 struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
            }
            .navigationBarTitle("SwiftUI")
        }
    }
 }
 */

//That text view is just a static text; it's not a button with any sort of action attached to it. We're going to make it so that when the user taps on "Hello World" we present them with a new view, and that's done using NavigationLink: give this a destination and something that can be tapped, and it will take care of the rest. One of the many things I love about SwiftUI is that we can use NavigationLink with any kin of destination view. Yes, we can design a view to push to, but we can also push stright to some text. To try this out, change your view to this:

/*
 NavigationView {
    VStack {
        NavigationLink(destination: Text("Detail View")) {
            Text("Hello World")
        }
    }
    .navigationBarTitle("SwiftUI")
 }
 */

//Now run that code and see what you think. You will see that "Hello World" now looks like a button, and tapping it makes a new view slide in from the right saying "Detail View". Even better, you'll see that the "SwiftUI" title animates down to become aback button, and you can tap that or sweipe from the left edge to go back.

//So, both sheet() and NAvigationLink allow us to show a new view from the current one, but the way they do it is a different and you shouold choose them carefully:

//--NavigationLink is for showing details about the user's selection, like you're diggin deeper into a topic.

//--sheet() is for showing unrelated content, such as settings or a compose window.

//The most common place you see NavigationLink is with a list, and there SwiftUI does something quite marvelous.

//Try modifying your code to this:

/*
 NavigationView {
    List(0..<100) { row in
        NavigationLink(destination: Text("Detail \(row)")) {
            Text("Row \(row)")
        }
    }
    .navigtionBarTitle("SwiftUI")
 }
 */


//When you run the app now you'll see 100 list rows that can be tapped to show a detail view, but you'll also see gray disclosure indicators on the right edge. This is the standard iOS way of telling users another screen is going to slide in from the right when the row is tappped, and SwiftUI is smart enough to add it automatically here. If those rows weren't navigation links - if you comment out the NAvigationLink line and its closing brace. You'll see the indicators disappear. 
