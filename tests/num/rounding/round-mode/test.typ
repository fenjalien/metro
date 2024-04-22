#import "/src/lib.typ": *
#set page(width: auto, height: auto, margin: 1cm)

= None

#num(1.23456)

#num(14.23)

= Places

#metro-setup(round-mode: "places", round-precision: 3)

#num(1.23456)

#num(14.23)

= Figures

#metro-setup(round-mode: "figures", round-precision: 3)

#num(1.23456)

#num(14.23)
