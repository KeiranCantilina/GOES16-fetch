## For retrieving ridiculously high res GOES 16 images

library(curl)
library(RCurl)
library(rio)
library(sendmailR)
library(stringr)
library(magick)

## Check for valid internet
if (url.exists("www.google.com")==TRUE) {
  out <- TRUE
} else {
  out <- FALSE
}

if(out==FALSE){
  quit()
}


## Retrieve list of timestamps (for geocolor)
stamps<-import("http://rammb-slider.cira.colostate.edu/data/json/goes-16/full_disk/geocolor/latest_times.json")
time_code <- as.character(stamps$timestamps_int[1])


## Init vectors
a <- vector(mode = "list", length = 8)
b <- vector(mode = "list", length = 8)
c <- vector(mode = "list", length = 8)
d <- vector(mode = "list", length = 8)
e <- vector(mode = "list", length = 8)
f <- vector(mode = "list", length = 8)
g <- vector(mode = "list", length = 8)
h <- vector(mode = "list", length = 8)
i<- vector(mode = "list", length = 8)
j<- vector(mode = "list", length = 8)
k<- vector(mode = "list", length = 8)
l<- vector(mode = "list", length = 8)
m<- vector(mode = "list", length = 8)
n<- vector(mode = "list", length = 8)
o<- vector(mode = "list", length = 8)
p<- vector(mode = "list", length = 8)

image_list <- list(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)


## Destination file
destfile <- "C://Users//Keiran//Documents//full_disk_HIRES_day_2.png"

## URL includes most recent timestamped image data (credit to Paul Schuster for assistance)
clump1 <- substr(time_code, 1,8)
clump2<- time_code


## Image tile fetch 8x8

base_url <- paste("http://rammb-slider.cira.colostate.edu/data/imagery/",clump1,"/goes-16---full_disk/geocolor/",clump2,"/04/",sep="")

for(i in 0:15){
  for(j in 0:15){
    image_list[[i+1]][[j+1]] <- image_read(paste(base_url, "0",sprintf("%02d",as.numeric(i)),"_","0",sprintf("%02d",as.numeric(j)),".png",sep=""))
  }
}

row1 <- c()
rows <- c()

for(l in 1:16){
  row1 <- c()
  for(k in 1:16){
    row1 <- append(row1, image_list[[l]][[k]], after = length(row1))
  }
  row1 <- image_append(row1)
  rows <- append(rows, row1, after = length(rows))
}
full_image <- image_append(rows, stack=TRUE)
image_write(full_image, path = destfile, format = "png")


