#import "/src/lib.typ": unit, metro-setup, num, qty
#set page(width: auto, height: auto)

#let inputs = (
  "0.001",
  "0.012",
  "0.123",
  "1",
  "12",
  "123",
  "1234"
)


#table(
  columns: (auto,)*3,
  [Input], [Threshold $-3:3$], [Threshold $-2:2$],
  ..for i in inputs {(
      num(i),
      num(i, exponent-mode: "threshold"),
      num(i, exponent-mode: "threshold", exponent-thresholds: (-2, 2)),
    )}
)