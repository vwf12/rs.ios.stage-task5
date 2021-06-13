import Foundation

public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
//        var drinksVar = drinks
//        var foodsVar = foods
//        var inventory = [Item]()
//        var combinations = [[Item]]()
        var itemCombinations = Set<Combination>()
//        var supplyPool = drinks
        let itemsPoolSet: Set<Item> = {
            var iPool = Set<Item>()
            for food in foods {
                let item = Item(food.weight, food.value , .food)
                iPool.insert(item)
            }
            for drink in drinks {
                let item = Item(drink.weight, drink.value, .drink)
                iPool.insert(item)
            }
            return iPool
        }()
        let itemsPool = Array(itemsPoolSet)
        let maxItemsInInventory =  itemsPool.count
        

        for i in 2...maxItemsInInventory {
            let combos = itemsPool.uniqueCombinations(of: i)
            for arraySlice in combos {
                let array:[Item] = Array(arraySlice).uniqued()
                guard let combination = Combination(array) else { continue }
                if combination.totalWeight <= maxWeight {
                itemCombinations.insert(combination)
                }
            }
        }
        
        let filteredItemCombinations = itemCombinations.filter { $0.totalWeight <= maxWeight }

        let sortedItemCombinations  = filteredItemCombinations.sorted(by: { $0.minDistance > $1.minDistance })
        
//        return itemCombinations.map { $0.minDistance }.max()!
        
        let maxDistance: Int? = sortedItemCombinations.first?.minDistance ?? 0

        return maxDistance ?? 0
        }
//        drinksVar.sort {($0.value / $0.weight) > ($1.value / $1.weight)}
//        foodsVar.sort {($0.value / $0.weight) > ($1.value / $1.weight)}
        
//        inventory.append(drinksVar[0])
//        inventory.append(foodsVar[0])
//
//        print(drinksVar)
//        print(foodsVar)
//
        
    }

// MARK: Item type
extension Knapsack {
    enum ItemType {
        case food
        case drink
    }
    
    struct Item: Hashable, Equatable {
        let weight: Int
        let value: Int
        let type: ItemType
        
        init(_ weight: Int, _ value: Int, _ type: ItemType) {
            self.weight = weight
            self.value = value
            self.type = type
        }
    }
}

extension Knapsack {
    struct Combination: Hashable, Equatable {
        var items = [Item]()
        var totalWeight: Int {
            items.reduce(0) { $0 + $1.weight }
        }
        var totalValue: Int {
            items.reduce(0) { $0 + $1.value }
    }
        var minDistance: Int {
            let foodArray = items.filter { $0.type == .food }
            let drinksArray = items.filter { $0.type == .drink }
            let foodDistance = foodArray.reduce(0) { $0 + $1.value }
            let drinkDistance = drinksArray.reduce(0) { $0 + $1.value }
            return min(foodDistance, drinkDistance)
        }
        
        init?(_ items: [Item]) {
            let foodArray = items.filter { $0.type == .food }
            let drinksArray = items.filter { $0.type == .drink }
            let totalWeight = items.reduce(0) { $0 + $1.weight }
            guard foodArray.count > 0 && drinksArray.count > 0 && totalWeight <= 120 else {
                return nil
            }
            self.items = items
        }
        
        init?() {
            return nil
        }
}
}

// MARK: Combination func RangeReplaceableCollection extension

extension RangeReplaceableCollection {
    func combinations(of n: Int) -> [SubSequence] {
        guard n > 0 else { return [.init()] }
        guard let first = first else { return [] }
        return combinations(of: n - 1).map { CollectionOfOne(first) + $0 } + dropFirst().combinations(of: n)
    }
    func uniqueCombinations(of n: Int) -> [SubSequence] {
        guard n > 0 else { return [.init()] }
        guard let first = first else { return [] }
        return dropFirst().uniqueCombinations(of: n - 1).map { CollectionOfOne(first) + $0 } + dropFirst().uniqueCombinations(of: n)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
