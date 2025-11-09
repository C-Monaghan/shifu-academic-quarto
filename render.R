# Files to render
files_to_render <- tibble::tribble(
  ~file           , ~format       , ~ext  , ~suffix ,
  "shifu-default" , "shifu-typst" , "pdf" , ""      ,
  "shifu-custom"  , "shifu-typst" , "pdf" , ""
)

# Running quarto (outputting to example folder)
files_rendered <- files_to_render |>
  dplyr::rowwise() |>
  dplyr::mutate(
    rendered = purrr::pmap_chr(
      list(file, format, ext, suffix),
      ~ {
        quarto::quarto_render(
          input = paste0(file, ".qmd"),
          output_format = format,
          output_file = paste0(file, suffix, ".", ext)
        )
        return(paste0(file, suffix, ".", ext))
      }
    )
  ) |>
  dplyr::ungroup() |>
  dplyr::mutate(thumbnail_name = stringr::str_replace_all(rendered, "\\.", "-"))

# Creating thumbnail images
files_rendered |>
  dplyr::rowwise() |>
  dplyr::mutate(
    thumbnail = purrr::pmap_chr(
      list(ext, rendered, thumbnail_name),
      ~ {
        magick::image_read_pdf(paste0("pdf-examples/", rendered)) |>
          magick::image_montage(
            geometry = "x2000+25+35",
            tile = 3,
            bg = "grey92",
            shadow = TRUE
          ) |>
          magick::image_convert(format = "png") |>
          magick::image_write(paste0(
            "pdf-examples/thumbnails/",
            thumbnail_name,
            ".png"
          ))
      }
    )
  ) |>
  dplyr::ungroup()
