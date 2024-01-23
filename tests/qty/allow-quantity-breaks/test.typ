#import "/src/lib.typ": qty, metro-setup
#set page(width: auto, height: auto)


#box(width: 4.5cm)[Some filler text #qty(10, "m")]\
#metro-setup(allow-quantity-breaks: true)
#box(width: 4.5cm)[Some filler text #qty(10, "m")]