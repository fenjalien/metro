#import "/src/utils.typ": combine-dict
#import "num.typ"
#import "unit.typ" as unit_

#let default-options = (
  complex-angle-unit: "degrees",
  complex-mode: "input",
  complex-root-position: "after-number",
  complex-symbol-angle: sym.angle,
  complex-symbol-degree: sym.degree,
  output-complex-root: math.upright("i"),
  print-complex-unity: false
)

#let complex(real, imag, unit, options) = {
  
}