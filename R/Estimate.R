
StaticMLFIT <- function(vY, Dist) {

    iT = length(vY)
    iK = NumberParameters(Dist)

    vTheta_tilde = StaticStarting_Uni(vY, Dist, iK)

    optimiser = suppressWarnings(solnp(vTheta_tilde, StaticLLKoptimizer_Uni, vY = vY, Dist = Dist, iT = iT, iK = iK,
        control = list(trace = 0)))

    vTheta_tilde = optimiser$pars

    vTheta = as.numeric(MapParameters_univ(vTheta_tilde, Dist, iK))
    names(vTheta) = FullNamesUni(Dist)

    out = list(vTheta = vTheta, dLLK = -tail(optimiser$values, 1), optimiser = optimiser)

    return(out)
}

StaticMLFIT_Multiv <- function(mY, Dist) {

    iT = ncol(mY)
    iN = nrow(mY)
    iK = NumberParameters(Dist, iN)

    vTheta_tilde = StaticStarting_Multi(mY, Dist, iN)

    optimiser = suppressWarnings(solnp(vTheta_tilde, StaticLLKoptimizer_Multi, mY = mY, Dist = Dist, iT = iT, iK = iK,
        iN = iN, control = list(trace = 0)))

    vTheta_tilde = optimiser$pars

    vTheta = as.numeric(MapParameters_multi(vTheta_tilde, Dist, iN, iK))
    names(vTheta) = FullNamesMulti(iN, Dist)

    out = list(vTheta = vTheta, dLLK = -tail(optimiser$values, 1), optimiser = optimiser)

    return(out)
}

UniGASFit <- function(GASSpec, data) {

    vY = data

    Start = Sys.time()

    iT = length(vY)

    Dist = getDist(GASSpec)
    ScalingType = getScalingType(GASSpec)
    GASPar = getGASPar(GASSpec)
    iK = NumberParameters(Dist)

    # starting par
    lStarting = UniGAS_Starting(vY, iT, iK, Dist, ScalingType, GASPar)
    vPw = lStarting$vPw
    StaticFit = lStarting$StaticFit

    # fixed par
    FixedPar = GetFixedPar_Uni(Dist, GASPar)
    vPw = RemoveFixedPar(vPw, FixedPar)

    # optimise
    optimiser = suppressWarnings(solnp(vPw, UniGASOptimiser, vY = vY, Dist = Dist, ScalingType = ScalingType, iT = iT,
        iK = iK, control = list(trace = 0)))

    vPw = optimiser$pars

    lParList = vPw2lPn_Uni(vPw, iK)
    lParList = AddFixedPar(lParList)

    Inference = InferenceFun_Uni(optimiser$hessian, vPw, iK)

    GASDyn = GASFilter_univ(vY, lParList$vKappa, lParList$mA, lParList$mB, iT, iK, Dist, ScalingType)

    IC = ICfun(-tail(optimiser$values, 1), length(optimiser$pars), iT)

    vU = EvaluatePit_Univ(GASDyn$mTheta, vY, Dist, iT)
    PitTest = PIT_test(vU, G = 20, alpha = 0.05, plot = F)

    mMoments = EvalMoments_univ(GASDyn$mTheta, Dist)

    elapsedTime = Sys.time() - Start

    Out <- new("uGASFit", ModelInfo = list(Spec = GASSpec, iT = iT, iK = iK, elapsedTime = elapsedTime),
        GASDyn = GASDyn, Estimates = list(lParList = lParList, optimiser = optimiser, StaticFit = StaticFit,
            Inference = Inference, IC = IC, vU = vU, Moments = mMoments), Testing = list(PitTest = PitTest),
        Data = list(vY = vY))

    return(Out)
}

# mY is NxT
MultiGASFit <- function(GASSpec, data) {

    mY = t(data)

    Start = Sys.time()
    # getInfo
    Dist = getDist(GASSpec)
    ScalingType = getScalingType(GASSpec)
    GASPar = getGASPar(GASSpec)
    ScalarParameters = GASSpec@Spec$ScalarParameters

    # dimension par
    iT = ncol(mY)
    iN = nrow(mY)
    iK = NumberParameters(Dist, iN)

    if (is.null(rownames(mY)))
        rownames(mY) = paste("Series", 1:iN)

    # starting par
    vPw = MultiGAS_Starting(mY, iT, iN, iK, Dist, GASPar, ScalingType, ScalarParameters)

    # fixed par
    FixedPar = GetFixedPar_Multi(Dist, GASPar, iN, ScalarParameters)
    vPw = RemoveFixedPar(vPw, FixedPar)

    # optimise
    optimiser = suppressWarnings(solnp(vPw, MultiGASOptimiser, mY = mY, Dist = Dist, ScalingType = ScalingType, iT = iT,
        iN = iN, iK = iK, ScalarParameters = ScalarParameters, control = list(trace = 0)))

    vPw = optimiser$pars

    lParList = vPw2lPn_Multi(vPw, Dist, iK, iN, ScalarParameters)
    lParList = AddFixedPar(lParList)

    Inference = InferenceFun_Multi(optimiser$hessian, Dist, vPw, iK, iN, ScalarParameters)

    GASDyn = GASFilter_multi(mY, lParList$vKappa, lParList$mA, lParList$mB, iT, iN, iK, Dist, ScalingType)

    IC = ICfun(-tail(optimiser$values, 1), length(optimiser$pars), iT)

    ## Moments
    mMoments = EvalMoments_multi(GASDyn$mTheta, Dist, iN)

    elapsedTime = Sys.time() - Start

    Out <- new("mGASFit", ModelInfo = list(Spec = GASSpec, iT = iT, iN = iN, iK = iK, elapsedTime = elapsedTime),
        GASDyn = GASDyn, Estimates = list(lParList = lParList, optimiser = optimiser, Inference = Inference,
            IC = IC, Moments = mMoments), Data = list(mY = mY))
    return(Out)
}
