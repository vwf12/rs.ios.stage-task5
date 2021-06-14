import Foundation

class StockMaximize {
    
    var maxPriceIndex = 0
    var pricesVariable = [Int]()
    var profit = 0
    var currentPortfolio = [Int]()
    
    func countProfit(prices: [Int]) -> Int {
        pricesVariable = prices
        guard prices.count > 1 else { return 0 }
        
        while pricesVariable.count > 1 {
            calculateProfit(pricesVariable: &pricesVariable)
        }
        return profit
        }
        
    func calculateProfit(pricesVariable: inout [Int]) {
        guard var maxValue = pricesVariable.first else { return }
        for (index, value) in pricesVariable.enumerated() {
            if value > maxValue {
                        maxValue = value
                        maxPriceIndex = index
                     }
        }
        guard maxPriceIndex != 0 else {
            pricesVariable.removeFirst()
            return
        }
            for i in 0..<maxPriceIndex {
                currentPortfolio.append(pricesVariable[i])
                profit -= pricesVariable[i]
            }
            profit += currentPortfolio.count * pricesVariable[maxPriceIndex]
            pricesVariable.removeFirst(maxPriceIndex + 1)
            maxPriceIndex = 0
            currentPortfolio = []
    }
        
        
}
