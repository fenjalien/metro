#import "/src/lib.typ": num, metro-setup
#set page(width: auto, height: auto)


#num[1234]

#num[12345]

#num(group-minimum-digits: 4)[1234]

#num(group-minimum-digits: 4)[12345]

#num[1234.5678]

#num[12345.67890]

#num(group-minimum-digits: 4)[1234.5678]

#num(group-minimum-digits: 4)[12345.67890]