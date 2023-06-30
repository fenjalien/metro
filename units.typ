#let upright = math.upright
#let unit(value) = {
  assert.eq(type(value), "content", message: "Expected content, got type " + repr(type(value)))

  let process(value) = {
    let func = repr(value.func())
    if func == "space" {
      sym.space.thin
    } else if func == "sequence" {
      value.children.map(process).join()
    } else if func == "attach" {
      let fields = value.fields()
      let base = process(fields.remove("base"))
      math.attach(base, ..fields)
    } else if func in "lr" {
      process(value.body)
    } else if func == "frac" {
      process(value.num) + sym.slash + process(value.denom)
    } else {
      value
    }
  }

  return math.upright(" " + process(value))
}


// SI units
#let ampere = $A$
#let candela = $c d$
// #let kelvin = $kelvin$
#let kilogram = $k g$
#let metre = $m$
#let mole = $m o l$
#let second = $s$


// Derived units
#let becquerel = $B q$
// #let degreeCelsius = $degree.c$
#let coulomb = $C$
#let farad = $F$
#let gray = $G y$
#let hertz = $H z$
#let henry = $H$
#let joule = $J$
#let lumen = $l m$
#let katal = $k a t$
#let lux = $l x$
#let newton = $N$
// #let ohm = $ohm$
#let pascal = $P a$
#let radian = $r a d$
#let siemens = $S$
#let sievert = $S v$
#let steradian = $s r$
#let tesla = $T$
#let volt = $V$
#let watt = $W$
#let weber = $W b$


// Non-SI units
#let astronomicalunit = $a u$
#let bel = $B$
#let dalton = $D a$
#let day = $d$
#let decibel = $d B$
#let electronvolt = $e V$
#let hectare = $h a$
#let hour = $h$
#let litre = $L$
#let liter = litre
#let arcminute = $prime$
#let minute = $m i n$
#let arcsecond = $prime.double$
#let neper = $N p$
#let tonne = $t$


// SI prefixes
#let quecto = $q$
#let ronto = $r$
#let yocto = $y$
#let atto = $a$
#let zepto = $z$
#let femto = $f$
#let pico = $p$
#let nano = $n$
#let micro = $mu$
#let milli = $m$
#let centi = $c$
#let deci = $d$
#let deca = $d a$
#let hecto = $h$
#let kilo = $k$
#let mega = $M$
#let giga = $G$
#let tera = $T$
#let peta = $P$
#let exa = $E$
#let zetta = $Z$
#let yotta = $Y$
#let ronna = $R$
#let quetta = $Q$


// Unit abbreviations
#let kg = kilogram
#let cd = candela
#let mol = mole
#let Bq = becquerel
#let Gy = gray
#let Hz = hertz
#let lm = lumen
#let kat = katal
#let lx = lux
#let Pa = pascal
#let rad = radian
#let Sv = sievert
#let sr = steradian
#let Wb = weber
#let au = astronomicalunit
#let Da = dalton
#let dB = decibel
#let eV = electronvolt
#let ha = hectare
#let Np = neper



#{
  let conditional-upright = x => if repr(x.func()) == "equation" {upright(x)} else {x}
[
#figure(
  table(
    columns: (auto, auto),
    align: left,
    [Unit], [Symbol],
    ..(
    [ampere], ampere,
    [candela], candela,
    [kilogram], kilogram,
    [metre], metre,
    [mole], mole,
    [second], second
    ).map(conditional-upright)
  ),
  caption: [SI base units.]
)

#figure(
  table(
    columns: (auto,)*4,
    align: left,
    [Unit], [Symbol], [Unit], [Symbol],
    ..([becquerel], becquerel, [newton], newton,
    [degree Celsius], $degree.c$, [ohm], $ohm$,
    [coulomb], coulomb, [pascal], pascal,
    [farad], farad, [radian], radian,
    [gray], gray,[siemens], siemens,
    [hertz], hertz, [sievert], sievert,
    [henry], henry, [steradian], steradian,
    [joule], joule, [tesla], tesla,
    [lumen], lumen, [volt], volt,
    [katal], katal, [watt], watt,
    [lux], lux, [weber], weber).map(conditional-upright)
  ),
  caption: [Coherent derived units in the SI with special names and symbols.]
)

#figure(
  table(
    columns: (auto,)*2,
    align: left,
    [Unit], [Symbol],
    ..(
    [astronomicalunit], au,
    [bel], bel,
    [dalton], Da,
    [day], day,
    [decibel], dB,
    [degree], $degree$,
    [electronvolt], eV,
    [hectare], ha,
    [hour], hour,
    [litre or liter], litre,
    [arcminute], arcminute,
    [minute], minute,
    [arcsecond], arcsecond,
    [neper], Np,
    [tonne], tonne
    ).map(conditional-upright)
  ),
  caption: [Non-SI units accepted for use with the International System of Units.]
)
]
}