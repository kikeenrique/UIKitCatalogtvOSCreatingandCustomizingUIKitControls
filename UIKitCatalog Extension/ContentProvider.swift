/*
    Copyright (C) 2017 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    A class that conforms to the `TVTopShelfProvider` protocol. The Top Shelf extension uses this class to query for items to show.
*/

import TVServices

class ContentProvider: TVTopShelfContentProvider {
    override func loadTopShelfContent() async -> TVTopShelfContent? {
        let sections = self.sectionedContent()
        let content = TVTopShelfSectionedContent(sections: sections)
        return content
    }
}

extension ContentProvider {
    // MARK: Convenience

    /**
        An array of `TVTopShelfItem`s to show.

        Each `TVTopShelfItem` in the returned array represents a section of
        `TVTopShelfItem`s on the Top Shelf. e.g.

            - TVTopShelfItem, "Iceland"
                - TVTopShelfItem, "Iceland one"
                - TVContentItem, "Iceland two"

            - TVTopShelfItem, "Lola"
                - TVTopShelfItem, "Lola one"
                - TVTopShelfItem, "Lola two"
    */
    private func sectionedContent() -> [TVTopShelfItemCollection<TVTopShelfSectionedItem>] {
        // Get an array of `DataItem` arrays to show on the Top Shelf.
        let groupedItemsToDisplay = DataItem.sampleItemsForSectionedTopShelfItems
        let sections: [TVTopShelfItemCollection<TVTopShelfSectionedItem>] = groupedItemsToDisplay.map { dataItems in
            /*
                Map the array of `DataItem`s to an array of `TVContentItem`s and
                assign it to the `TVContentItem` that represents the section of
                Top Shelf items.
            */
            let items = dataItems.map { dataItem in
                return contentItemWithDataItem(dataItem, imageShape: .square)
            }
            let section = TVTopShelfItemCollection(items: items)
            let sectionTitle = dataItems.first!.group.rawValue
            section.title = sectionTitle
            return section
        }

        return sections
    }

    private func contentItemWithDataItem(_ dataItem: DataItem, imageShape: TVTopShelfSectionedItem.ImageShape) -> TVTopShelfSectionedItem {
        let contentIdentifier = dataItem.identifier
        let contentItem = TVTopShelfSectionedItem(identifier: contentIdentifier)

        contentItem.title = dataItem.title
        contentItem.playAction = TVTopShelfAction(url: dataItem.displayURL)
        contentItem.setImageURL(dataItem.imageURL,
                                for: [.screenScale1x])
        if dataItem.largeImageURL != nil {
            contentItem.setImageURL(dataItem.largeImageURL,
                                    for: [.screenScale2x])
        }
        contentItem.imageShape = imageShape

        return contentItem
    }

}
