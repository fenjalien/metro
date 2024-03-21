#import "/src/lib.typ": *
#set page(width: auto, height: auto, margin: 1cm)

#num-range(10, 30)

$numrange(10, 30)$

#num-range(5, 100)

#num-range(5, 100, range-phrase: sym.dash)

#num-range(10, 12)

$#num-range(10, 12, range-open-phrase: [from ])$
