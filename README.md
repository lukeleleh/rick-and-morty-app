# Rick and Morty

A simple app using the [Rick and Morty API](https://rickandmortyapi.com) written in SwiftUI to display the characters, locations and episodes from the [show](https://en.wikipedia.org/wiki/Rick_and_Morty):

Characters list           |  Character detail  |  Location detail  |  Episode detail
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img alt="Characters list" src="Screenshots/characters_list.png">|<img alt="Character detail" src="Screenshots/character_detail.png">|<img alt="Location detail" src="Screenshots/location_detail.png">|<img alt="Episode detail" src="Screenshots/episode_detail.png">


The app is built using the MVVM architecture with clean architecture, presenting the following key features:
- Usage of async/await
- Decoupled presentation, domain and data layers
- All the features/screens are created inside their corresponding module using SPM (Swift Package Manager)
- Light and dark themes

## Requirements

- iOS 16.0+ (Swift 5.7)
- Xcode 14.1

## Usage
1. Clone the repo
2. Open the workspace file `RickAndMorty.xcodeproj` and run the app

## Author
Luka Hristic

luka.hristic.dev@gmail.com

## License
MIT License

Copyright (c) 2021 Luka Hristic

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
