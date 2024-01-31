#import "/src/lib.typ": qty, metro-setup
#set page(width: auto, height: auto)


#qty(2.67, "farad")\
#qty(2.67, "farad", quantity-product: sym.space)\
#qty(2.67, "farad", quantity-product: none)

#metro-setup(quantity-product: sym.times)

#qty(1.23, "mm", per-mode: "symbol")\
#qty(1.23, "m/m", per-mode: "fraction")\
#qty(1.23, "m", per-mode: "symbol")\
#qty(1.23, "m")\
#qty(1.23, "/s", per-mode: "symbol")\
#qty(1.23, "m/s", per-mode: "symbol")\
#qty(1.23, "m/s")
