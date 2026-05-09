Fernerkundung in der Landschaftsplanung - Tag 8 - Change Vector Analyse

**Autoren:** Dieses Tutorial wurde von Fabian Fassnacht entwickelt.


### Lernziele

Während diesem Tutorial werden Sie lernen wie man eine Change Vector Analyse in R durchführt. Darüber hinaus besteht dieses Mal die Hauptaufgabe darin den zur Verfügung gestellten Code selbst zu verstehen und zu kommentieren - sie können dabei unter anderem auch auf die Hilfefunktion von R zurückgreifen.

### Daten

Die für dieses Tutorial benötigten Daten können Sie hier herunterladen:

Laden sie die gepackte Datei herunter und entpacken Sie sie in einen Ordner, den sie wieder finden können.


### Change Vector Analyse

Unten finden Sie den gesamten Code für die Analyse des heutigen Tages. Kopieren Sie diesen nach RStudio und versuchen Sie den Code basierend auf den zur Verfügung gestellten Daten zum laufen zu bringen. 

Sie sehen, dass an den meisten Code-Schnipsel eine # zu sehen ist, ohne das danach ein Erläuterung erfolgt. Die Aufgabe in diesem Tutorial ist es diese Erläuterungen selbst zu ergänzen.

Ziel ist es am Schluss ein Tutorial zu haben, welches den Tutorials der vergangenen Wochen ähnelt. D.h., Sie sollen sowohl den Code kommentieren, als auch die entsprechenden Outputs mit Screenshots abspeichern.

Bis auf die gegen Ende des Code-Skripts zu findende Change Vektor Analyse - Funktion **cva()** - sollten sie alle verwendeten Befehle und Funktionen bereits aus den früheren Tutorials kennen.

Im Zweifel nutzen Sie die früheren Tutorials und schauen Sie sich die Erläuterungen dort nochmal an. Alternativ können Sie auch die Hilfe-Funktion in R verwenden. Wenn Sie z.B. mehr information zur Funktion **cva()** erhalten wollen, können sie in R folgenden Code eingeben:

	?cva

Die sollte dann die für diese Funktion zur Verfügung stehende Hilfedatei öffnen. 

Hier kommt nun der Code für heute:

	# Dieser Schritt muss nur beim ersten mal durchgeführt werden, danach kann man diese zwei Zeilen löschen oder auskommentieren
	require(devtools)
	install_github("bleutner/RStoolbox")

	#
	require(terra)
	require(RStoolbox)

	#
	lapalma <- vect("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/la_palma.gpkg")

	#
	bands_pre <- list.files("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/LS_pre_eruption/bands/", pattern=".TIF$", full.names = T)
	bands_post <- list.files("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/LS_post_eruption/bands/", pattern=".TIF$", full.names = T)

	#
	ls_pre_big <- rast(bands_pre)
	ls_post_big <- rast(bands_post)

	#
	plotRGB(ls_pre_big, r=3, g=2, b=1, stretch="lin")
	plotRGB(ls_post_big, r=3, g=2, b=1, stretch="lin")

	#
	ls_pre <- crop(ls_pre_big, lapalma)
	ls_post <- crop(ls_post_big, lapalma)

	#
	plotRGB(ls_pre, r=3, g=2, b=1, stretch="lin")
	plotRGB(ls_post, r=3, g=2, b=1, stretch="lin")

	#
	setwd("E:/188_BOKU/02_Lehre/OEKB100130_Remote_Sensing_Landscape_Planning/02_Uebungen/Tag_8/")

	#
	writeRaster(ls_pre, filename = "pre_eruption.tif", overwrite=T)
	writeRaster(ls_post, filename = "post_eruption.tif", overwrite=T)

	#
	red_pre <- ls_pre[[3]]
	nir_pre <- ls_pre[[4]]
	swir1_pre <- ls_pre[[5]]

	#
	red_post <- ls_post[[3]]
	nir_post <- ls_post[[4]]
	swir1_post <- ls_post[[5]]
	
	#
	ndvi_pre <- (nir_pre-red_pre) / (nir_pre+red_pre)
	ndli_pre <- (swir1_pre - nir_pre) / (swir1_pre + nir_pre)

	#
	ndvi_post <- (nir_post-red_post) / (nir_post+red_post)
	ndli_post <- (swir1_post - nir_post) / (swir1_post + nir_post)

	#
	writeRaster(ndvi_pre, filename = "pre_ndvi.tif", overwrite=T)
	writeRaster(ndvi_post, filename = "post_ndvi.tif", overwrite=T)
	writeRaster(ndli_pre, filename = "pre_ndli.tif", overwrite=T)
	writeRaster(ndli_post, filename = "post_ndli.tif", overwrite=T)

	#
	time1 <- c(ndvi_pre, ndli_pre)
	time2 <- c(ndvi_post, ndli_post)

	#
	cva <- rasterCVA(time1, time2, tmf=2)

	#
	plot(cva)

	#
	writeRaster(cva[[1]], filename="change_angle.tif")
	writeRaster(cva[[2]], filename="change_magnitude.tif")

	#
	magn <- cva[[2]]

	#
	magn_mask <- magn > 0.15

	#
	magn_masked <- mask(magn, magn_mask, maskvalue=0)

	#
	plot(magn_masked, zlim=c(0,2))


### Hausaufgabe

Geben Sie das von Ihnen verfasste Tutorial für den obenstehenden Code mit Abbildungen als Word-Datei oder PDF ab. Sie haben dafür zwei Wochen Zeit. Dies ist auch gleichzeitig die letzte Hausaufgabe. Nächste Woche werden wir noch ein Tutorial mit einer kleinen Einführung in die Verarbeitung von Laserscanningdaten in R bearbeiten.

Ab der darauffolgenden Woche können Sie die Übungen dafür verwenden an der finalen Abgabe zu arbeiten und Rückfragen zu stellen.
