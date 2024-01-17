#import "/src/lib.typ": qty, metro-setup
#set page(width: auto, height: auto)

#qty(12.3, "kg", pm: 0.4)

#qty(12.3, "kg", pm: 0.4, separate-uncertainty: "repeat")

#qty(12.3, "kg", pm: 0.4, separate-uncertainty: "single")
