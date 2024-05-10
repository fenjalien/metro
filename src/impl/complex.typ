#import "/src/utils.typ": combine-dict
#import "/src/defs/units.typ": rad
#import "num/num.typ"
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

#let get-options(options) = combine-dict(options, default-options + num.default-options, only-update: true)


#let parse(options, imag) = {
  if options.parse-numbers == false and options.complex-mode == "input" {
    panic("Cannot identify the complex mode without parsing the number!")
  }

  let imag-type = type(imag)

  if imag-type == angle or (imag-type == str and imag.ends-with(regex("deg|rad"))) or (imag-type == content and repr(imag.func()) == "sequence" and imag.children.last() in (math.deg, rad)) {
    "is polar"
  } else {
    "is number"
  }
}

#let complex-num(real, imag, unit, options) = {
  options = get-options(options)
  return parse(options, imag)

  if options.complex-mode == "polar" {
    return repr(imag)
  }

  imag = num.num(imag, options)

  imag = (imag, options.output-complex-root)
  if options.complex-root-position != "after-number" {
    imag.rev()
  }
  imag = imag.join()

  return math.equation({
    num.num(real, options)
    sym.plus
    imag
  })
}