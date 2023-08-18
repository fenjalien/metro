#import "src/lib.typ": *
#import units: *
#import prefixes: *

#set page(width: auto, height: auto, margin: 1cm)

#box(width: 2.9cm)[Some filler text #qty(10, "m")]\
#metro-setup(allow-quantity-breaks: true)
#box(width: 2.9cm)[Some filler text #qty(10, "m")]


#if 1 == 0 [
  // #metro-setup(tight-spacing: true)
  #qty(1.23, "J / mol / kelvin")\
  $qty(.23, candela, e: 7)$\
  #qty(1.99, "per kilogram", per-mode: "symbol")\
  #qty(1.345, "C/mol", per-mode: "fraction")
]


#if 1 == 0 [
  == group-digits
  #num[12345.67890]\
  #num(group-digits: none)[12345.67890]\
  #num(group-digits: "integer")[12345.67890]\
  #num(group-digits: "decimal")[12345.67890]\

  == group-separator
  #num[12345]\
  #num(group-separator: sym.comma)[12345]\
  #num(group-separator: sym.space)[12345]

  == group-minimum-digits
  #num[1234]\
  #num[12345]\
  #num(group-minimum-digits: 5)[1234]\
  #num(group-minimum-digits: 5)[12345]\
  #num[1234.5678]\
  #num[12345.67890]\
  #num(group-minimum-digits: 5)[1234.5678]\
  #num(group-minimum-digits: 5)[12345.67890]\

  == digit-group-size
  #num[1234567890]\
  #num(digit-group-size: 5)[1234567890]\
  #num(digit-group-other-size: 2)[1234567890]

  == output-decimal-marker
  #num[1.23]\
  #num(output-decimal-marker: sym.comma)[1.23]

  == exponent-base exponent-product
  #num(e: 2)[1]\
  #num(exponent-product: sym.dot.c, e: 2)[1]\
  #num(exponent-base: "2", e: 2)[1]

  == output-exponent-marker
  #num(output-exponent-marker: "e", e: 2)[1]\
  #num(output-exponent-marker: math.upright("E"), e: 2)[1]\

  == uncertainty-mode
  #num(pm: 0.005)[1.234]

  == bracket-ambiguous-numbers
  #num(e: 4, pm: 0.3)[1.2]\
  #num(e: 4, pm: 0.3, bracket-ambiguous-numbers: false)[1.2]

  == bracket-negative-numbers
  #num[-15673]\
  #num(bracket-negative-numbers: true)[-15673]\
  #num[-10]\
  #num(bracket-negative-numbers: true)[-10]

  == tight-spacing
  #num(e: 3)[2]\
  #num(e: 3, tight-spacing: true)[2]

  == print-implicit-plus
  #num[345]\
  #num(print-implicit-plus: true)[345]

  == print-unity-mantissa
  #num(e: 4)[1]\
  #num(print-unity-mantissa: false, e: 4)[1]

  == print-zero-exponent
  #num(e: 0)[444]\
  #num(print-zero-exponent: true, e: 0)[444]

  == print-zero-integer
  #num[0.123]\
  #num(print-zero-integer: false)[0.123]\

  == zero-decimal-as-symbol / zero-symbol
  #num[123.00]\
  #metro-setup(zero-decimal-as-symbol: true)
  #num[123.00]\
  #num(zero-symbol: [[#sym.bar.h]])[123.00]\

  #metro-reset()

  == retain-explicit-decimal-marker
  #num[10.]\
  #num(retain-explicit-decimal-marker: true)[10.]\

  == retain-explicit-plus
  #num[+345]\
  #num(retain-explicit-plus: true)[+345]\
  
]


// nums 
#if 1 == 0 {
  table(
    columns: 3,
    [Number], [Content], [String],
    num(123), num[123], num("123"),
    num(1234), num[1234], num("1234"),
    num(12345), num[12345], num("12345"),
    num(0.123), num[0.123], num("0.123"),
    num(0.1234), num[0,1234], num("0,1234"),
    num(.12345), num[.12345], num(".12345"),
    num(3.45, e: -4), num([3.45], e: [-4]), num("3.45", e: "-4"),
    "num(-, e: 10)", num([-], e: [10]), num("-", e: "10")
  )
}


// units
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
