#import "/src/lib.typ": qty, metro-setup
#set page(width: auto, height: auto)

#qty(1.23, "J/mol/kelvin")

$qty(.23, "candela", e: 7)$

#qty(1.99, "per kilogram", per-mode: "symbol")

#qty(1.345, "C/mol", per-mode: "fraction")