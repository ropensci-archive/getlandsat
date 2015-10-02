getlandsat
======



[![Build Status](https://travis-ci.org/sckott/getlandsat.svg?branch=master)](https://travis-ci.org/sckott/getlandsat)

__Get Landsat 8 data from AWS public data sets__

## Install non-CRAN dependencies


```r
devtools::install_github('hadley/readr')
devtools::install_github('cloudyr/aws.signature')
devtools::install_github('cloudyr/aws.s3')
```

## Install


```r
devtools::install_github("sckott/getlandsat")
```


```r
library("getlandsat")
```

## List scenes


```r
(res <- lsat_scenes(n_max = 10))
#>                 entityId     acquisitionDate cloudCover processingLevel
#> 1  LC80101172015002LGN00 2015-01-02 15:49:05      80.81            L1GT
#> 2  LC80260392015002LGN00 2015-01-02 16:56:51      90.84            L1GT
#> 3  LC82270742015002LGN00 2015-01-02 13:53:02      83.44            L1GT
#> 4  LC82270732015002LGN00 2015-01-02 13:52:38      52.29             L1T
#> 5  LC82270622015002LGN00 2015-01-02 13:48:14      38.85             L1T
#> 6  LC82111152015002LGN00 2015-01-02 12:30:31      22.93            L1GT
#> 7  LC81791202015002LGN00 2015-01-02 09:14:45       7.67            L1GT
#> 8  LC82111112015002LGN00 2015-01-02 12:28:55      43.43            L1GT
#> 9  LC81950292015002LGN00 2015-01-02 10:17:20      21.02             L1T
#> 10 LC81790452015002LGN00 2015-01-02 08:44:49       1.92             L1T
#>    path row   min_lat    min_lon   max_lat    max_lon
#> 1    10 117 -79.09923 -139.66082 -77.75440 -125.09297
#> 2    26  39  29.23106  -97.48576  31.36421  -95.16029
#> 3   227  74 -21.28598  -59.27736 -19.17398  -57.07423
#> 4   227  73 -19.84365  -58.93258 -17.73324  -56.74692
#> 5   227  62  -3.95294  -55.38896  -1.84491  -53.32906
#> 6   211 115 -78.54179  -79.36148 -75.51003  -69.81645
#> 7   179 120 -82.84799  -65.43056 -79.86348  -54.33202
#> 8   211 111 -73.85499  -65.85500 -70.55727  -59.24916
#> 9   195  29  43.48235    5.34729  45.65222    8.42201
#> 10  179  45  20.58917   24.04269  22.71410   26.29556
#>                                                                                  download_url
#> 1  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/010/117/LC80101172015002LGN00/index.html
#> 2  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/026/039/LC80260392015002LGN00/index.html
#> 3  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/227/074/LC82270742015002LGN00/index.html
#> 4  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/227/073/LC82270732015002LGN00/index.html
#> 5  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/227/062/LC82270622015002LGN00/index.html
#> 6  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/211/115/LC82111152015002LGN00/index.html
#> 7  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/179/120/LC81791202015002LGN00/index.html
#> 8  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/211/111/LC82111112015002LGN00/index.html
#> 9  https://s3-us-west-2.amazonaws.com/landsat-pds/L8/195/029/LC81950292015002LGN00/index.html
#> 10 https://s3-us-west-2.amazonaws.com/landsat-pds/L8/179/045/LC81790452015002LGN00/index.html
```

## List scene files


```r
lsat_scene_files(x = res$download_url[1])
#>                                 file    size
#> 2   LC80101172015002LGN00_B4.TIF.ovr   7.7MB
#> 26 LC80101172015002LGN00_B11.TIF.ovr  17.0KB
#> 3       LC80101172015002LGN00_B5.TIF  56.8MB
#> 4      LC80101172015002LGN00_BQA.TIF   2.7MB
#> 5      LC80101172015002LGN00_MTL.txt   7.5KB
#> 6   LC80101172015002LGN00_B5.TIF.ovr   7.8MB
#> 7   LC80101172015002LGN00_B2.TIF.ovr   7.5MB
#> 8   LC80101172015002LGN00_B1.TIF.ovr   7.5MB
#> 9   LC80101172015002LGN00_B7.TIF.ovr   7.9MB
#> 10      LC80101172015002LGN00_B4.TIF  55.4MB
#> 11      LC80101172015002LGN00_B8.TIF 212.3MB
#> 12  LC80101172015002LGN00_B3.TIF.ovr   7.6MB
#> 13      LC80101172015002LGN00_B3.TIF  54.4MB
#> 14      LC80101172015002LGN00_B2.TIF  54.0MB
#> 15 LC80101172015002LGN00_B10.TIF.ovr  17.0KB
#> 16  LC80101172015002LGN00_B6.TIF.ovr   7.9MB
#> 17  LC80101172015002LGN00_B9.TIF.ovr   7.0MB
#> 18     LC80101172015002LGN00_B11.TIF   0.1MB
#> 19  LC80101172015002LGN00_B8.TIF.ovr  29.0MB
#> 20      LC80101172015002LGN00_B1.TIF  54.2MB
#> 21     LC80101172015002LGN00_B10.TIF   0.1MB
#> 22      LC80101172015002LGN00_B6.TIF  58.0MB
#> 23 LC80101172015002LGN00_BQA.TIF.ovr   0.6MB
#> 24      LC80101172015002LGN00_B7.TIF  58.0MB
#> 25      LC80101172015002LGN00_B9.TIF  49.6MB
```

## Get an image

Returns path to the image


```r
lsat_image(x = "LC80101172015002LGN00_B5.TIF")
#> [1] "~/.landsat-pds/L8/010/117/LC80101172015002LGN00/LC80101172015002LGN00_B5.TIF"
```

### Caching

When requesting an image, we first check if you already have that image. If you do, 
we return the path to the file. If not, we get the image, and return the file path.


```r
lsat_image(x = "LC80101172015002LGN00_B5.TIF")
#> File in cache
#> [1] "~/.landsat-pds/L8/010/117/LC80101172015002LGN00/LC80101172015002LGN00_B5.TIF"
```

Note the message given.

See `?lsat_cache` for cache management functions.

## Meta

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
