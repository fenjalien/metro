#import "/src/lib.typ": *
#import units: *
#set page(width: auto, height: auto, margin: 1cm)

#for units in ("bracket", "repeat", "single") [
  #metro-setup(list-units: units, product-units: units, range-units: units)

  #qty-list(2, 4, 6, 8, "T")

  #qty-product(2, 4, 6, 8, "T")

  #qty-range(2, 4, degreeCelsius)
]
