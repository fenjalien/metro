#import "src/lib.typ": *
// #import "src/metro.typ": _state
// #import "src/parsers.typ": parse-math-units, parse-string-units
// #import "@preview/t4t:0.2.0": assert

#set page(width: auto, height: auto, margin: 1cm)

// #unit("kilogram of(pol) squared per mole of(cat) per hour")
#unit("kilo gram")


//   #unit("kilo gram meter / second^2"), 
// #unit($kilo gram meter / second^2$)
// #unit($mol$)

// #let test-groups = (
//   "kg m/s^2": (
//   "kilo gram meter / second^2",
//   $kilo gram meter / second^2$,
//   $kg m/s^2$
// ))

// #_state.display(options => {
//   let tester = (x) => if type(x) == "string" {
//     parse-string-units(x, options)
//   } else {
//     parse-math-units(x)
//   }

//   for (name, tests) in test-groups {
//     let control = tester(tests.first())
//     for test in tests.slice(1) {
//       assert.eq(
//         control, 
//         tester(test), 
//         message: name + ": Control and test are not equal. Expected " + repr(control) + " got " + repr(tester(test))
//       )
//     }
//   }
// })

#if 1 == 0 {
table(
  columns: 5,
  [math], [math short hand], [string], [string w/symbols], [string shorthand],

  $unit(kilo gram meter / second^2)$, 
  $unit(kg m/s^2)$,
  unit("kilo gram meter per square second"),
  unit("kilo gram meter / second^2"), 
  unit("kg m/s^2"),

  $unit(gram / centi meter^3)$,
  $unit(g / cm^3)$,
  unit("gram per cubic centi meter"),
  unit("gram / centi meter^3"),
  unit("g/cm^3"),

  $unit(volt^2 lumen^3 / farad)$,
  $unit(V^2 lm^3 / F)$,
  unit("square volt cubic lumen per farad"),
  unit("volt^2 lumen^3 / farad"),
  unit("V^2 lm^3/F"),

  $unit(meter^2 / gray lux^3)$,
  $unit(m^2/Gy lx^3)$,
  unit("metre squared per gray cubic lux"),
  unit("metre^2 / gray lux^3"),
  unit("m^2 / Gy lx^3"),

  $unit(henry second)$,
  $unit(H s)$,
  unit("henry second"),
  [N/A],
  unit("H s"),

  $unit(becquerel^2)$,
  $unit(Bq^2)$,
  unit("square becquerel"),
  unit("becquerel^2"),
  unit("Bq^2"),

  $unit(joule^2 / lumen)$,
  $unit(J^2 / lm)$,
  unit("joule squared per lumen"),
  unit("joule^2 / lumen"),
  unit("J^2/lm"),

  $unit(lux^3 volt tesla^3)$,
  $unit(lx^3 V T^3)$,
  unit("cubic lux volt tesla cubed"),
  unit("lux^3 volt tesla^3"),
  unit("lx^3 V T^3"),

  $unit(henry^5)$,
  $unit(H^5)$,
  unit("henry tothe(5)"),
  unit("henry^5"),
  unit("H^5"),

  $unit(radian^4.5)$,
  $unit(rad^4.5)$,
  unit("raiseto(4.5) radian"),
  unit("radian^4.5"),
  unit("rad^4.5"),

  $unit(joule / mole / kelvin)$,
  $unit(J / (mol K))$,
  unit("joule per mole per kelvin"),
  unit("joule / mole / kelvin"),
  unit("J / mol / K"),

  $unit(joule / mole kelvin)$,
  $unit(J / mol K)$,
  unit("joule per mole kelvin"),
  unit("joule / mole kelvin"),
  unit("J / mol K"),

  $unit(henry^(-5))$,
  $unit(H^(-5))$,
  unit("per henry tothe(5)"),
  unit("/ henry^5"),
  unit("/H^5"),

  $unit(becquerel^(-2))$,
  $unit(Bq^(-2))$,
  unit("per square becquerel"),
  unit("/becquerel^2"),
  unit("/Bq^2"),

  $unit(kilogram_"metal")$,
  $unit(kg_"metal")$,
  unit("kilogram of(metal)"),
  unit("kilogram_metal"),
  unit("kg_metal"),

  metro-setup(qualifier-mode: "bracket") + $unit(milli mole_"cat" / kilogram_"prod")$,
  $unit(mmol_"cat" / kg_"prod")$,
  unit("milli mol of(cat) per kilogram of(prod)"),
  unit("milli mol_cat / kilogram_prod"),
  unit("mmol_cat / kg_prod") + metro-setup(qualifier-mode: "subscript"),

  $unit(farad^2 lumen candela)$,
  $unit(F^2 lm cd)$,
  unit("farad squared lumen candela"),
  unit("farad^2 lumen candela"),
  unit("F^2 lm cd"),

  metro-setup(inter-unit-product: sym.dot.c) + $unit(farad^2 lumen candela)$,
  $unit(F^2 lm cd)$,
  unit("farad squared lumen candela"),
  unit("farad^2 lumen candela"),
  unit("F^2 lm cd") + metro-setup(inter-unit-product: sym.space.thin),

  $unit(metre / second^2)$,
  $unit(m/s^2)$,
  unit("metre per second squared"),
  unit("meter / second^2"),
  unit("m/s^2"),

  metro-setup(per-mode: "fraction") + $unit(joule / mole / kelvin)$,
  $unit(J/(mol K))$,
  unit("joule per mole per kelvin"),
  unit("joule / mole / kelvin"),
  unit("J/(mol K)"),

  $unit(metre / second^2)$,
  $unit(m/s^2)$,
  unit("metre per second squared"),
  unit("meter / second^2"),
  unit("m/s^2"),

  metro-setup(per-mode: "symbol") + $unit(joule / mole / kelvin)$,
  $unit(J/(mol K))$,
  unit("joule per mole per kelvin"),
  unit("joule / mole / kelvin"),
  unit("J/(mol K)"),

  $unit(metre / second^2)$,
  $unit(m/s^2)$,
  unit("metre per second squared"),
  unit("meter / second^2"),
  unit("m/s^2"),

  metro-setup(per-symbol: [ div ]) + $unit(joule / mole / kelvin)$,
  $unit(J/(mol K))$,
  unit("joule per mole per kelvin"),
  unit("joule / mole / kelvin"),
  unit("J/(mol K)"),

  metro-setup(per-symbol: sym.slash, bracket-unit-denominator: false) + $unit(joule / mole / kelvin)$,
  $unit(J/(mol K))$,
  unit("joule per mole per kelvin"),
  unit("joule / mole / kelvin"),
  unit("J/(mol K)"),
)
}
// #unit("J/(mol K)")
// #unit("/henry^5")
// #metro-setup(per-mode: "fraction")
// $unit(joule / mole / kelvin)$
