library(EBImage)
setwd("/Users/khozzy/dental-x-rays/")

img_orig = readImage("images/7.tif") # Read TIFF file
img = resize(img_orig, 256,256) # Resize image to 256x256 pixels
rm(img_orig) # Remove original variable (due to big size)

img = channel(img, "grey") # Convert image to grayscale using uniform 1/3 RGB

#Remove unneccessary part
img_zoom <- img[20:200, 50:150]

# Thresholding + morphological operations
img_binary <- opening(img_zoom > 0.89);
#img_binary <- opening(thresh(img_zoom, 25, 25, 0.38)) # Adaptive Thresholding

y <- distmap(img_binary)

# Segmentation
#fillings <- bwlabel(img_binary)
fillings <- watershed(y, 1, 1)
cat('Number of fillings =', max(fillings),'\n')

img_zoom_color <- channel(img_zoom, "rgb")
objects <- paintObjects(fillings, img_zoom_color, col='#ff0000')

# Merge fillings with original image
final <- img
final[20:200, 50:150] <- objects[,,3]

img_comb <- combine(
  img, 
  resize(img_zoom, 256, 256), 
  resize(img_binary, 256, 256),
  resize(objects[,,3], 256, 256),
  final) # displays combination of images

display(img_comb, method = "raster", all = TRUE) # Display the image combination in grayscale
#display(objects, method = "raster") # Display the fillings in red color