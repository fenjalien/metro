#import "/src/lib.typ": *
#set page(width: auto, height: auto, margin: 1cm)


#for exponents in ("individual", "combine-bracket", "combine") [
  #metro-setup(list-exponents: exponents, product-exponents: exponents, range-exponents: exponents)

  #num-list("5e3", "7e3", "9e3", "1e4")

  #num-product("5e3", "7e3", "9e3", "1e4")

  #num-range("5e3", "7e3")

]
