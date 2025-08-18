#import "@local/circuiteria:0.2.0"
// #import "@preview/abbr:0.1.0"
// #import "../../../typst/lib/circuiteria"
#import "@preview/cetz:0.3.2": draw, styles, drawable
#set page(width:auto, height:auto, margin: 0.5cm)
// #set page(width:)

#let label(body) = align(center)[
    #set text(font: "JetBrains Mono")
    #body
]
// #line(length: 100%)
// #set align(center)
#set text(font: "JetBrains Mono")
// #set draw.text-style(font: "Arial")
// #circuiteria.circuit(
//     length: 3em,
//     {
//     import circuiteria: *
//
//     draw.grid((-2, -2), (10, 10), step: 1, stroke: gray + 0.5pt)
//     draw.circle((0,0),name:"ci1", fill:blue, radius: 0.5)
//     draw.circle((8,6),name:"ci2", fill:blue, radius: 0.5)
//
//     draw.set-style(stroke: black + 3pt)
//     wire.wire("w7", ("ci1", "ci2"),
//             style: "guided",
//             guided-center: (50%, -10%),
//             guided-margins: (60%, 12%),
//             guided-sides: ("east", "east")
//     )
// }
// )
// #pagebreak()
#circuiteria.circuit(
    length: 3em,
    {
    import circuiteria: *
    element.group(
    id: "timer_core", stroke: 2pt,
        name-anchor: "north",
    fill: gray.transparentize(30%),
    padding: 15pt,
    {
    element.block(id: "btcnt",
        x:0, y:1, w:6, h:2,
        stroke: 2pt,
        name: [BTCNT],
        radius: 0.3em,
        ports: (
            south:  ((id: "hue0"),),
            west:   ((id: "clk", clock: true),),
            north:  ((id: "q24", name: "Q24"),
                    (id: "q28", name: "Q28"),
                    (id: "q32", name: "Q32")),
            east:   ((id: "out1"),)
        ),
        ports-margins: (
            north: (30%, 0%),
            west: (90%, 30%)
        )
    )
    element.block(id: "btccr0",
        x:-4, y:7.5, w:4, h:1,
        stroke: 2pt,
        name: [BTCCR0],
        radius: 0.3em,
        ports: (
            south:  ((id: "out"),),
            north:  ((id: "in"),)
        ),
    )
    element.block(id: "btccr1",
        x:(rel: 1, to: "btccr0.east"),
        y: (from: "btccr0.north", to: "in"),
        w:4, h:1,
        name: [BTCCR1],
        stroke: 2pt,
        radius: 0.3em,
        ports: (
            south:  ((id: "out"),),
            north:  ((id: "in"),)
        ),
    )
    element.block(id: "output-unit", 
        x:6, y:-3, w:2, h:1,
        name: [OUTPUT \ UNIT],
        stroke: 2pt,
        radius: 0.3em,
        ports: (
            north:  ((id:"in1"),),
            west:   ((id:"ccr1"), (id:"ccr0"))
        ),
        // debug: (ports: true)
    )
    element.multiplexer(id: "clk-mux",
        x:-6, y:-3, w:1, h:3,
        h-ratio: 64%,
        stroke: 2pt,
        entries: 4,
    )
    element.multiplexer(id: "ifg-mux",
        x:8, y:4, w:1, h:3,
        stroke: 2pt,
        h-ratio: 64%,
        entries: 4
    )

    wire.wire("btcnt-out", ("btcnt-port-out1","output-unit-port-in1"),
        style: "zigzag", zigzag-ratio: 100%)

    wire.wire("w4", ("btcnt-port-q24","ifg-mux-port-in1"),
        style: "zigzag", zigzag-ratio: 0%)
    wire.wire("w5", ("btcnt-port-q28","ifg-mux-port-in2"),
        style: "zigzag", zigzag-ratio: 0%)
    wire.wire("w6", ("btcnt-port-q32","ifg-mux-port-in3"),
        style: "zigzag", zigzag-ratio: 0%)

    wire.wire("w3", ("btccr0-port-out", "output-unit-port-ccr0"),
            style: "guided",
            guided-sides: ("south", "west"),
            guided-center: (0%, -100%),
            guided-margins: (4%, 17%))
    wire.wire("w2", ("btccr1-port-out", "output-unit-port-ccr1"),
            style: "guided",
            guided-sides: ("south", "west"),
            guided-center: (-150%, -100%),
            guided-margins: (6%, 25%))

    draw.content((-6.4,8.5), [*Timer Core*])
    // draw.content("timer_core", [dasdaasda])

    wire.stub("clk-mux-port-in0", "west")
    wire.stub("clk-mux-port-in1", "west")
    wire.stub("clk-mux-port-in2", "west")
    wire.stub("clk-mux-port-in3", "west")
    wire.wire("sd",("clk-mux-port-out","btcnt-port-clk"), style: "zigzag")
    })


})


