% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signtest.evaluate.core.R
\name{signtest.evaluate.core}
\alias{signtest.evaluate.core}
\title{Sign Test}
\usage{
signtest.evaluate.core(data, names, quantitative, selected)
}
\arguments{
\item{data}{The data as a data frame object. The data frame should possess
one row per individual and columns with the individual names and multiple
trait/character data.}

\item{names}{Name of column with the individual names as a character string}

\item{quantitative}{Name of columns with the quantitative traits as a
character vector.}

\item{selected}{Character vector with the names of individuals selected in
core collection and present in the \code{names} column.}
}
\value{
A data frame with the following components. \item{Comparison}{The
  comparison measure.} \item{ChiSq}{The test statistic (\mjseqn{\chi^{2}}).}
  \item{p.value}{The p value for the test statistic.} \item{significance}{The
  significance of the test statistic (*: p \mjseqn{\leq} 0.01; **: p
  \mjseqn{\leq} 0.05; ns: p \mjseqn{ > } 0.05).}
}
\description{
Test difference between means and variances of entire collection (EC) and
core set (CS) for quantitative traits by Sign test (\mjseqn{+} versus
\mjseqn{-})
\insertCite{basigalup_development_1995,tai_core_2001}{EvaluateCore}.
\loadmathjax
}
\details{
The test statistic for Sign test (\mjseqn{\chi^{2}}) is computed as follows.

\mjsdeqn{\chi^{2} = \frac{(N_{1}-N_{2})^{2}}{N_{1}+N_{2}}}

Where, where \mjseqn{N_{1}} is the number of variables for which the mean or
variance of the CS is greater than the mean or variance of the EC (number of
\mjseqn{+} signs); \mjseqn{N_{2}} is the number of variables for which the
mean or variance of the CS is less than the mean or variance of the EC
(number of \mjseqn{-} signs). The value of \mjseqn{\chi^{2}} is compared with
a Chi-square distribution with 1 degree of freedom.
}
\examples{

data("cassava_CC")
data("cassava_EC")

ec <- cbind(genotypes = rownames(cassava_EC), cassava_EC)
ec$genotypes <- as.character(ec$genotypes)
rownames(ec) <- NULL

core <- rownames(cassava_CC)

quant <- c("NMSR", "TTRN", "TFWSR", "TTRW", "TFWSS", "TTSW", "TTPW", "AVPW",
           "ARSR", "SRDM")
qual <- c("CUAL", "LNGS", "PTLC", "DSTA", "LFRT", "LBTEF", "CBTR", "NMLB",
          "ANGB", "CUAL9M", "LVC9M", "TNPR9M", "PL9M", "STRP", "STRC",
          "PSTR")

ec[, qual] <- lapply(ec[, qual],
                     function(x) factor(as.factor(x)))

signtest.evaluate.core(data = ec, names = "genotypes",
                       quantitative = quant, selected = core)

}
\references{
\insertAllCited{}
}
