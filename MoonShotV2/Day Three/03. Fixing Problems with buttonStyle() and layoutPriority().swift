//
//  03. Fixing Problems with buttonStyle() and layoutPriority().swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/3/21.
//

import Foundation


//MARK: Fixing problems with buttonStyle() and layoutPriority()

//To finish this program we're going to make a third and final view to display astronaut details, which will be reached by tapping one of the astronauts in the mission view. This should mostly just be practice for you, but I do want to highlight an interesting quirk and how it cn be resolved with a new modifier called layoutPriority().

//Start by making a new SwiftUI view called AstronautView. This will have a single astronaur property so it knows what to show, then it will lay that out using a similar GeometryReader/ScrollView/VStack combination we had in MissionView. Git it this code:

/*
 struct AstronautView: View {
    let astronaut: Astronaut
 
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
 
                    Text(self.astronaut.description)
                        .padding()
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
 }
 */

//Once again we need to update the preview so that it creates its view with some data:

/*
 struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
 
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
 }
 */

//Now we can present that from MissionView using another NavigationLink. This needs to go just inside the ForEach so that it wraps the existing HStack:

/*
 NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
    HStack {
        //current code
    }
    .padding(.horizontal)
 }
 */

//Run the app now and give it a thorough try - you should see at least one bug and perhaps two depending on SwiftUI.

//The first bug is pretty glaring: in the mission view, all our astronaut picture are shown as solid blue capsules rather than thier picture. You might also notice that each person's name is written in the same shade of blue, which might give you a clude what's going on - now that this is a navigation link, SwiftUI is making the whole thing look active by coloring our views blue.

//To fix this we need to ask SwiftUI to render the contents of the navigation link as a plain button, which means it won't apply coloring to the image or text. So, add this as a modifier to the astronaut NavigationLink in MissionView:

//.buttonStyle(PlainButtonStyle())

//As for the second bug, it's possible you didn't even see it at all - this seems to me a bug in SwiftUI itself, and so it either might be fixed in a future release or it's possible that it only affects specific defive configurations. So, if this bug doesn't exist for you when using the same iPhone simulator as me it's possible it's been resolved.

//The bug is this: if you select certain astronauts, such as Edward H. White II from Apollo 11, you might see their description text gets clipped at the bottom. So, rather than seeing all the text, you instead see just some, followed by an ellipsis where the rest should be. And if you look closely at the top of the image, you'll notice it's no linger sitting directly against the navigation bar at the top.

//What we're seeing is SwiftUI's layout algorithm having a hard time coming to the right conclusion about our content. In my view this is a SwiftUI bug, and it's possible that by the time you try this yourself it won't even exist. But it exist right here, so I'm going to show you how we can fix it by using the layoutPriority() modifier.

//Layout priority lets us control how readily a view shrinks when space is limited, or expands when space is plentiful. All views have a layout priority of 0 by default, which means they each get equal chance to grow or shrink. We're going to give our astronaut decription a layout priority of 1, which is higher than the image's 0, which means it will automatically take up all available space.

//To do this, just add layoutPriority(1) to the description text view in AstronautView, like this:

/*
 Text(self.astronaut.description)
    .padding()
    .layoutPriority(1)
 */

//With those two bugs fixed our program is done - run it one last time and try it out!
