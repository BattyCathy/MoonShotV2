//
//  01. Showing Mission Details with ScrollView and GeometryReader.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/3/21.
//

import Foundation

//MARK: Showing Mission Details with ScrollView and GeometryReader

//When the user selects one of the Apollo missions from our main list, we want to show information about the mission: its image, its mission badge, and all the astronauts that were one the crew along with their roles. The first two of those aren't hard, but the second requires more work because we need to match up crew IDs with crew details across our two JSON files.

//Let's start simple and work our way up: make a new SwiftUI file walled MissionView.swift. Initially this will just have a mission property so that we can show the mission badge and description, but shortly we'll add more to it.

//In terms of layout, this thing needs to have a scrolling VStack with a resizable image for the mission badge, then a text view, then a spacer so that everything gets pushed to the top of the screen. We'll use GeometryReader to set the maximum width of the mission image, although through some trial and error I found that the mission badge worked best when it wasn't full width - somehwere between 50% and 75% width looked better, to avoid it becoming weirdly big on the screen.

//Put this code into MissionView.swift now:

/*
 struct MissionView: View {
    let mission: Mission
 
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resixable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
 
                    Text(self.mission.description)
                        .padding()
 
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBatTitle(Text(mission.displayName), displayMode: .inline)
    }
 }
 */

//Did you notice that the spacer was created with minLength: 25? This isn't something we've used before, but it ensures the spacer has a minimum height of at least 25 point. This is helpful insice scroll views because the total available height is flexible: a spacer would normally take up all available remaining space, but that has no meaning inside a scroll view.

//We could have accomplished the same result using Spacer().frame(minHeight: 25), but using Pacer(minLength: 25) has the advantage  that if you ever change your stack orientation - if you go from a VStack to a HStack, for example, then it effectively becomes Spacer().frame(minWidth: 25).

//Anyway, with our new view in place the code will no longer build, all because of the previews struct below it - that thing needs a MIssion object passed in so it has something to render. Fortunately, our Bundle extension is available here as well:

/*
 struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
 
    static var previews: some View {
        MissionView(mission: missions[0])
    }
 }
 */

//If you look in the preview you'll see that's a good start, but the next part is trickier: we want to show the list of astronauts who toook part in the mission below the description. Let's tackle that next...
