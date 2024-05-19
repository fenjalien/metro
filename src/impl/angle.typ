#import "/src/utils.typ": content-to-string
#import "/src/defs/units.typ": rad
#import "num/num.typ"

#let is-angle(ang) = {
  let typ = type(ang)
  return typ == angle or (typ == str and ang.ends-with(regex("deg|rad"))) or (typ == content and repr(ang.func()) == "sequence" and ang.children.last() in (math.deg, rad))
}

#let to-number(ang) = {
  let typ = type(ang)
  return if typ == angle {
    ang
  } else if typ == str {
    float(ang.slice(0, ang.len() - 3)) * if ang.ends-with("deg") { 1deg } else { 1rad }
  } else {
    let children = ang.children
    let mult = if children.pop() == math.deg { 1deg } else { 1rad }
    float(content-to-string(children.join())) * mult
  }
}

#let parse(options, ang) = {
  let typ = type(ang)
  return num.parse(
    options,
    to-number(ang) / if options.complex-angle-unit == "degrees" { 1deg } else { 1rad }
  )
}