### This file is part of 'EvaluateCore' package for R.

### Copyright (C) 2018-2020, ICAR-NBPGR.
#
# EvaluateCore is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# EvaluateCore is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  https://www.r-project.org/Licenses/


#' Distance Measures
#'
#' Compute average Entry-to-nearest-entry distance
#' (\ifelse{html}{\out{<em>E-NE</em>}}{\eqn{E\textnormal{-}EN}}),
#' Accession-to-nearest-entry distance
#' (\ifelse{html}{\out{<em>A-NE</em>}}{\eqn{A\textnormal{-}EN}}) and
#' Entry-to-entry distance
#' (\ifelse{html}{\out{<em>E-E</em>}}{\eqn{E\textnormal{-}E}})
#' \insertCite{odong_quality_2013}{EvaluateCore} to evaluate a core set (CS)
#' selected from an entire collection (EC).
#'
# #' This function is a wrapper around the
# #' \code{\link[corehunter]{evaluateCore}}
# #' function of the \code{\link[corehunter]{corehunter}} package.
#'
#' @inheritParams snk.evaluate.core
#' @inheritParams chisquare.evaluate.core
#' @param d A distance matrix of class "\code{dist}" with individual names in
#' the \code{names} column in {data} as labels. If \code{NULL} (default),
#' then a distance matrix is computed using Gower's metric.
#' \insertCite{gowerGeneralCoefficientSimilarity1971}{EvaluateCore}.
#'
#' @return A data frame with the average values of
#'   \ifelse{html}{\out{<em>E-NE</em>}}{\eqn{E\textnormal{-}EN}},
#'   \ifelse{html}{\out{<em>A-NE</em>}}{\eqn{A\textnormal{-}EN}} and
#'   \ifelse{html}{\out{<em>E-E</em>}}{\eqn{E\textnormal{-}E}}.
#'
#' @references
#'
#' \insertAllCited{}
#'
#' @seealso \code{\link[corehunter]{evaluateCore}}
#'
# #' @importFrom corehunter evaluateCore
# #' @importFrom corehunter phenotypes
# #' @importFrom corehunter objective
#' @importFrom cluster daisy
#' @export
#'
#' @examples
#'
#' ####################################
#' # Use data from R package ccChooser
#' ####################################
#'
#' library(ccChooser)
#' data("dactylis_CC")
#' data("dactylis_EC")
#'
#' ec <- cbind(genotypes = rownames(dactylis_EC), dactylis_EC[, -1])
#' ec$genotypes <- as.character(ec$genotypes)
#' rownames(ec) <- NULL
#' ec[, c("X1", "X6", "X7")] <- lapply(ec[, c("X1", "X6", "X7")],
#'                                     function(x) cut(x, breaks = 4))
#' ec[, c("X1", "X6", "X7")] <- lapply(ec[, c("X1", "X6", "X7")],
#'                                     function(x) factor(as.numeric(x)))
#' head(ec)
#'
#' core <- rownames(dactylis_CC)
#'
#' quant <- c("X2", "X3", "X4", "X5", "X8")
#' qual <- c("X1", "X6", "X7")
#'
#' ####################################
#' # EvaluateCore
#' ####################################
#'
#' dist.evaluate.core(data = ec, names = "genotypes", quantitative = quant,
#'                    qualitative = qual, selected = core)
#'
#' \donttest{
#' ####################################
#' # Compare with corehunter
#' ####################################
#'
#' library(corehunter)
#' # Prepare phenotype dataset
#' dtype <- c(rep("RD", length(quant)),
#'            rep("NS", length(qual)))
#' rownames(ec) <- ec[, "genotypes"]
#' ecdata <- corehunter::phenotypes(data = ec[, c(quant, qual)],
#'                                  types = dtype)
#'
#' # Compute average distances
#' EN <- evaluateCore(core = rownames(dactylis_CC), data = ecdata,
#'                    objective = objective("EN", "GD"))
#' AN <- evaluateCore(core = rownames(dactylis_CC), data = ecdata,
#'                    objective = objective("AN", "GD"))
#' EE <- evaluateCore(core = rownames(dactylis_CC), data = ecdata,
#'                    objective = objective("EE", "GD"))
#' EN
#' AN
#' EE
#' }
#'
dist.evaluate.core <- function(data, names, quantitative, qualitative,
                               selected, d = NULL) {
  if (missing(quantitative)) {
    quantitative <- NULL
  }

  if (missing(qualitative)) {
    qualitative <- NULL
  }

  if (length(c(quantitative, qualitative)) == 1) {
    stop("Only one trait specified")
  }

  # Checks
  checks.evaluate.core(data = data, names = names,
                       quantitative = quantitative,
                       qualitative = qualitative,
                       selected = selected)

  if (any(c("tbl_dataf", "tbl") %in% class(data))) {
    warning('"data" is of type tibble\nCoercing to data frame')
    data <- as.data.frame(data)
  }

  traits <- c(quantitative, qualitative)
  # # quantitative (RD); qualitative(NS)
  # dtype <- c(rep("RD", length(quantitative)),
  #            rep("NS", length(qualitative)))

  # dataf <- data[, c(names, traits)]
  # rownames(dataf) <- dataf[, names]

  if (!is.null(d)) {
    # check if d is a distance matrix
    if (!("dist" %in% class(d))) {
        stop('Distance matrix "d" is not an object of class "dist".')
    }
    dsize <- as.integer(attr(d, "Size"))
    if (nrow(data) != dsize){
      stop('Dimentions of distance matrix "d" and "data" do not match.')
    }

    if (!(all(labels(d) %in% data[, names]) &
          all(data[, names] %in% labels(d)))) {
      stop('Labels of distance matrix "d" and "data" do not match.')
    }
  } else {
    rownames(data) <- data[,names]
    d <- cluster::daisy(data[,c(quantitative, qualitative)],
                        metric = "gower")
  }

  # # Prep phenotype
  # dataf <- corehunter::phenotypes(data = dataf[, c(quantitative, qualitative)],
  #                                 types = dtype)
  # # Compute average distances
  # EN <- evaluateCore(core = selected, data = dataf,
  #                    objective = objective("EN", "GD"))
  # AN <- evaluateCore(core = selected, data = dataf,
  #                    objective = objective("AN", "GD"))
  # EE <- evaluateCore(core = selected, data = dataf,
  #                    objective = objective("EE", "GD"))

  dmat <- as.matrix(d)
  selind <- which(rownames(dmat) %in% selected)
  subdist <- dmat[selind, selind]

  #EE
  EE <- mean(subdist[upper.tri(subdist)])

  #EN
  EN <- mean(apply(subdist, 1, FUN = function(x) {min(x[x > 0])}))

  #AN
  subdist2 <- dmat[-selind, selind]
  dsize <- as.integer(attr(d, "Size"))
  AN <- sum(apply(subdist2, 1, FUN = function(x) {min(x[x > 0])})) / dsize

  outdf <- data.frame(`Average distance` = c("E-NE", "A-NE", "E-E"),
                     `Value` = c(EN, AN, EE))

  return(outdf)

}
