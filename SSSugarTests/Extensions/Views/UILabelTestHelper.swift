/*
 Tests for UILabel extension
 
 [Done] nonEmptySizeThatFits(_:)
 [Done] maxSizeThatFits(_:)
 [Done] sizeThatFits(_:withText:)
 */

import Foundation

class UILabelTestHelper {
    enum Text {
        static let empty = ""
        static let space = " "
        static let tab = "    "
        static let word = "word"
        static let sentence = "He has every attribute of a dog except loyalty."
        static let twoLines = "He has every attribute\nof a dog except loyalty."
        static let fiveLines = """
            One, two, Freddy's coming for you
            Three, four, better lock your door
            Five, six, grab your crucifix
            Seven, eight, gonna stay up late
            Nine, ten, never sleep again
            """
        static let eightLines = """
            No stop signs, speed limit
            Nobody's gonna slow me down
            Like a wheel, gonna spin it
            Nobody's gonna mess me around
            Hey Satan, paid my dues
            Playing in a rocking band
            Hey mama, look at me
            I'm on my way to the promised land, whoo!
            """
    }
    
    private enum Size: CGFloat, CaseIterable {
        case negative = -20
        case zero = 0
        case small = 100
        case medium = 200
        case large = 600
        
        var value: CGFloat { rawValue }
        
        fileprivate static func cgSize(width: Size, height: Size) -> CGSize {
            CGSize(width: width.value, height: height.value)
        }
    }
    
    enum LimitSize {
        static let all = sizeCombinations(widths: Size.allCases)
        static let small = sizeCombinations(widths: [.small])
        static let medium = sizeCombinations(widths: [.medium])
        static let exceptSmall = sizeCombinations(widths: [.negative, .zero, .medium, .large])
        static let exceptSmallMedium = sizeCombinations(widths: [.negative, .zero, .large])
        
        private static func sizeCombinations(widths: [Size], heights: [Size] = Size.allCases) -> [CGSize] {
            var sizeArray = [CGSize]()
            
            for width in widths {
                for height in heights {
                    sizeArray.append(Size.cgSize(width: width, height: height))
                }
            }
            return sizeArray
        }
    }
}
