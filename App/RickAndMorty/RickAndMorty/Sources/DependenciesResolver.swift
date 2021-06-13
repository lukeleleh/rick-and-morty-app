import CharacterDetail
import CharacterList
import EpisodeDetail
import EpisodeList
import Filters
import LocationDetail
import LocationList
import SwiftUI

struct DependenciesResolver {
    let characterListFactory: CharacterListModuleFactory
    let locationListFactory: LocationListModuleFactory
    let episodeListFactory: EpisodeListModuleFactory

    init() {
        let locationListDependencies = LocationListModuleFactory.Dependencies()
        locationListFactory = LocationListModuleFactory(dependencies: locationListDependencies)
        let episodeListDependencies = EpisodeListModuleFactory.Dependencies()
        episodeListFactory = EpisodeListModuleFactory(dependencies: episodeListDependencies)
        let characterDetailDependencies = CharacterDetailModuleFactory.Dependencies(
            getEpisodeList: episodeListFactory.useCases.getEpisodeList
        )
        let characterDetailFactory = CharacterDetailModuleFactory(dependencies: characterDetailDependencies)
        let characterListDependencies = CharacterListModuleFactory.Dependencies()

        characterListDependencies.configure(
            characterDetail: { character in
                AnyView(characterDetailFactory.make(character: character))
            },
            filters: { selectedFilters, isPresented, completion in
                AnyView(FiltersModuleFactory.make(
                    selectedFilters: selectedFilters,
                    isPresented: isPresented,
                    completion: completion
                ))
            }
        )
        characterListFactory = CharacterListModuleFactory(dependencies: characterListDependencies)
        let episodeDetailDependencies = EpisodeDetailModuleFactory.Dependencies(
            getCharacterList: characterListFactory.useCases.getCharacterList
        )
        let episodeDetailFactory = EpisodeDetailModuleFactory(dependencies: episodeDetailDependencies)
        let locationDetailDependencies = LocationDetailModuleFactory.Dependencies(getCharacterList: characterListFactory.useCases.getCharacterList)
        let locationDetailFactory = LocationDetailModuleFactory(dependencies: locationDetailDependencies)

        locationListDependencies.configure { location -> AnyView in
            AnyView(locationDetailFactory.make(location: location))
        }

        episodeListDependencies.configure { episode -> AnyView in
            AnyView(episodeDetailFactory.make(episode: episode))
        }

        characterDetailDependencies.configure { episode -> AnyView in
            AnyView(episodeDetailFactory.make(episode: episode))
        }

        locationDetailDependencies.configure { character -> AnyView in
            AnyView(characterDetailFactory.make(character: character))
        }

        episodeDetailDependencies.configure { character -> AnyView in
            AnyView(characterDetailFactory.make(character: character))
        }
    }
}
