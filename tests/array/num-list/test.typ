#import "/src/lib.typ": unit, metro-setup, num, qty, num-list
#set page(width: auto, height: auto, margin: 1cm)

#num-list(10, 30, 50, 70)

#num-list(0.1, 0.2, 0.3)

#num-list(0.1, 0.2, 0.3, list-separator: "; ")

#num-list(0.1, 0.2, 0.3, list-final-separator: ", ")

#num-list(0.1, 0.2, 0.3, list-separator: " and ", list-final-separator: " and finally ")

#num-list(0.1, 0.2)

#num-list(0.1, 0.2, list-pair-separator: ", and ")