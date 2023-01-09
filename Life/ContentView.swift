//
//  ContentView.swift
//  Life
//
//  Created by Wiljo de Ruiter on 2023-01-08.
//

import SwiftUI

struct Cell
{
    var cell: Bool = false
    var neighbours: UInt8 = 0
}

struct Row
{
    var cols: Int
    var col: [Cell]
    
    init( cols: Int )
    {
        self.cols = cols
        col = Array( repeating: Cell(), count: cols )
    }
}

struct Playfield
{
    let rows: Int
    let cols: Int
    
    var row: [Row]
    
    init( rows aRows: Int, cols aCols: Int )
    {
        self.rows = aRows
        self.cols = aCols
        row = Array(repeating: Row(cols: cols), count: rows)
        addVipers()
    }
    
    func cell( row aRow: Int, col aCol: Int ) -> Bool
    {
        row[ aRow ].col[ aCol ].cell
    }
    
    mutating func setCell( row aRow: Int, col aCol: Int, _ val: Bool )
    {
        row[ aRow ].col[ aCol ].cell = val
    }
    
    func leftOf( _ aCol: Int ) -> Int
    {
        ( aCol + cols - 1 ) % cols
    }
    
    func rightOf( _ aCol: Int ) -> Int
    {
        ( aCol + 1 ) % cols
    }
    
    func above( _ aRow: Int ) -> Int
    {
        ( aRow + rows - 1 ) % rows
    }
    
    func under( _ aRow: Int ) -> Int
    {
        ( aRow + 1 ) % rows
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
    
    func computeNeighbours( row: Int, col: Int ) -> UInt8
    {
        var n: UInt8 = 0
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

enum ePlayState
{
    case Edit
    case Live
}

struct ContentView: View {
    @State private var field = Playfield(rows: 75, cols: 100)
    @State var stopTimer = false
    @State var cellCount = 0
    @State var generation = 0
    @State var state = ePlayState.Edit

    var body: some View {
        VStack( spacing: 0 ) {
            HStack {
                Button( action: {
                    if state == ePlayState.Edit {
                        state = ePlayState.Live
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true ) { timer in
                            if stopTimer {
                                timer.invalidate()
                            } else {
                                next()
                            }
                        }
                    }
                }) {
                    Text( "Start" )
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.all)
                }
                .controlSize(.large)
                .background(( state == ePlayState.Edit ? Color.blue : Color.gray ).cornerRadius(10))

                Button( action: {
                    if state == ePlayState.Live {
                        state = ePlayState.Edit
                        stopTimer = true
                    }
                }) {
                    Text( "Stop" )
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.all)

                }
                .controlSize(.large)
                .background(( state == ePlayState.Live ? Color.blue : Color.gray ).cornerRadius(10))
            }
            .padding()
            
            ForEach( 0..<field.rows, id: \.self ) { row in
                HStack( spacing: 0 ) {
                    ForEach( 0..<field.cols, id: \.self ) { col in
                        let val = field.cell( row: row, col: col )
                        Image( systemName: val ? "circle.fill" : "circle" )
                            .foregroundColor( val ? Color.white : Color.gray )
                            .font(.caption)
                            .onTapGesture {
                                if state == ePlayState.Edit {
                                    field.setCell(row: row, col: col, !field.cell( row: row, col: col ))
                                }
                            }
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
        for row in 0..<field.rows {
            for col in 0..<field.cols {
                field.row[ row ].col[ col ].neighbours = field.computeNeighbours(row: row, col: col )
            }
        }
        for row in 0..<field.rows {
            for col in 0..<field.cols {
                switch field.row[ row ].col[ col ].neighbours {
                case 2:
                    //if field.row[ row ].col[ col ].cell
                    break
                case 3:
                    field.row[ row ].col[ col ].cell = true
                default:
                    field.row[ row ].col[ col ].cell = false
                }

//                if field0.cell( row: row, col: col ) {
//                    field1.setCell( row: row, col: col, n == 2 || n == 3 )
//                } else {
//                    field1.setCell( row: row, col: col, n == 3 )
//                }
                if field.cell( row: row, col: col ) {
                    cellCount += 1
                }
            }
        }
        generation += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
