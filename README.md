GOES 16 Image Tile Fetcher
-----------------------------
Fetches most recent full-disk images of the earth from the GOES16 geostationary satellite then formats the tiled image data to work as a desktop background. 

Use the batch file and Windows' task scheduler to regularly run the R script. Set your desktop wallpaper mode to "Gallery",
choosing the directory where the R script dumps the stitched images. Set your wallpaper to change every 15 minutes (or less). Tada! Live-ish wallpaper of the Earth from space!

The R script scrapes the image data from RAMMB/CIRA - SLIDER (see http://rammb-slider.cira.colostate.edu) Many thanks to them for making the data publically available! 

I had originally hoped to build a fancy SDR and antenna setup to download the data directly from the GOES-16, but that's hard to do with no space for a 1.5-meter dish antenna. 
