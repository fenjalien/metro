#import "/src/lib.typ": num, qty

=== Test output decimal marker

#table(columns: 3,
  [], [Output `.`], [Output `,`],
  [Input `.`], num[1.0], num(decimal-marker: ",")[1.0],  
  [Input `,`], num[1,0], num(decimal-marker: ",")[1,0],  
)


=== Test group digits

#let examples = ([1], [10], [100], [1000], [10000], [0.1], [0.01], [0.001], [0,0001], [100000,00001])

#{
  set text(size: .8em)
  let num1 = num.with(groupmindigits: 0)
  table(columns: examples.len() + 1,
    [`group-digits: false`], ..examples.map(x => num1(x, group-digits: false)),
    [`group-size: 2`], ..examples.map(x => num1(x, group-size: 2, group-sep: "'")),
    [`group-size: 3`], ..examples.map(x => num1(x, group-sep: "'")),
    [`group-size: 4`], ..examples.map(x => num1(x, group-size: 4, group-sep: "'")),
    [`group-sep: space.thin`], ..examples.map(x => num1(x)),
    [`groupmindigits: 5`], ..examples.map(x => num(x, group-sep: "'")),
  )
}

=== Test inline exponential

#table(columns: 3,
  num[1e10], num[1e-10], num[1e+10]
)

=== Test uncertainty automatic precision

#table(columns: 4,
  num(pm: 0.2)[1], num(pm: 0.2)[1.], num(pm: 0.2)[1.0], num(pm: 0.2)[1.00],
  num(pm: 2)[10], num(pm: 200)[10], num(pm: 2)[1000], [],
  num(pm: 1)[1], num(pm: 1)[1.], [], [],
  num(pm: 1)[-1], num(pm: 1)[-1.], [], [],
)

=== Test implicit plus

#table(columns: 2,
  num(implicit-plus: true)[33e2],
  num(implicit-plus: true)[-33e2]
)

=== Test parentheses around uncertainty when exponent is given
#num(pm: 0.2, e: 2)[1]


=== Test normal vs. tight

#let examples = (
  ([1],[1]),
  ([1e2],none),
  ([1e2],[1.0]),
  )
#table(columns: examples.len() + 1,
  [`tight: false`], ..examples.map(x => num(x.at(0), pm: x.at(1))),
  [`tight: true`], ..examples.map(x => num(x.at(0), pm: x.at(1), tight: true)),  
)

#qty([2000000], "m", group-digits: false, implicit-plus: true)