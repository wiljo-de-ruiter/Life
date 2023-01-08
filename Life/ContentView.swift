//
//  ContentView.swift
//  Life
//
//  Created by Wiljo de Ruiter on 2023-01-08.
//

import SwiftUI

struct Row
{
    var cols: Int
    var cell: [Bool]
    
    init( cols: Int )
    {
        self.cols = cols
        cell = Array( repeating: false, count: cols )
    }
}

struct Playfield
{
    let rows: Int
    let cols: Int
    
    var data: [Row]
    
    init( rows: Int, cols: Int )
    {
        self.rows = rows
        self.cols = cols
        data = Array(repeating: Row(cols: cols), count: rows)
        addVipers()
    }
    
    func cell( row: Int, col: Int ) -> Bool
    {
        data[ row ].cell[ col ]
    }
    
    mutating func setCell( row: Int, col: Int, _ val: Bool )
    {
        data[ row ].cell[ col ] = val
    }
    
    func leftOf( _ col: Int ) -> Int
    {
        ( col + cols - 1 ) % cols
    }
    
    func rightOf( _ col: Int ) -> Int
    {
        ( col + 1 ) % cols
    }
    
    func above( _ row: Int ) -> Int
    {
        ( row + rows - 1 ) % rows
    }
    
    func under( _ row: Int ) -> Int
    {
        ( row + 1 ) % rows
    }
    
    mutating func addVipers()
    {
        setCell( row: 0, col: 1, true )
        setCell( row: 1, col: 2, true )
        setCell( row: 2, col: 0, true )
        setCell( row: 2, col: 1, true )
        setCell( row: 2, col: 2, true )

        setCell( row: 2, col: 12, true )
        setCell( row: 3, col: 11, true )
        setCell( row: 4, col: 13, true )
        setCell( row: 4, col: 12, true )
        setCell( row: 4, col: 11, true )

        setCell( row: 14, col: 2, true )
        setCell( row: 13, col: 3, true )
        setCell( row: 12, col: 1, true )
        setCell( row: 12, col: 2, true )
        setCell( row: 12, col: 3, true )

        setCell( row: 26, col: 33, true )
        setCell( row: 27, col: 32, true )
        setCell( row: 28, col: 34, true )
        setCell( row: 28, col: 33, true )
        setCell( row: 28, col: 32, true )

        setCell( row: 26, col: 43, true )
        setCell( row: 27, col: 42, true )
        setCell( row: 28, col: 44, true )
        setCell( row: 28, col: 43, true )
        setCell( row: 28, col: 42, true )

        setCell( row: 26, col: 53, true )
        setCell( row: 27, col: 52, true )
        setCell( row: 28, col: 54, true )
        setCell( row: 28, col: 53, true )
        setCell( row: 28, col: 52, true )

        setCell( row: 16, col: 28, true )
        setCell( row: 17, col: 27, true )
        setCell( row: 18, col: 29, true )
        setCell( row: 18, col: 28, true )
        setCell( row: 18, col: 27, true )

        setCell( row: 16, col: 43, true )
        setCell( row: 17, col: 42, true )
        setCell( row: 18, col: 44, true )
        setCell( row: 18, col: 43, true )
        setCell( row: 18, col: 42, true )

        setCell( row: 16, col: 58, true )
        setCell( row: 17, col: 57, true )
        setCell( row: 18, col: 59, true )
        setCell( row: 18, col: 58, true )
        setCell( row: 18, col: 57, true )
    }
    
    func computeNeighbours( row: Int, col: Int ) -> Int
    {
        var n = 0
        if cell( row: row, col: leftOf( col ))      { n += 1 }
        if cell( row: row, col: rightOf( col ))     { n += 1 }

        if cell( row: above( row ), col: leftOf( col ))     { n += 1 }
        if cell( row: above( row ), col: col )              { n += 1 }
        if cell( row: above( row ), col: rightOf( col ))    { n += 1 }

        if cell( row: under( row ), col: leftOf( col ))     { n += 1 }
        if cell( row: under( row ), col: col )              { n += 1 }
        if cell( row: under( row ), col: rightOf( col ))    { n += 1 }
        
        return n
    }
}

struct ContentView: View {
    @State private var field0 = Playfield(rows: 50, cols: 75)
    @State private var field1 = Playfield(rows: 50, cols: 75)
    @State var stopTimer = false
    @State var cellCount = 0
    @State var generation = 0

    var body: some View {
        VStack( spacing: 1 ) {
            HStack {
                Button("Start") {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true ) { timer in
                        if stopTimer {
                            timer.invalidate()
                        } else {
                            next()
                        }
                    }
                }
                .padding()
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)

                Button("Stop") {
                    stopTimer = true
                }
                .padding()
                .padding(.horizontal)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .controlSize(.large)
                .tint(.blue)
            }
            .padding()
            
            ForEach( 0..<field0.rows, id: \.self ) { row in
                HStack( spacing: 1 ) {
                    ForEach( 0..<field0.cols, id: \.self ) { col in
                        let val = field0.cell( row: row, col: col )
                        Image( systemName: val ? "circle.fill" : "circle" )
                            .foregroundColor( val ? Color.white : Color.gray )
                            .font(.caption)
                    }
                }
            }
            
            HStack {
                Text( "Cell Count = \(cellCount)" )
                Spacer()
                Text( "Generation: \(generation)" )
            }
        }
        .padding()
    }
    
    func next()
    {
        cellCount = 0
        for row in 0..<field0.rows {
            for col in 0..<field0.cols {
                let n = field0.computeNeighbours(row: row, col: col )
                
                if field0.cell( row: row, col: col ) {
                    field1.setCell( row: row, col: col, n == 2 || n == 3 )
                } else {
                    field1.setCell( row: row, col: col, n == 3 )
                }
                if field1.cell( row: row, col: col ) {
                    cellCount += 1
                }
            }
        }
        field0 = field1
        generation += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
