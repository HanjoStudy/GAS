\name{UniGASSim}
\alias{UniGASSim}
\title{
	Simulate Univariate GAS processes
}
\description{
	Simulate Univariate GAS processes.
}
\usage{
UniGASSim(T.sim, kappa, A, B, Dist, ScalingType)
}
\arguments{
\item{T.sim}{
\code{numeric} Length of the simulated time series.}
%
\item{kappa}{
\code{numeric} Vector of unconditional level for the reparametrised vector of parameters.}
%

\item{A}{
\code{matrix} Of coefficients of dimension K x K that premultiply the conditional score in the GAS updating recursion, see Details.}
%

\item{B}{
\code{matrix} Of autoregressive coefficients of dimension K x K, see Details.}
%
\item{Dist}{
\code{character} Label of the conditional distribution, see \link{DistInfo}.}
%
\item{ScalingType}{
\code{character} Indicating the scaling mechanism for the conditional score. Possible choices are \code{"Identity"}, \code{"Inv"}, \code{"InvSqrt"}. Note that, for some distribution only \code{ScalingType = "Identity"} is supported, see the function \link{DistInfo}. When \code{ScalingType = "InvSqrt"} the inverse of the Cholesky decomposition of the information matrix is used. Default value \code{ScalingType = "Identity"}.}
%
}
\details{
	All the information regarding the supported univariate conditional distributions can be investigated using the \link{DistInfo} function. The model is specified as \deqn{y_{t}\sim p(y|\theta_{t})}, where \eqn{\theta_{t}} is the vector of parameters for the density \eqn{p(y|.)}. Note that, \eqn{\theta_{t}} includes also those parameters that are not time-varying. The GAS recursion for \eqn{\theta_{t}} is \deqn{\theta_{t} = \Lambda(\tilde{\theta}_{t})},\deqn{\tilde{\theta}_{t}=\kappa + A*s_{t-1} + B*\tilde{\theta}_{t-1}}, where \eqn{\Lambda(.)} is the mapping function (see \link{UniMapParameters}) and \eqn{\tilde{\theta}_{t}} is the vector of reparametrised parameters. The process is initialized at \eqn{\theta_{1}=(I - B)^{-1}\kappa}, where \eqn{\kappa} is the \code{vKappa} vector. The vector \eqn{s_{t}} is the scaled score of \eqn{p(y|.)} with respect to \eqn{\tilde{\theta}_{t}}. See Ardia et. al. (2016) for further details.
}
\value{
An object of the class \link{uGASSim}.
}
\references{
Ardia D, Boudt K and Catania L (2016). "Generalized Autoregressive Score Models in R: The GAS Package." Available at SSRN: \url{http://ssrn.com/abstract=2825380}.\cr
%

Creal D, Koopman SJ, Lucas A (2013). "Generalized Autoregressive Score Models with Applications." Journal of Applied Econometrics, 28(5), 777-795. \doi{10.1002/jae.1279}.\cr
%

Harvey AC (2013). Dynamic Models for Volatility and Heavy Tails: With Applications to Financial and Economic Time Series. Cambridge University Press.\cr
}
\author{Leopoldo Catania}
\examples{
# Simulate from a GAS process with Student-t conditional
# distribution, time-varying location, scale and fixed shape parameter.

library(GAS)

set.seed(786)

T.sim  = 1000 # number of observations to simulate
Dist   = "std" # conditional Studen-t distribution


# vector of unconditional reparametrised parameters such that, the unconditional level of
# \eqn{\theta}_{t} is (0, 1.5 ,7), i.e. location = 0, scale = 1.5,
# degrees of freedom = 7.

kappa = c(0.0, log(1.5), log(7-2.01))

# in this way we specify that the shape parameter is constant while the score
# coefficients for the location and the scale
# parameters are 0.001 and 0.01, respectively.

A     = matrix(c(0.001 , 0.0  , 0.0 ,
                  0.0   , 0.01 , 0.0 ,
                  0.0   , 0.0  , 0.0 ), 3, byrow = TRUE)

B = matrix(c(0.7 , 0.0 , 0.0 ,
              0.0 , 0.98, 0.0 ,
              0.0 , 0.0 , 0.0),3,byrow = TRUE) # Matrix of autoregressive parameters.

Sim = UniGASSim(T.sim, kappa, A, B, Dist, ScalingType = "Identity")

Sim

}
