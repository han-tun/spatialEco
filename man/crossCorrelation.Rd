% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crossCorrelation.R
\name{crossCorrelation}
\alias{crossCorrelation}
\title{Spatial cross correlation}
\usage{
crossCorrelation(
  x,
  y = NULL,
  coords = NULL,
  w = NULL,
  type = c("LSCI", "GSCI"),
  k = 1000,
  dist.function = "inv.power",
  scale.xy = TRUE,
  scale.partial = FALSE,
  scale.matrix = FALSE,
  alpha = 0.05,
  clust = TRUE,
  return.sims = FALSE
)
}
\arguments{
\item{x}{Vector of x response variables}

\item{y}{Vector of y response variables, if not specified the 
univariate  statistic is returned}

\item{coords}{A matrix of coordinates corresponding to [x,y], only 
used if k = NULL. Can also be an sp object with relevant 
x,y coordinate slot (ie., points or polygons)}

\item{w}{Spatial neighbors/weights in matrix format. Dimensions 
must match [n(x),n(y)] and be symmetrical. If w is not defined 
then a default method is used.}

\item{type}{c("LSCI","GSCI") Return Local Spatial Cross-correlation Index (LSCI) 
or Global Spatial cross-correlation Index (GSCI)}

\item{k}{Number of simulations for calculating permutation distribution
under the null hypothesis of no spatial autocorrelation}

\item{dist.function}{("inv.power", "neg.exponent") If w = NULL, the default method 
for deriving spatial weights matrix, options are: inverse power 
or negative exponent}

\item{scale.xy}{(TRUE/FALSE) scale the x,y vectors, if FALSE it is assumed that
they are already scaled following Chen (2015)}

\item{scale.partial}{(FALSE/TRUE) rescale partial spatial autocorrelation statistics [-1 - 1]}

\item{scale.matrix}{(FALSE/TRUE) If a neighbor/distance matrix is passed, should it 
be scaled using [w/sum(w)]}

\item{alpha}{= 0.05     confidence interval (default is 95 pct)}

\item{clust}{(FALSE/TRUE) Return approximated lisa clusters}

\item{return.sims}{(FALSE/TRUE) Return randomizations vector n = k}
}
\value{
When not simulated k=0, a list containing:
\itemize{
  \item {I} {Global autocorrelation statistic}
  \item {SCI} {A data.frame with two columns representing the xy and yx autocorrelation}
  \item {nsim} {value of NULL to represent p values were derived from observed data (k=0)}
  \item {p} {Probability based observations above/below confidence interval}
  \item {t.test} {Probability based on t-test}
  \item {clusters} {If "clust" argument TRUE, vector representing LISA clusters}
}

when simulated (k>0), a list containing: 
\itemize{
  \item {I} {Global autocorrelation statistic}
  \item {SCI} {A data.frame with two columns representing the xy and yx autocorrelation}
  \item {nsim} {value representing number of simulations}
  \item {global.p} {p-value of global autocorrelation statistic}
  \item {local.p} {Probability based simulated data using successful rejection of t-test}
  \item {range.p} {Probability based on range of probabilities resulting from paired t-test}
  \item {clusters} {If "clust" argument TRUE, vector representing lisa clusters}
}
}
\description{
Calculates univariate or bivariate spatial cross-correlation using  
             local Moran's-I (LISA), following Chen (2015)
}
\examples{
\donttest{
  library(sp)
  library(spdep)
   
  data(meuse)
    coordinates(meuse) <- ~x+y  
 
  #### Providing a neighbor contiguity spatial weights matrix
  all.linked <- max(unlist(nbdists(knn2nb(knearneigh(coordinates(meuse))), 
                    coordinates(meuse))))  
  nb <- nb2listw(dnearneigh(meuse, 0, all.linked), style = "B", zero.policy = TRUE)  
    Wij <- as.matrix( as(nb, "symmetricMatrix") ) 	
   I <- crossCorrelation(meuse$zinc, meuse$copper, w = Wij, 
                           clust=TRUE, k=99) 
    meuse$lisa <-  I$SCI[,"lsci.xy"]
   spplot(meuse, "lisa")
   #meuse$lisa.clust <- as.factor(I$cluster)
     #spplot(meuse, "lisa.clust") 
   
  #### Using a default spatial weights matrix method (inverse power function)
  I <- crossCorrelation(meuse$zinc, meuse$copper, coords = coordinates(meuse), 
                          clust = TRUE, k=99)
    meuse$lisa <- I$SCI[,"lsci.xy"]
      spplot(meuse, "lisa")
    #meuse$lisa.clust <- as.factor(I$cluster)
    #  spplot(meuse, "lisa.clust")	  
} 

}
\references{
Chen., Y. (2015) A New Methodology of Spatial Cross-Correlation Analysis. 
  PLoS One 10(5):e0126158. doi:10.1371/journal.pone.0126158
}
