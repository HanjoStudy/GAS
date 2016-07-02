\name{mGASRoll}
\Rdversion{0.1}
\docType{class}
\alias{mGASRoll}
\title{class: Class for the Multivariate GAS Rolling object}
\description{
Class for the Multivariate GAS Rolling object.
}
\section{Objects from the Class}{A virtual Class: No objects may be created from it.}
\section{Extends}{

}
\section{Slots}{
  \itemize{
    \item \code{Forecast} Object of class \code{"list"}. Contains forecasts:
    \itemize{
\item PointForecast : \code{matrix} with parameters forecasts.
\item Moments : \code{list} with centered moments forecasts. The first element contains a \code{matrix} with the predicted conditional means. The second element contains an \code{array} with the predicted conditional covariances.
\item vLS : \code{numeric} Log Score (Predictive Log Likelihood)
}
%
\item \code{Info}: \code{list} with forecast information.
\item \code{Data}: \code{list} with original data.
}
}
\section{Methods}{
\itemize{
\item show \code{signature(object = "uGASFor")}: Show summary.
\item plot \code{ signature(x='uGASFor',y='missing')}: Plot forecasted quantities.
\item getForecast \code{signature(object = "uGASFor")}: Extract parameters forecast.
\item getObs \code{signature(object = "uGASFor")}: Extract original observations
\item getMoments \code{signature(object = "uGASFor")}: Extract moments forecasts.
\item LogScore \code{signature(object = "uGASFor")}: Extract Log Scores.
}
}
\author{ Leopoldo Catania}
\note{ }
\keyword{classes}