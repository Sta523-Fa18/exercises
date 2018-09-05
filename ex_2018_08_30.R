## Exercise 1 - Part 1

typeof( c(1, NA+1L, "C") )

typeof( c(1L / 0, NA) )

typeof( c(1:3, 5) )

typeof( c(3L, NaN+1L) )

typeof( c(NA, TRUE) )


## Exercise 1 - Part 2

### Hierarchy (least generic to most generic)
###
###    logical < integer < double < character
### 


## Exercise 2

str(list(
  "firstName" = "John",
  "lastName" = "Smith",
  "age" = 25,
  "address" = list(
      "streetAddress" = "21 2nd Street",
      "city" = "New York",
      "state" = "NY",
      "postalCode" = 10021
  ),
  "phoneNumber" = list(
    list(
      "type" = "home",
      "number"=  "212 555-1239"
    ),
    list(
      "type" = "fax",
      "number" = "646 555-4567"
    )
  )
))



json = '{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumber": 
    [{
        "type": "home",
        "number": "212 555-1239"
      },{
        "type": "fax",
        "number": "646 555-4567"
    }]
}'

str(jsonlite::fromJSON(json, simplifyVector = FALSE))



### Lazy eval example

y=3

f = function(x = y+1) {
  y = 2
  return(x)
}

f()


### backtick functions

1+1

`+`(1,1)

`|`(TRUE, FALSE)


