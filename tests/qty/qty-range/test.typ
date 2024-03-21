#import "/src/lib.typ": unit, metro-setup, num, qty, qty-range
#set page(width: auto, height: auto, margin: 1cm)

#qty-range(2, 4, [kg])\
#qty-range(2, 4, [kg], range-units: "repeat")\
#qty-range(2, 4, [degreeCelsius], range-units: "bracket")\
#qty-range(2, 4, [degreeCelsius], range-units: "bracket", range-open-phrase: "from ")\
#qty-range(2, 4, [degreeCelsius], range-units: "single")\
#qty-range(2, 4, [degreeCelsius], range-units: "single", range-phrase: sym.dash.em)
