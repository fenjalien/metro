#import "units.typ"
#import "prefixes.typ"

#let _state = state("metro-setup", (
  frac-mode: "symbol",
  qualifier-mode: "subscript",
  times: sym.dot,
  units: units._dict,
  prefixes: prefixes._dict,

  // Unit outupt options
  bracket-unit-denominator: true,
  inter-unit-product: sym.space.thin,
  per-mode: "power",
  per-symbol: h(0pt) + sym.slash + h(0pt),
  power-half-as-sqrt: false,
  qualifier-mode: "subscript",
  qualifier-phrase: "",
  sticky-per: false
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

// Takes math content
#let literal-units(units, options) = {
  let (inter-unit-product, frac-mode) = options

  // Steps through the content tree to insert inter-unit-products and remove prefix markers
  let process(value) = {
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
      let (num, denom) = (value.num, value.denom).map(process)
      if frac-mode == "symbol" {
        num + options.per-symbol + if options.bracket-unit-denominator { $(denom)$ } else { denom }
      } else {
        math.frac(num, denom)
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

// Takes a string
#let interpreted-units(input, options) = {
  let (units, prefixes, inter-unit-product, per-mode) = options

  let before-powers = (per: -1, square: 2, cubic: 3)
  let after-powers = (squared: 2, cubed: 3)

  // An array of units to be joined together after the for loop.
  // Elements should be content apart from when per is used and per-mode is "fraction"
  // Then fractions are a weird array of arrays (num, denom)
  let result = ()
  // The power to apply to the next unit
  let power = 1
  // The prefix to apply to the next unit
  let prefix = none

  for u in input.split("#") {
    // Can safely ignore empty strings as they appear at the start of the input.
    // Could also be due to double # but eh.
    if u == "" {
      continue
    } else if u in units {
      // Prepend the current prefix to the unit's symbol.
      // prefix does nothing if it is none
      u = prefix + units.at(u)

      if power != 1 {
        // Apply the current power according to per-mode
        if power > 0 or per-mode == "power" {
          // Even if per-mode is not "power", if power is +ve we don't want to make a
          // fraction
          result.push(
            math.attach(
              u, 
              // For some reason a string "-" appears as a hyphen when in math
              // so replace it we must replace it with the correct symbol
              t: str(power).replace("-", sym.minus)
            )
          )
        } else if per-mode in ("fraction", "symbol") {
          if result.len() > 0 and type(result.last()) == "array" {
            // If the previous element is a fraction just append to it
            result.last().last() += (u,)
          } else {
            // If the previous element is not a fraction or this is the first element
            // create a new fraction
            result = ((result, (u,)),)
          }
        }
        // Reset power
        if options.sticky-per and power < 0 {
          power = -1
        } else {
          power = 1
        }
      } else {
        // No power to apply to the unit
        result.push(u)
      }
      // Reset the current prefix
      prefix = none
    } else if u in prefixes {
      // Set the current prefix
      prefix = prefixes.at(u)
    } else if u in before-powers or u.starts-with("raiseto") {
      // modify the current power for the next unit

      power *= if u.starts-with("raiseto") {
          // comes as "raiseto(x)" where x is a float
          float(u.slice(8, -1))
        } else {
          before-powers.at(u)
        }
    } else if u in after-powers or u.starts-with("tothe") {
      // Modify the previous element with this power

      let t = if u.starts-with("tothe") {
          // comes as "tothe(x)" where x is a float
          u.slice(6, -1)
        } else {
          after-powers.at(u)
        }

      // Get the previous element
      let last = result.last()

      // If it is a fraction get the previous element of its denom
      let frac = false
      if type(last) == "array" {
        last = last.last().last()
        frac = true
      }
      
      // setup the fields of the attach
      let fields = (:)
      if repr(last.func()) == "attach" {
        // If the previous element is already an attach modify its `t` field
        fields += last.fields()
        if "t" in fields {
          // for some reason float doesn't like the symbol minus so convert it back to "-"
          fields.t = float(fields.t.text.replace(sym.minus, "-")) * float(t)
        } else {
          fields.t = t
        }
      } else {
        fields.t = t
        fields.base = last
      }


      fields.t = str(fields.t).replace("-", sym.minus)

      let attach = math.attach(
        fields.remove("base"), 
        ..fields
      )
      // Make sure to replace the attach in the correct place
      if frac {
        result.last().last().last() = attach
      } else {
        result.last() = attach
      }
    } else if u.starts-with("of") {
      // Modify the previous element with the given qualifier
      // comes as "of(x)" where x is a string
      let of = u.slice(3, -1)

      let last = result.last()

      if options.qualifier-mode in ("bracket", "combine", "phrase") {
        if options.qualifier-mode == "bracket" {
          of = "(" + of + ")"
        } else if options.qualifier-mode == "phrase" {
          of = options.qualifier-phrase + of
        }
        if repr(last.func()) == "attach" {
          let fields = last.fields()
          result.last() = math.attach(
            fields.remove("base") + of,
            ..fields
          )
        } else {
          result.last() += of
        }
      } else if options.qualifier-mode == "subscript" {
        let fields = (:)
        if repr(last.func()) == "attach" {
          fields += last.fields()
        } else {
          fields.base = last
        }
        fields.b = of

        result.last() = math.attach(
          fields.remove("base"), 
          ..fields
        )
      } else {
        panic("Unknown qualifier-mode: " + options.qualifier-mode)
      }
    } else {
      panic("unknown variable: " + u)
    }
  }

  // I hate doing it like this idk why
  let flatten(array) = for a in array {
    (if type(a) == "array" {
      let (num, denom) = a
      num = if num.len() > 0 {
          flatten(num)
        } else { 
          ""
        }
      let denom-brackets = denom.len() > 1 and options.bracket-unit-denominator
      denom = flatten(denom)
      if per-mode == "fraction" {
        math.frac(num, denom)
      } else {
        num + options.per-symbol + if denom-brackets { $(denom)$ } else { denom }
      }
    } else if options.power-half-as-sqrt and type(a) == "content" and repr(a.func()) == "attach" and "t" in a.fields() and a.t == [0.5] {
      let fields = a.fields()
      fields.t = none
      math.attach(math.sqrt(fields.remove("base")), ..fields)
    } else {
      a
    },)
  }.join(inter-unit-product)

  math.upright(flatten(result))
}

#let _unit(input, options) = {
  let t = type(input)
  if t == "content" {
    return literal-units(input, options)
  } else if t == "string" {
    return interpreted-units(input, options)
  } else {
    panic("Expected content or string, found ", t)
  }
}

#let unit(input, ..options) = _state.display(s => {
  return _unit(input, _update-dict(options.named(), s))
})

#let declare-unit(unt, symbol, ..options) = _state.update(s => {
  s.units.insert(unt, unit(symbol, options))
  return s
})

#let declare-prefix(prefix, symbol, ..options) = _state.update(s => {
  s.prefixes.insert(prefix, unit(symbol, options))
  return s
})

#let _num(number, e, pm, options) = {
  let power = if e == none { none } else { $#s.times 10^#e$ }
    if pm != none {
      if type(pm) in ("float", "integer") { pm = $#str(pm)$ }
      if type(number) in ("float", "integer") { number = $#str(number)$ }
      number = "(" + number + sym.plus.minus + pm + ")"
    }

    $number#power$
}

#let num(number, e: none, pm: none, ..options) = _state.display(s => {
  return _num(number, e, pm, _update-dict(options.named(), s))
})

#let qty(
  number, 
  units, 
  e: none, 
  pm: none,
  ..options
) = _state.display(s => {
  let options = _update-dict(options.named(), s)

  let result = {
    _num(number, e, pm, options)
    sym.space.thin
    _unit(units, options)
  }
  // if not allowbreaks { 
  //   result = $#result$
  // }

  result
})
