% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shannon.evaluate.core.R
\name{shannon.evaluate.core-deprecated}
\alias{shannon.evaluate.core-deprecated}
\title{Shannon-Weaver Diversity Index}
\usage{
shannon.evaluate.core(data, names, qualitative, selected)
}
\value{
A data frame with the following columns. \item{Trait}{The qualitative
  trait.} \item{EC_H}{The Shannon-Weaver Diversity Index (\mjseqn{H'}) for
  EC.} \item{EC_H}{The Shannon-Weaver Diversity Index (\mjseqn{H'}) for CS.}
  \item{EC_Hmax}{The Maximum diversity value (\mjseqn{H'_{max}}) for EC.}
  \item{CS_Hmax}{The Maximum diversity value (\mjseqn{H'_{max}}) for CS.}
  \item{EC_EH}{The Shannon Equitability Index (\mjseqn{E_{H}}) for EC.}
  \item{CS_EH}{The Shannon Equitability Index (\mjseqn{E_{H}}) for CS.}
}
\description{
Compute the Shannon-Weaver Diversity Index (\mjseqn{H'}), Maximum diversity
(\mjseqn{H'_{max}}) and Shannon Equitability Index (\mjseqn{E_{H}})
\insertCite{shannon_mathematical_1949}{EvaluateCore} to compare the
phenotypic diversity for qualitative traits between entire collection (EC)
and core set (CS). \loadmathjax
}
\details{
Shannon-Weaver Diversity Index (\mjseqn{H'}) is computed as follows.

\mjsdeqn{H' = -\sum_{i=1}^{k}p_{i} \ln(p_{i})}

Where \mjseqn{p_{i}} denotes the proportion in the group \mjseqn{k}.

The maximum value of the index (\mjseqn{H'_{max}}) is \mjseqn{\ln(k)}. This
value occurs when each group has the same frequency.

The Shannon equitability index (\mjseqn{E_{H}}) is the Shannon diversity
index divided by the maximum diversity.

\mjsdeqn{E_{H} = \frac{H'}{\ln{(k)}}}
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

shannon.evaluate.core(data = ec, names = "genotypes",
                      qualitative = qual, selected = core)

}
\references{
\insertAllCited{}
}
\seealso{
\code{\link[psych:misc]{shannon}}

\code{\link{EvaluateCore-deprecated}}
}
\keyword{internal}
