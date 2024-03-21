#import "/src/lib.typ": *
#set page(width: auto, height: auto, margin: 1cm)

#num-product(10, 30)

#num-product(5, 100, 2)

#num-product(5, 100, 2, product-symbol: sym.dot.c)

#metro-setup(product-mode: "phrase")

#num-product(5, 100, 2)

#num-product(5, 100, 2, product-phrase: " BY ")
