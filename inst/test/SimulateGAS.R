library(GAS)
## Simulate GAS process

################################
#         UNIVARIATE           #
################################

# norm

iT = 1e4

help(UniUnmapParameters)

A = matrix(c(0.1,0.0,
              0.0,0.4),2)
B = matrix(c(0.9,0.0,
              0.0,0.95),2)

Kappa = (diag(2) - B) %*% UniUnmapParameters(c(0,0.1),"norm")

help(UniGASSim)
Sim = UniGASSim(iT, Kappa, A, B, Dist="norm", ScalingType = "Identity")

plot(Sim)

# snorm

iT = 1e3

A = matrix(c(0.001 , 0.0 , 0.0 ,
              0.0 , 0.01 , 0.0 ,
              0.0 , 0.0 , 0.04),3,byrow = T)

B = matrix(c(0.7 , 0.0 , 0.0 ,
              0.0 , 0.98, 0.0 ,
              0.0 , 0.0 , 0.97),3,byrow = T)

Kappa = (diag(3) - B) %*% UnivUnmapParameters(c(0,0.1,1.1),"snorm")

Sim = UniGASSim(iT, vKappa, mA, mB, Dist="snorm", ScalingType = "Inv")

plot(Sim)

# std

iT = 1e3
A = matrix(c(0.001 , 0.0 , 0.0 ,
              0.0 , 0.01 , 0.0 ,
              0.0 , 0.0 , 0.04),3,byrow = T)

B = matrix(c(0.7 , 0.0 , 0.0 ,
              0.0 , 0.98, 0.0 ,
              0.0 , 0.0 , 0.97),3,byrow = T)

Kappa = (diag(3) - B) %*% UniUnmapParameters(c(0,0.1,8),"std")

Sim = UniGASSim(iT, Kappa, A, B, Dist="std", ScalingType = "Identity")

plot(Sim)

# sstd

iT = 1e3

A = matrix(c(0.0 , 0.0 , 0.0 , 0.0,
              0.0 , 0.1 , 0.0 , 0.0,
              0.0 , 0.0 , 0.00,  0.0,
              0.0 , 0.0 , 0.00,  0.0),4,byrow = T)

B = matrix(c(0.0 , 0.0 , 0.0 , 0.0,
              0.0 , 0.98, 0.0 , 0.0,
              0.0 , 0.0 , 0.00, 0.0,
              0.0 , 0.0 , 0.00, 0.0),4,byrow = T)

Kappa = (diag(4) - B) %*% UniUnmapParameters(c(0,0.1,1.1,8),"sstd")

Sim = UniGASSim(iT, Kappa, A, B, Dist="sstd", ScalingType = "Identity")

plot(Sim)


# poi

iT = 1e4

A = matrix(c(0.05),1)
B = matrix(c(0.94),1)

Kappa = (1-B) * log(5)

Sim = UniGASSim(iT, Kappa, A, B, Dist="poi", ScalingType = "Identity")

plot(Sim)

# beta

iT = 1e4

A = matrix(c(0.1,0.0,
              0.0,0.4),2)*0.01
B = matrix(c(0.98,0.0,
              0.0,0.99),2)


Kappa = (diag(2) - B) %*% c(log(0.1) , log(0.4))


Sim = UniGASSim(iT, Kappa, A, B, Dist="beta", ScalingType = "Identity")

plot(Sim)


################################
#        MULTIVARIATE          #
################################

# Simulate from a GAS process with Multivariate Student-t conditional distribution, time-varying locations, scales, correlations and fixed shape parameter.
library(GAS)

set.seed(786)

iT     = 1000 # number of observations to simulate
N     = 3     # trivariate series
Dist   = "mvt" # conditional Multivariate Studen-t distribution

# build unconditional vector of reparametrised parameters

Mu  = c(0.1,0.2,0.3)   # vector of location parameters (this is not transformed)
Phi = c(1.0, 1.2, 0.3) # vector of scale parameters for the firs, second and third variables.

Rho = c(0.1,0.2,0.3)   # This represents vec(R), where R is the correlation matrix.
# Note that is up to the user to ensure that vec(R) implies a proper correlation matrix

Theta = c(Mu, Phi, Rho, 7) # vector of parameters such that the degrees of freedom are 7.

A     = matrix(0,length(Kappa),length(Kappa))

diag(A) = c( 0,0,0 , 0.05,0.01,0.09  , 0.01,0.04,0.07,  0) # update scales and correlations, do not update locations and shape parameters

B     = matrix(0,length(Kappa),length(Kappa))

diag(B) = c( 0,0,0 , 0.7,0.7,0.5  , 0.94,0.97,0.92,  0) # update scales and correlations, do not update locations and shape parameters

Kappa = (diag(length(vTheta)) - B) %*% MultiUnmapParameters(vTheta, Dist, iN)

help(MultiGASSim)


Sim = MultiGASSim(iT,N, Kappa, A, B, Dist, ScalingType = "Identity")

Sim

plot(Sim)

