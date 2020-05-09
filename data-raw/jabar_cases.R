## code to prepare `jabar_cases` dataset goes here

library(httr)
library(jsonlite)
library(purrr)
library(dplyr)

resp <- GET("https://covid19-public.digitalservice.id/api/v1/sebaran/jabar")

jabar_cases <-
  resp %>%
  content(as = "text") %>%
  fromJSON() %>%
  pluck("data", "content") %>%
  transmute(
    id,
    date = as.Date(tanggal_konfirmasi),
    status,
    stage,
    umur,
    gender,
    kode_kab,
    nama_kab,
    kode_kec,
    nama_kec,
    kode_kel,
    nama_kel,
    lng = longitude,
    lat = latitude
  )

usethis::use_data(jabar_cases, overwrite = TRUE)
