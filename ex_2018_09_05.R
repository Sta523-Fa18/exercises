## Exercise 1

levels = c("sun", "partial clouds", "clouds", "rain", "snow")

w = c(2L,2L,2L,2L,1L,1L,1L,1L)
attr(w, "levels") = levels
attr(w, "class") = "factor"



### `[[` example

x = c(1,2,3)
x[[-1]]


### Exercise 2

x = c(56, 3, 17, 2, 4, 9, 6, 5, 19, 5, 2, 3, 5, 0, 13, 12, 6, 31, 10, 21, 8, 4, 1, 1, 2, 5, 16, 1, 3, 8, 1,
      3, 4, 8, 5, 2, 8, 6, 18, 40, 10, 20, 1, 27, 2, 11, 14, 5, 7, 0, 3, 0, 7, 0, 8, 10, 10, 12, 8, 82,
      21, 3, 34, 55, 18, 2, 9, 29, 1, 4, 7, 14, 7, 1, 2, 7, 4, 74, 5, 0, 3, 13, 2, 8, 1, 6, 13, 7, 1, 10,
      5, 2, 4, 4, 14, 15, 4, 17, 1, 9)

# Select every third value starting at position 2 in x.

x[ seq(2, length(x), by=3) ]

x[ (1:33)*3 - 1 ]

# Remove all values with an odd index (e.g. 1, 3, etc.)

x[ -seq(1, length(x), by=2) ]

x[ seq(2, length(x), by=2) ]

x[ c(FALSE, TRUE) ]


# Remove every 4th value, but only if it is odd.

seq(1, length(x), by=4) # Pos int sub
x %% 2 == 1             # Log vec sub

x[ !(c(TRUE, FALSE, FALSE, FALSE) & (x %% 2 == 1)) ]
