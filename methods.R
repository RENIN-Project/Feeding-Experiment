library(matrixStats)
library(vctrs)

reads_per_sample <- function(data) {
  rowSums(data@reads)
}

reads_per_motus <- function(data) {
  colSums(data@reads)
}

max_per_motus <- function(data) {
  apply(data@reads,MARGIN = 2,FUN = max)
}

clean_empty <- function(data) {
  data <- data[which(rowSums(data@reads) > 0),]
  data[,which(colSums(data@reads) > 0)]
}

update_motus_count <- function(data) {
  data@motus$count <- colSums(data@reads,na.rm = TRUE)
  invisible(data)
}

update_samples_count <- function(data) {
  data@samples$count <- rowSums(data@reads,na.rm = TRUE)
  invisible(data)
}

hill_numbers <- function(object, q = 1, na.rm = TRUE) {
  na <- is.na(object)
  if (any(na)) {
    if (na.rm) {
      object <- object[!na]
    } else {
      return(NA_real_)
    }
  }

  object <- object[object > 0]
  object <- object / sum(object)

  lfreq <- log(object)

  if (q != 1) {
    exp(logSumExp(lfreq * q) / (1 - q))
  } else {
    exp(-sum(exp(lfreq) * lfreq))
  }
}

diversity_per_sample <- function(data, q = 1, na.rm = TRUE) {
  freq <- decostand(data@reads, method = "total")
  apply(freq, 1, hill_numbers, q = q, na.rm = na.rm)
}

plot_sample_reads_diversity <- function(data, q = 1, categories = "PCR",
                                        density_curve = TRUE,
                                        point_size = 1,
                                        point_alpha = 1,
                                        density_alpha = 0.6) {
  categories <- vec_recycle(categories, nrow(data))

  p <- bind_cols(data@samples) %>%
    tibble(
      .diversity = diversity_per_sample(data,q = q),
      .read_count = reads_per_sample(data),
      .sample_category = categories
    ) %>%
    ggplot(aes(
      x = .read_count,
      y = .diversity
    ))

  if (density_curve) {
    p <- p +
      geom_density2d(alpha = density_alpha)
  }

  p + geom_point(aes(col = .sample_category),
    size = point_size,
    alpha = point_alpha
  ) +
    scale_x_log10() +
    scale_y_log10() +
    xlab("Read count per PCR") +
    ylab(glue::glue("Hill number diversity (q={q})"))
}

plot_motus_read_bestid <- function(data, categories = "MOTU",
                                   point_size = 1,
                                   point_alpha = 1) {
  categories <- vec_recycle(categories, ncol(data))

  data@motus %>%
    bind_cols(tibble(.max_count = max_per_motus(data),
                     .motus_category = categories)) %>%
    ggplot(aes(
      x = obitag_bestid,
      y = .max_count,
    )) +
    geom_point(aes(col = .motus_category),
      size = point_size,
      alpha = point_alpha
    ) +
    scale_y_log10() +
    ylab("Maximum occurrance per PCR") +
    xlab(glue::glue("Best identity with a reference sequence"))
}
