## Script for Fetching GOES-16 Geocolor full disk images

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

image_list <- list(a,b,c,d,e,f,g,h)


## Destination file
destfile <- "C://Users//Keiran//Documents//full_disk.png"
destfile2 <- "C://Users//Keiran//Documents//GOES16//full_disk_lowres.png"
destfile3 <- "C://Users//Keiran//Documents//GOES16//full_disk_lowres2.png"







## URL includes most recent timestamped image data (credit to Paul Schuster for assistance)
clump1 <- substr(time_code, 1,8)
clump2<- time_code


## Image tile fetch 2x2

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
full_image <- image_append(rows, stack=TRUE)
image_write(full_image, path = destfile2, format = "png")
image_write(full_image, path = destfile3, format = "png")


## Url Format reminder:
## "http://rammb-slider.cira.colostate.edu/data/imagery/20171001/goes-16---full_disk/geocolor/20171001210038/00/000_000.png"
