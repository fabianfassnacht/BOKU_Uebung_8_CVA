#require(devtools)
#install_github("bleutner/RStoolbox")

require(terra)
require(RStoolbox)

lapalma <- vect("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/la_palma.gpkg")

bands_pre <- list.files("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/LS_pre_eruption/bands/", pattern=".TIF$", full.names = T)
bands_post <- list.files("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/LS_post_eruption/bands/", pattern=".TIF$", full.names = T)

ls_pre_big <- rast(bands_pre)
ls_post_big <- rast(bands_post)

plotRGB(ls_pre_big, r=3, g=2, b=1, stretch="lin")
plotRGB(ls_post_big, r=3, g=2, b=1, stretch="lin")

ls_pre <- crop(ls_pre_big, lapalma)
ls_post <- crop(ls_post_big, lapalma)

plotRGB(ls_pre, r=3, g=2, b=1, stretch="lin")
plotRGB(ls_post, r=3, g=2, b=1, stretch="lin")

setwd("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/")

writeRaster(ls_pre, filename = "pre_eruption.tif", overwrite=T)
writeRaster(ls_post, filename = "post_eruption.tif", overwrite=T)

red_pre <- ls_pre[[3]]
nir_pre <- ls_pre[[4]]
swir1_pre <- ls_pre[[5]]

red_post <- ls_post[[3]]
nir_post <- ls_post[[4]]
swir1_post <- ls_post[[5]]

ndvi_pre <- (nir_pre-red_pre) / (nir_pre+red_pre)
ndli_pre <- (swir1_pre - nir_pre) / (swir1_pre + nir_pre)

ndvi_post <- (nir_post-red_post) / (nir_post+red_post)
ndli_post <- (swir1_post - nir_post) / (swir1_post + nir_post)

writeRaster(ndvi_pre, filename = "pre_ndvi.tif", overwrite=T)
writeRaster(ndvi_post, filename = "post_ndvi.tif", overwrite=T)
writeRaster(ndli_pre, filename = "pre_ndli.tif", overwrite=T)
writeRaster(ndli_post, filename = "post_ndli.tif", overwrite=T)

time1 <- c(ndvi_pre, ndli_pre)
time2 <- c(ndvi_post, ndli_post)

cva <- rasterCVA(time1, time2, tmf=2)

plot(cva)

writeRaster(cva[[1]], filename="change_angle.tif")
writeRaster(cva[[2]], filename="change_magnitude.tif")

magn <- cva[[2]]

magn_mask <- magn > 0.15

magn_masked <- mask(magn, magn_mask, maskvalue=0)

plot(magn_masked, zlim=c(0,2))
