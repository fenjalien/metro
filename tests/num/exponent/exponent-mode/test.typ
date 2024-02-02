#import "/src/lib.typ": unit, metro-setup, num, qty
#set page(width: auto, height: auto)

#let test = [
  #num[0.012] \
  #num[0.00123] \
  #num[0.0001234] \
  #num[0.000012345] \
  #num[0.00000123456] \
  #num[123] \
  #num[1234] \
  #num[12345] \
  #num[123456] \
  #num[1234567] \
]

#test

#metro-setup(exponent-mode: "scientific")
#test

#metro-setup(exponent-mode: "engineering")
#test

#metro-setup(exponent-mode: "fixed", fixed-exponent: 2)
#test
#num(e: 4, "123")

#metro-setup(exponent-mode: "fixed", fixed-exponent: 0)
#num(e: 4, "1.23")