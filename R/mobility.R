# Preparasi: aktifkan paket dan impor data --------------------------------

library(ggplot2)
library(scales)
library(gghighlight)

load("data/indonesia_mobility.rda")


# Tugas 1: Mobilitas Masyarakat Indonesia ---------------------------------

indonesia_mobility_plot <-
  ggplot(data = indonesia_mobility) +
  geom_tile(aes(x = date, y = province, fill = pct_changes),
    colour = "white"
  ) +
  geom_vline(
    xintercept = as.Date("2020-03-02"),
    linetype = "dashed",
    colour = "firebrick"
  ) +
  scale_fill_distiller(
    palette = "Spectral",
    limits = c(-0.8, 0.8),
    labels = scales::percent_format(),
    guide = guide_colorbar(
      barwidth = unit(250, "mm"),
      barheight = unit(3, "mm"),
      title.position = "bottom",
      title.hjust = 0.5
    )
  ) +
  labs(
    x = NULL,
    y = NULL,
    fill = "PERSENTASE PERUBAHAN MOBILITAS",
    title = "MOBILITAS MASYARAKAT INDONESIA SELAMA PANDEMI COVID-19",
    subtitle = "GARIS VERTIKAL BERWARNA MERAH MENUNJUKAN TANGGAL KEMUNCULAN KASUS POSITIF PERTAMA",
    caption = "SUMBER DATA: GOOGLE COVID-19 COMMUNITY MOBILITY REPORTS"
  ) +
  facet_wrap(~category) +
  theme_ft_rc(
    base_size = 12,
    plot_title_size = 30,
    axis_text_size = 5,
    grid = FALSE
  ) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    strip.text = element_text(face = "bold", hjust = 0.5),
    legend.position = "bottom"
  )

ggsave(
  "outfile/indonesia_mobility.png",
  plot = indonesia_mobility_plot,
  width = 13,
  height = 8,
  dpi = 300
)


# Tugas 2: Mobilitas Masyarakat Jawa Barat --------------------------------

jabar_mobility_plot <-
  ggplot(data = subset(indonesia_mobility, province == "West Java")) +
  geom_line(aes(date, pct_changes, group = category),
    size = 1.2,
    colour = ft_cols$red
  ) +
  geom_vline(
    xintercept = as.Date("2020-03-02"),
    linetype = "dashed",
    colour = "firebrick"
  ) +
  gghighlight(unhighlighted_params = list(colour = ft_cols$slate, alpha = 0.3, size = 0.8), use_direct_label = FALSE) +
  scale_y_percent(limits = c(-0.8, 0.8), sec.axis = dup_axis(name = NULL)) +
  labs(
    x = NULL,
    y = "PERSENTASE PERUBAHAN MOBILITAS",
    title = "MOBILITAS MASYARAKAT JAWA BARAT SELAMA PANDEMI COVID-19",
    subtitle = "GARIS VERTIKAL BERWARNA MERAH MENUNJUKAN TANGGAL KEMUNCULAN KASUS POSITIF PERTAMA",
    caption = "SUMBER DATA: GOOGLE COVID-19 COMMUNITY MOBILITY REPORTS"
  ) +
  facet_wrap(~category) +
  theme_ft_rc(
    base_size = 12,
    plot_title_size = 30,
    grid = FALSE,
    ticks = TRUE
  ) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    strip.text = element_text(face = "bold", hjust = 0.5)
  )

ggsave(
  "outfile/jabar_mobility.png",
  plot = jabar_mobility_plot,
  width = 13,
  height = 8,
  dpi = 300
)
