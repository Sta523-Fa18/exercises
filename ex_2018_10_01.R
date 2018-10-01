library(magrittr)
library(purrr)



cat("Hello
World")

"\["


"\\["
cat("\\[")

library(stringr)
str_replace_all("thethethethe","\\bthe","---")
str_replace_all("thethethethe","the","---")
str_replace("thethethethe","the","---")


str_replace_all(text, "[(]", "*")
str_replace_all(text, "[\\(]", "*")
str_replace_all(text, "[-]", "*")

# Example 1

text = c("apple", "(219) 733-8965", "(329) 293-8753")

str_detect(text, "\\(\\d\\d\\d) \\d\\d\\d-\\d\\d\\d\\d")
str_detect(text, "\\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d\\d\\d")
str_detect(text, "\\(\\d\\d\\d\\) \\d\\d\\d\\-\\d\\d\\d\\d")


# Exercise 1

names = c("Haven Giron", "Newton Domingo", "Kyana Morales", "Andre Brooks", 
          "Jarvez Wilson", "Mario Kessenich", "Sahla al-Radi", "Trong Brown", 
          "Sydney Bauer", "Kaleb Bradley", "Morgan Hansen", "Abigail Cho", 
          "Destiny Stuckey", "Hafsa al-Hashmi", "Condeladio Owens", "Annnees el-Bahri", 
          "Megan La", "Naseema el-Siddiqi", "Luisa Billie", "Anthony Nguyen"
        )

## detect if the person's first name starts with a vowel (a,e,i,o,u)

purrr::discard(names, str_detect, pattern = "^[AEIOU]")
  


## detect if the person's last name starts with a vowel

purrr::keep(names, str_detect, pattern = " [AEIOUaeiou]")
purrr::keep(tolower(names), str_detect, pattern = " [aeiou]")

## detect if either the person's first or last name start with a vowel

purrr::keep(names, str_detect, pattern = "^[AEIOU]| [AEIOUaeiou]")

## detect if neither the person's first nor last name start with a vowel

purrr::discard(names, str_detect, pattern = "^[AEIOU]| [AEIOUaeiou]")

purrr::keep(names, str_detect, pattern = "^[BCDFGHJKLMNPQRSTVWXYZ][a-z]+ [BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz][a-z]+-?[A-Za-z]*")


# Exercise 2

text = c(
  "apple", 
  "219 733 8965", 
  "329-293-8753",
  "Work: (579) 499-7527; Home: (543) 355 3679"
)

## Write a regular expression that will extract all phone numbers contained in 
## the vector above.

str_extract_all(text, "\\(?\\d{3}\\)?[ -]\\d{3}[ -]\\d{4}")


## Once that works use groups to extracts the area code separately from the rest 
## of the phone number.

str_match_all(text, "\\(?(\\d{3})\\)?[ -]\\d{3}[ -]\\d{4}") %>% 
  purrr::map(~ .[,2]) %>%
  unlist()

str_match_all(text, "\\(?(\\d{3})\\)?[ -]\\d{3}[ -]\\d{4}") %>%
  do.call(rbind, .)


  
