% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dist.evaluate.core.R
\name{dist.evaluate.core}
\alias{dist.evaluate.core}
\title{Distance Measures}
\usage{
dist.evaluate.core(data, names, quantitative, qualitative, selected, d = NULL)
}
\arguments{
\item{data}{The data as a data frame object. The data frame should possess
one row per individual and columns with the individual names and multiple
trait/character data.}

\item{names}{Name of column with the individual names as a character string}

\item{quantitative}{Name of columns with the quantitative traits as a
character vector.}

\item{qualitative}{Name of columns with the qualitative traits as a character
vector.}

\item{selected}{Character vector with the names of individuals selected in
core collection and present in the \code{names} column.}

\item{d}{A distance matrix of class "\code{dist}" with individual names in
the \code{names} column in {data} as labels. If \code{NULL} (default),
then a distance matrix is computed using Gower's metric.
\insertCite{gowerGeneralCoefficientSimilarity1971}{EvaluateCore}.}
}
\value{
A data frame with the average values of
  \ifelse{html}{\out{<em>E-NE</em>}}{\eqn{E\textnormal{-}EN}},
  \ifelse{html}{\out{<em>A-NE</em>}}{\eqn{A\textnormal{-}EN}} and
  \ifelse{html}{\out{<em>E-E</em>}}{\eqn{E\textnormal{-}E}}.
}
\description{
Compute average Entry-to-nearest-entry distance
(\ifelse{html}{\out{<em>E-NE</em>}}{\eqn{E\textnormal{-}EN}}),
Accession-to-nearest-entry distance
(\ifelse{html}{\out{<em>A-NE</em>}}{\eqn{A\textnormal{-}EN}}) and
Entry-to-entry distance
(\ifelse{html}{\out{<em>E-E</em>}}{\eqn{E\textnormal{-}E}})
\insertCite{odong_quality_2013}{EvaluateCore} to evaluate a core set (CS)
selected from an entire collection (EC).
}
\examples{

####################################
# Use data from R package ccChooser
####################################

library(ccChooser)
data("dactylis_CC")
data("dactylis_EC")

ec <- cbind(genotypes = rownames(dactylis_EC), dactylis_EC[, -1])
ec$genotypes <- as.character(ec$genotypes)
rownames(ec) <- NULL
ec[, c("X1", "X6", "X7")] <- lapply(ec[, c("X1", "X6", "X7")],
                                    function(x) cut(x, breaks = 4))
ec[, c("X1", "X6", "X7")] <- lapply(ec[, c("X1", "X6", "X7")],
                                    function(x) factor(as.numeric(x)))
head(ec)

core <- rownames(dactylis_CC)

quant <- c("X2", "X3", "X4", "X5", "X8")
qual <- c("X1", "X6", "X7")

####################################
# EvaluateCore
####################################

dist.evaluate.core(data = ec, names = "genotypes", quantitative = quant,
                   qualitative = qual, selected = core)

\donttest{
####################################
# Compare with corehunter
####################################

library(corehunter)
# Prepare phenotype dataset
dtype <- c(rep("RD", length(quant)),
           rep("NS", length(qual)))
rownames(ec) <- ec[, "genotypes"]
ecdata <- corehunter::phenotypes(data = ec[, c(quant, qual)],
                                 types = dtype)

# Compute average distances
EN <- evaluateCore(core = rownames(dactylis_CC), data = ecdata,
                   objective = objective("EN", "GD"))
AN <- evaluateCore(core = rownames(dactylis_CC), data = ecdata,
                   objective = objective("AN", "GD"))
EE <- evaluateCore(core = rownames(dactylis_CC), data = ecdata,
                   objective = objective("EE", "GD"))
EN
AN
EE
}

}
\references{
\insertAllCited{}
}
\seealso{
\code{\link[corehunter]{evaluateCore}}
}
