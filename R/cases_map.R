# Preparasi: aktifkan paket dan impor data --------------------------------

library(ggplot2)
library(hrbrthemes)
library(ggtext)
library(gganimate)
library(glue)

load("data/jabar_basemap.rda")
load("data/jabar_cases.rda")

str(jabar_cases)

# Tugas 1: membuat peta sebaran kasus COVID-19 di Jawa Barat --------------

# Tahapan utama:
# 1. Membuat scatterplot dengan `lng` pada sumbu-x dan `lat` pada sumbu-y
# 2. Membedakan warna titik berdasarkan status (ODP, OTG, PDP, dan Positif)
# 3. Menambahkan judul, sub-judul, dan keterangan grafik
# 4. Menambahkan layer peta dasar
#
# Tahapan tambahan:
# 1. Mengganti warna peta dasar
# 2. Mengganti warna titik berdasarkan status
# 3. Mengganti tema

title_lab <- "PERSEBARAN KASUS COVID-19 DI JAWA BARAT"
subtitle_lab <- "<span style='color:#4682B4'>**KASUS ODP**</span>,  <span style='color:#8B008B'>**KASUS OTG**</span>, <span style='color:#FFD700'>**KASUS PDP**</span>, DAN <span style='color:#B22222'>**KASUS POSITIF**</span>"
caption_lab <- glue("SUMBER DATA: DINAS KESEHATAN PROVINSI JAWA BARAT\nDATA DIPERBAHARUI: {toupper(format(max(jabar_cases[['date']]), format = '%e %B %Y'))}")

jabar_cases_map <-
  ggplot(data = jabar_cases) +
  geom_sf(
    data = jabar_basemap,
    fill = "seagreen3",
    colour = "white",
    size = 0.05
  ) +
  geom_point(aes(x = lng, y = lat, fill = status),
    shape = 21,
    colour = "white",
    size = 2,
    alpha = 0.3,
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c("ODP" = "steelblue", "OTG" = "darkmagenta", "PDP" = "gold", "Positif" = "firebrick")
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = title_lab,
    subtitle = subtitle_lab,
    caption = caption_lab
  ) +
  theme_ipsum_ps(base_size = 12) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_markdown()
  )

ggsave(
  "outfile/jabar_cases_map.png",
  plot = jabar_cases_map,
  width = 8,
  height = 8,
  dpi = 300
)

# Tugas 2: membuat animasi linimasa kemunculan kasus positif --------------

# Tahapan utama:
# 1. Mangambil data dengan status Positif
# 2. Membuat peta sebaran kasus positif
# 3. Membuat animasi dengan frame merupakan tanggal konfirmasi kasus
# 4. Menambahkan judul, sub-judul berupa tanggal (`date`), dan keterangan grafik
#
# Tahapan tambahan:
# 1. Mengganti warna peta dasar,
# 2. Mengganti warna titik
# 3. Mengganti tema

jabar_timelapse <-
  ggplot(data = subset(jabar_cases, status == "Positif")) +
  geom_sf(
    data = jabar_basemap,
    fill = "seagreen3",
    colour = "white",
    size = 0.05
  ) +
  geom_point(
    aes(x = lng, y = lat),
    shape = 21,
    fill = "firebrick",
    colour = "white",
    size = 2,
    alpha = 0.6
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "PERSEBARAN KASUS POSITIF COVID-19 DI JAWA BARAT",
    subtitle = "{toupper(format(as.Date(current_frame), format = '%e %b %Y'))}",
    caption = "SUMBER DATA: DINAS KESEHATAN PROVINSI JAWA BARAT"
  ) +
  theme_ipsum_rc(base_size = 12) +
  theme(plot.title.position = "plot") +
  transition_manual(date, cumulative = TRUE) +
  enter_appear()

anim_save(
  "outfile/jabar_timelapse.gif",
  animation = jabar_timelapse,
  duration = 30,
  fps = 60,
  renderer = gifski_renderer(
    width = 2400,
    height = 2400
  )
)
