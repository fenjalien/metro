#import "/src/lib.typ": *
#set page(width: auto, height: auto, margin: 1cm)


#complex(1, 1)

#complex(1, 45deg)

#complex(1, 1, complex-mode: "cartesian")

#complex(1, 45deg, complex-mode: "cartesian", round-mode: "places")

#complex(1, 1, complex-mode: "polar", round-mode: "places", round-pad: false)

#complex(1, 45deg, complex-mode: "polar")

