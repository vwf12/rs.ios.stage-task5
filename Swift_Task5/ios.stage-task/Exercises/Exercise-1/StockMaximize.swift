import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        guard prices.count > 1 else { return 0 }
        
        var pricesVariable = prices
        var profit = 0

        var currentPortfolio = [Int]()
        var maxPriceIndex = 0
        
        while pricesVariable.count > 1 {
            calculateProfit(pricesVariable: &pricesVariable)
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
        
        return profit
        }
        

        
        
}
