## Script for Fetching GOES-16 Geocolor full disk images

library(curl)
library(rio)
library(stringr)
library(magick)
library(RCurl)

## Import Required images
black_rectangle <- image_read("C://Users//canti021//Documents//black_rectangle.png")
white_rectangle <- image_read("C://Users//canti021//Documents//white_rectangle.png")
black_stripe <- image_read("C://Users//canti021//Documents//black_stripe.png")

## Init vectors
a <- vector(mode = "list", length = 8)
b <- vector(mode = "list", length = 8)
c <- vector(mode = "list", length = 8)
d <- vector(mode = "list", length = 8)
e <- vector(mode = "list", length = 8)
f <- vector(mode = "list", length = 8)
g <- vector(mode = "list", length = 8)
h <- vector(mode = "list", length = 8)

image_list <- list(a,b,c,d,e,f,g,h)


## Destination file
destfile <- "C://Users//canti021//Documents//GOES16//total.png"
destfile2 <- "C://Users//canti021//Documents//GOES16//total2.png"

#Time calculations
time_now <- as.POSIXlt(Sys.time(), tz = "gmt")
year <- substr(time_now, 1,4)
month <- substr(time_now, 6,7)
day <- substr(time_now, 9,10)
hour <- substr(time_now, 12,13)
minute <- substr(time_now, 15,16)
second <- 0
pic_hour <- hour

## Boundary conditions (new year, month, leap years, etc) and URL directory formatting based on date
if(minute <= 15){
  pic_minute <- "00"
  pic_hour <- sprintf("%02d",as.numeric(hour)-1)
  if(pic_hour == -1){
    pic_hour <- 23
    day <- sprintf("%02d",as.numeric(day)-1)
    if(day=="00"){
      month <- sprintf("%02d",as.numeric(month)-1)
      day <- 31
      if(month == "00"){
        month <- "12"
        year <- as.numeric(year)-1
      }
      if(month == "04"|month=="06"|month=="09"|month=="11"){
        day <- "30"
      }
      if(month == "02"){
        day <- "28"
        ## Leap year detection
        if(year %% 4 == 0){
          day <- "29"
        }
      }
    }
  }
}

if(minute <= 30 & minute > 15){
  pic_minute <- "15"
  pic_hour <- sprintf("%02d",as.numeric(hour)-1)
  if(pic_hour == -1){
    pic_hour <- 23
    day <- sprintf("%02d",as.numeric(day)-1)
    if(day=="00"){
      month <- sprintf("%02d",as.numeric(month)-1)
      day <- 31
      if(month == "00"){
        month <- "12"
        year <- as.numeric(year)-1
      }
      if(month == "04"|month=="06"|month=="09"|month=="11"){
        day <- "30"
      }
      if(month == "02"){
        day <- "28"
        if(year %% 4 == 0){
          day <- "29"
        }
      }
    }
  }
}

if(minute <= 45 & minute > 30){
  pic_minute <- "30"
  pic_hour <- sprintf("%02d",as.numeric(hour)-1)
  if(pic_hour == -1){
    pic_hour <- 23
    day <- sprintf("%02d",as.numeric(day)-1)
    if(day=="00"){
      month <- sprintf("%02d",as.numeric(month)-1)
      day <- 31
      if(month == "00"){
        month <- "12"
        year <- as.numeric(year)-1
      }
      if(month == "04"|month=="06"|month=="09"|month=="11"){
        day <- "30"
      }
      if(month == "02"){
        day <- "28"
        if(year %% 4 == 0){
          day <- "29"
        }
      }
    }
  }
}

if(minute <= 59 & minute > 45){
  pic_minute <- "45"
  pic_hour <- sprintf("%02d",as.numeric(hour)-1)
  if(pic_hour == -1){
    pic_hour <- 23
    day <- sprintf("%02d",as.numeric(day)-1)
    if(day=="00"){
      month <- sprintf("%02d",as.numeric(month)-1)
      day <- 31
      if(month == "00"){
        month <- "12"
        year <- as.numeric(year)-1
      }
      if(month == "04"|month=="06"|month=="09"|month=="11"){
        day <- "30"
      }
      if(month == "02"){
        day <- "28"
        if(year %% 4 == 0){
          day <- "29"
        }
      }
    }
  }
}


clump1 <- paste(year, month, day, sep = "")

## Brute force last two digits of image ID
for(second_test in 30:46){
  clump2 <- paste(clump1, pic_hour, pic_minute, second_test, sep="")
  base_url <- paste("http://rammb-slider.cira.colostate.edu/data/imagery/",clump1,"/goes-16---full_disk/geocolor/",clump2,"/01/",sep="")
  if(url.exists(paste(base_url, "000_000.png",sep="")) == TRUE){
    second <- second_test
  }
}





## Image tile fetch 2x2 - Geocolor

clump2 <- paste(clump1, pic_hour, pic_minute, second, sep="")

base_url <- paste("http://rammb-slider.cira.colostate.edu/data/imagery/",clump1,"/goes-16---full_disk/geocolor/",clump2,"/01/",sep="")

a <- vector(mode = "list", length = 8)
b <- vector(mode = "list", length = 8)
c <- vector(mode = "list", length = 8)
d <- vector(mode = "list", length = 8)
e <- vector(mode = "list", length = 8)
f <- vector(mode = "list", length = 8)
g <- vector(mode = "list", length = 8)
h <- vector(mode = "list", length = 8)

image_list <- list(a,b,c,d,e,f,g,h)

for(i in 0:1){
  for(j in 0:1){
    image_list[[i+1]][[j+1]] <- image_read(paste(base_url, "00",i,"_","00",j,".png",sep=""))
  }
}

row1 <- c()
rows <- c()

for(l in 1:2){
  row1 <- c()
  for(k in 1:2){
    row1 <- append(row1, image_list[[l]][[k]], after = length(row1))
  }
  row1 <- image_append(row1)
  rows <- append(rows, row1, after = length(rows))
}
full_image_geocolor <- image_append(rows, stack=TRUE)


## Image tile fetch 2x2 - IR band 11

base_url <- paste("http://rammb-slider.cira.colostate.edu/data/imagery/",clump1,"/goes-16---full_disk/band_11/",clump2,"/01/",sep="")

a <- vector(mode = "list", length = 8)
b <- vector(mode = "list", length = 8)
c <- vector(mode = "list", length = 8)
d <- vector(mode = "list", length = 8)
e <- vector(mode = "list", length = 8)
f <- vector(mode = "list", length = 8)
g <- vector(mode = "list", length = 8)
h <- vector(mode = "list", length = 8)

image_list <- list(a,b,c,d,e,f,g,h)

for(i in 0:1){
  for(j in 0:1){
    image_list[[i+1]][[j+1]] <- image_read(paste(base_url, "00",i,"_","00",j,".png",sep=""))
  }
}

row1 <- c()
rows <- c()

for(l in 1:2){
  row1 <- c()
  for(k in 1:2){
    row1 <- append(row1, image_list[[l]][[k]], after = length(row1))
  }
  row1 <- image_append(row1)
  rows <- append(rows, row1, after = length(rows))
}
full_image_IR <- image_append(rows, stack=TRUE)

adjusted_IR <- append(white_rectangle, full_image_IR, after = length(white_rectangle))
adjusted_IR <- image_append(adjusted_IR, stack =FALSE)
adjusted_IR <- append(adjusted_IR, white_rectangle, after = length(adjusted_IR))
adjusted_IR <- image_append(adjusted_IR, stack =FALSE)

adjusted_geocolor <- append(black_rectangle, full_image_geocolor, after = length(black_rectangle))
adjusted_geocolor <- image_append(adjusted_geocolor, stack =FALSE)
adjusted_geocolor <- append(adjusted_geocolor, black_rectangle, after = length(adjusted_geocolor))
adjusted_geocolor <- image_append(adjusted_geocolor, stack =FALSE)

## Addition of 1 pixel wide black stripe on the left border because of a calculation boo boo
adjusted_geocolor <- append(black_stripe, adjusted_geocolor, after = length(black_stripe))
adjusted_geocolor <- image_append(adjusted_geocolor, stack =FALSE)

total <- append(adjusted_geocolor, adjusted_IR)
total <- image_append(total, stack = FALSE)

total <- image_fill(total, "black", point = "+2800+700", fuzz = 300)

image_write(total, path = destfile, format = "png")
image_write(total, path = destfile2, format = "png")
## Url Format reminder:
## "http://rammb-slider.cira.colostate.edu/data/imagery/20171001/goes-16---full_disk/geocolor/20171001210038/00/000_000.png"
