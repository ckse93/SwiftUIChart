//
//  ContentView.swift
//  halfModalPractice
//
//  Created by Chan Jung on 6/7/22.
//

import SwiftUI
import Charts

struct Car: Identifiable {
    var id = UUID()
    var name: Brand
    var salesNumber: Int {
        var total = 0
        for qt in quarterSales {
            total += qt.salePerQuarter
        }
        return total
    }
    var isDomestic: Bool
    var color: Color
    var quarterSales: [QuarterSale]
}

struct QuarterSale: Identifiable {
    var id = UUID()
    var quarter: String
    var salePerQuarter: Int
}

let sales: [Car] = [
    .init(name: .LandRover, isDomestic: false, color: .orange ,quarterSales: [
        .init(quarter: "1", salePerQuarter: 800),
        .init(quarter: "2", salePerQuarter: 670),
        .init(quarter: "3", salePerQuarter: 880),
        .init(quarter: "4", salePerQuarter: 6102),
    ]),
    .init(name: .Jeep, isDomestic: true, color: .green, quarterSales: [
        .init(quarter: "1", salePerQuarter: 507),
        .init(quarter: "2", salePerQuarter: 3670),
        .init(quarter: "3", salePerQuarter: 2880),
        .init(quarter: "4", salePerQuarter: 9092),
    ]),
    .init(name: .Kia, isDomestic: false, color: .blue, quarterSales: [
        .init(quarter: "1", salePerQuarter: 100),
        .init(quarter: "2", salePerQuarter: 2167),
        .init(quarter: "3", salePerQuarter: 4880),
        .init(quarter: "4", salePerQuarter: 1092),
    ]),
    .init(name: .Hyundai, isDomestic: false, color: .red, quarterSales: [
        .init(quarter: "1", salePerQuarter: 3100),
        .init(quarter: "2", salePerQuarter: 670),
        .init(quarter: "3", salePerQuarter: 2080),
        .init(quarter: "4", salePerQuarter: 1492),
    ]),
    .init(name: .Toyota, isDomestic: false, color: .teal, quarterSales: [
        .init(quarter: "1", salePerQuarter: 1790),
        .init(quarter: "2", salePerQuarter: 2970),
        .init(quarter: "3", salePerQuarter: 880),
        .init(quarter: "4", salePerQuarter: 7102),
    ]),
    .init(name: .Honda, isDomestic: false, color: .indigo, quarterSales: [
        .init(quarter: "1", salePerQuarter: 1900),
        .init(quarter: "2", salePerQuarter: 1670),
        .init(quarter: "3", salePerQuarter: 1880),
        .init(quarter: "4", salePerQuarter: 1092),
    ]),
    .init(name: .Acura, isDomestic: false, color: .pink, quarterSales: [
        .init(quarter: "1", salePerQuarter: 1210),
        .init(quarter: "2", salePerQuarter: 2670),
        .init(quarter: "3", salePerQuarter: 1880),
        .init(quarter: "4", salePerQuarter: 1092),
    ]),
    .init(name: .Ford, isDomestic: true, color: .mint, quarterSales: [
        .init(quarter: "1", salePerQuarter: 4100),
        .init(quarter: "2", salePerQuarter: 1670),
        .init(quarter: "3", salePerQuarter: 1880),
        .init(quarter: "4", salePerQuarter: 1092),
    ]),
    .init(name: .Tesla, isDomestic: true, color: .purple, quarterSales: [
        .init(quarter: "1", salePerQuarter: 5100),
        .init(quarter: "2", salePerQuarter: 8670),
        .init(quarter: "3", salePerQuarter: 1880),
        .init(quarter: "4", salePerQuarter: 1092),
    ]),
    .init(name: .Dodge, isDomestic: true, color: .black, quarterSales: [
        .init(quarter: "1", salePerQuarter: 1000),
        .init(quarter: "2", salePerQuarter: 1600),
        .init(quarter: "3", salePerQuarter: 2880),
        .init(quarter: "4", salePerQuarter: 3092),
    ]),
    .init(name: .Ram, isDomestic: true, color: .gray, quarterSales: [
        .init(quarter: "1", salePerQuarter: 1000),
        .init(quarter: "2", salePerQuarter: 670),
        .init(quarter: "3", salePerQuarter: 2880),
        .init(quarter: "4", salePerQuarter: 5092),
    ])
]

enum ShowWhat {
    case all
    case domestic
    case imported
}

enum Brand: String, CaseIterable {
    case LandRover = "Land Rover"
    case Jeep = "Jeep"
    case Kia = "Kia"
    case Hyundai = "Hyundai"
    case Toyota = "Toyota"
    case Honda = "Honda"
    case Acura = "Acura"
    case Ford = "Ford"
    case Tesla = "Tesla"
    case Dodge = "Dodge"
    case Ram = "Ram"
}

struct ContentView: View {
    @State var showModal: Bool = false
    @State var showWhat: ShowWhat = .all
    @State var whatBrand: Brand = .Jeep
    @State var range: (String, String)?
    
    var data: [Car] {
        switch showWhat {
        case .all:
            return sales
        case .domestic:
            return sales.filter { $0.isDomestic == true }
        case .imported:
            return sales.filter { $0.isDomestic == false }
        }
    }
    
    var singleBrandData: Car {
        return sales.filter { $0.name == whatBrand }.first!
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Chart {
                    ForEach(data) { sale in
                        BarMark(x: .value("Brand Name", sale.name.rawValue),
                                yStart: .value("", 0),
                                yEnd: .value("Sales", sale.salesNumber),
                                width: .ratio(0.6))
                        .annotation {
                            Text("\(sale.salesNumber)")
                                .font(.footnote)
                        }
                        .accessibilityValue("\(sale.name.rawValue) has sold \(sale.salesNumber) cars")
                        .foregroundStyle(sale.isDomestic ? Color.green.gradient : Color.blue.gradient)
                    }
                }
                .frame(height: UIScreen.main.bounds.width * 0.7)
                Button {
                    self.showModal = true
                } label: {
                    Text("show half modal filter")
                }
                
                SalesComparisonChart()
                    .frame(height: UIScreen.main.bounds.width)
                
                HStack {
                    Text("quarter sale data for \(whatBrand.rawValue)")
                    
                    Picker("brand selection", selection: $whatBrand) {
                        ForEach(Brand.allCases, id: \.self) { brand in
                            Text("\(brand.rawValue)")
                                .tag(brand)
                        }
                    }
                }
                
                Chart {
                    ForEach(singleBrandData.quarterSales) { quarterSale in
                        LineMark(x: .value("Brand Name", quarterSale.quarter),
                                y: .value("Quarter Sales", quarterSale.salePerQuarter))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(singleBrandData.color)
                        
                        PointMark(x: .value("Brand Name", quarterSale.quarter),
                                  y: .value("Quarter Sales", quarterSale.salePerQuarter))
                            .annotation(content: {
                                Text("\(quarterSale.salePerQuarter)")
                                    .font(.footnote)
                            })
                            .foregroundStyle(singleBrandData.color)
                    }
                }
                .frame(height: UIScreen.main.bounds.width * 0.7)
                
                Spacer()
                
            }
        }
        .sheet(isPresented: $showModal) {
            HalfModalView(isPresented: $showModal, showWhat: $showWhat)
                .presentationDetents([.height(200), .medium, .large])
                .presentationDragIndicator(.hidden)
        }
    }
}

struct HalfModalView: View {
    @Binding var show: Bool
    @Binding var showWhat: ShowWhat
    
    init(isPresented: Binding<Bool>, showWhat: Binding<ShowWhat>) {
        self._show = isPresented
        self._showWhat = showWhat
    }
    
    var body: some View {
        VStack {
            Button {
                self.show = false
            } label: {
                Text("Dismiss")
                    .padding()
            }
            
            Picker("Selection", selection: $showWhat.animation(.easeInOut(duration: 0.5))) {
                Text("Show All").tag(ShowWhat.all)
                Text("Show Domestic").tag(ShowWhat.domestic)
                Text("Show Importes").tag(ShowWhat.imported)
            }
            .pickerStyle(.segmented)

            Spacer()
        }
        .padding(.top)
    }
}

struct SalesComparisonChart: View {
    @State var whatBrands: [Brand] = [.Jeep, .Tesla, .Toyota]
    
    var comparedBrandData: [Car] {
        return sales.filter { whatBrands.contains($0.name) }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        self.whatBrands.append(.Hyundai)
                    }
                } label: {
                    Text("Add Hyundai")
                }
                
                Button {
                    withAnimation {
                        self.whatBrands = self.whatBrands.filter{ $0 != .Tesla }
                    }
                } label: {
                    Text("Remove Tesla")
                }
            }
            
            Chart {
                ForEach(comparedBrandData) { brand in
                    ForEach(brand.quarterSales) { quarterSale in
                        LineMark(x: .value("Brand Name", quarterSale.quarter),
                                y: .value("Quarter Sales", quarterSale.salePerQuarter))
                        .symbol(Circle())
                        
                    }
                    .foregroundStyle(by: .value("", brand.name.rawValue))
                }
            }
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
