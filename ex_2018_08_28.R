## Modulus Operator

2 %% 2 
3 %% 2


## Exercise 1

x = 1
y = 1

# If x is greater than 3 and y is less than or equal to 3 then print "Hello world!"

# Otherwise if x is greater than 3 print "!dlrow olleH"

# If x is less than or equal to 3 then print "Something else ..."

# Stop execution if x is odd and y is even and report an error, don't print any of the text strings above.
if ((x %% 2 == 1) & (y %% 2 == 0)) {
  stop("There was an error")
} else if (x > 3 & y <= 3) {
  print("Hello World!")
} else if (x > 3) {
  print("!dlroW olleH")
} else if (x <= 3) {
  print("Something else ...")
} 



if ((x %% 2 == 1) & (y %% 2 == 0)) {
  stop("There was an error")
} else if (x > 3) {
  if (y <= 3)
    print("Hello World!")
  else
    print("!dlroW olleH")
} else if (x <= 3) {
  print("Something else ...")
} 



## seq_along example

x = 5:7

# Bad
for(i in 1:length(x)) {
  print(x[i])
}

# Good
for(i in seq_along(x)) {
  print(x[i])
}


### Exercise 2

primes = c( 2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
            43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)



for (x in c(3,4,12,19,23,51,61,63,78)) {
  x_is_prime = FALSE
  for (prime in primes) {
    if (x == prime) {
      # We know x is prime
      x_is_prime = TRUE
      break
    }
  }
  
  if (!x_is_prime)
    print(x)
}

x = c(3,4,12,19,23,51,61,63,78)

x[!x %in% primes]





