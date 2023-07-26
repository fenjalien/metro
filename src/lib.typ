#import "units.typ"
#import "prefixes.typ"

#let _state = state("metro-setup", (
  inter-unit-product: sym.space.thin,
  frac-mode: "symbol",
  per-mode: "power",
  qualifier-mode: "subscript",
  times: sym.dot,
  units: units._dict,
  prefixes: prefixes._dict
))

#let _update-dict(new, old) = {
  for (k, v) in new {
    old.insert(k, v)
  }
  return old
}

#let metro-setup(..options) = _state.update(s => {
  return _update-dict(options.named(), s)
})

#let literal-units(units, options) = {
  let (inter-unit-product, frac-mode) = options

  // Steps through the content tree to insert inter-unit-products and remove prefix markers
  let process(value, is-denom: false) = {
    // Get the string representation of the content type
    let func = repr(value.func())
    if func == "sequence" {
      for (i, v) in value.children.enumerate() {
        let f = repr(v.func())
        // If its a space check if the previous item is a sequence whose last item is a zws.
        // If true don't place an inter-unit-product as that indicates a prefix
        // If false place an inter-unit-product
        if f == "space" {
          // Can't do this on the first element in the sequence so place an inter-unit-product anyway
          if i > 0 {
            let prev = value.children.at(i - 1)
            let prev-f = repr(prev.func())
            // [#sym.zws] because the zws is actually a content and doesn't match with a symbol
            if not (prev-f == "sequence" and prev.children.last() == [#sym.zws]) {
              inter-unit-product
            }
          } else {
            inter-unit-product
          }
        } else {
          // Handle what ever else this is.
          process(v)
        }
      }
    } else if func == "attach" {
      // Just process the base of the attachment as thats where units may be
      let fields = value.fields()
      let base = process(fields.remove("base"))
      math.attach(base, ..fields)
    } else if func in "lr" {
      // An lr's body is just a sequence so we don't have to recall it
      process(value.body)
    } else if func == "frac" {
      if frac-mode == "symbol" {
        process(value.num) + h(0pt) + sym.slash + h(0pt) + process(value.denom, is-denom: true)
      } else {
        math.frac(process(value.num), process(value.denom, is-denom: true))
      }
    } else if func == "text" and value == [#sym.zws] {
      // Remove any zws as these are prefix markers and we don't want them
    } else {
      // Nothing else should matter
      value
    }
  }
  return math.upright(process(units))
}

#let interpreted-units(input, options) = {
  let (units, prefixes, inter-unit-product) = options

  let before-powers = (per: -1, square: 2, cubic: 3)
  let after-powers = (squared: 2, cubed: 3)

  let result = ()
  let power = 1
  let prefix = ""

  for u in input.split("#") {
    if u == "" {
      continue
    } else if u in units {
      u = units.at(u)
      if power != 1 {
        u = math.attach(u, t: str(power).replace("-", sym.minus))
        power = 1
      }
      result.push(prefix + u)
      prefix = none
    } else if u in prefixes {
      prefix = prefixes.at(u)
    } else if u in before-powers or u.starts-with("raiseto") {
      power *= if u.starts-with("raiseto") {
          float(u.slice(8, -1))
        } else {
          before-powers.at(u)
        }
    } else if u in after-powers or u.starts-with("tothe") {
      let t = if u.starts-with("tothe") {
          u.slice(6, -1)
        } else {
          after-powers.at(u)
        }

      let (prefix, last) = result.last().children
      let fields = (:)
      if repr(last.func()) == "attach" {
        fields += last.fields()
        fields.t = float(fields.t.text.replace(sym.minus, "-")) * float(t)
      } else {
        fields.t = t
        fields.base = last
      }

      fields.t = str(fields.t).replace("-", sym.minus)

      result.last() = prefix + math.attach(
        fields.remove("base"), 
        ..fields
      )
    } else if u.starts-with("of") {
      let b = u.slice(3, -1)
      let last = result.last()
      let fields = (:)

      if repr(last.func()) == "attach" {
        fields += last.fields()
      } else {
        fields.base = last
      }
      fields.b = b

      result.last() = math.attach(
        fields.remove("base"), 
        ..fields
      )
    } else {
      panic("unknown variable: ", u)
    }
  }

  return math.upright(result.join(inter-unit-product))
}

#let unit(input, ..options) = _state.display(s => {
  let options = _update-dict(options.named(), s)
  let t = type(input)
  if t == "content" {
    return literal-units(input, options)
  } else if t == "string" {
    return interpreted-units(input, options)
  } else {
    panic("Expected content or string, found ", t)
  }
})

#let declare-unit(unt, symbol, ..options) = _state.update(s => {
  s.units.insert(unt, unit(symbol, options))
  return s
})

#let declare-prefix(prefix, symbol, ..options) = _state.update(s => {
  s.prefixes.insert(prefix, unit(symbol, options))
  return s
})

#let num(number, e: none, pm: none, ..options) = _state.display(s => {
  let s = _update-dict(options.named(), s)
  let power = if e == none { none } else { $#s.times 10^#e$ }
  if pm != none {
    if type(pm) in ("float", "integer") { pm = $#str(pm)$ }
    if type(number) in ("float", "integer") { number = $#str(number)$ }
    number = "(" + number + sym.plus.minus + pm + ")"
  }

  $number#power$
})

#let qty(
  number, 
  units, 
  e: none, 
  pm: none,
  ..options
) = _state.display(s => {


  let result = {
    num(number, e: e, pm: pm, options)
    sym.space.thin
    unit(units, options)
  }
  // if not allowbreaks { 
  //   result = $#result$
  // }

  result
})

#import units: *
#import prefixes: *
