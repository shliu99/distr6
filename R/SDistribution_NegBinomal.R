#' @include SetInterval_SpecialSet.R ParameterSet.R
#-------------------------------------------------------------
# Negative Binomial Distribution Documentation
#-------------------------------------------------------------
#' @title Negative Binomial Distribution
#'
#' @description Mathematical and statistical functions for the Negative Binomial distribution parameterised
#' with size and one of: prob, \eqn{qprob = 1 - prob} or mean (formula dependent on parameterisation, see details.)
#' The Negative Binomial determining the number of success before \eqn{n} failures is defined by the pmf,
#' \deqn{f(x) = C(x + n - 1, n) p^n (1 - p)^n}
#' where \eqn{n = 0,1,2,\ldots} is the size parameter, \eqn{p \epsilon [0,1]} is the prob parameter and
#' \eqn{C(a,b)} is the combination (or binomial coefficient) function.
#'
#' @details The Negative Binomial distribution can refer to one of four distributions:
#'
#' 1. The number of successes before K failures
#'
#' 2. The number of trials before K failures
#'
#' 3. The number of failures before K successes
#'
#' 4. The number of trials before K successes
#'
#' For each we refer to the number of K successs/failures as the \code{size} parameter, \code{prob}
#' is always the probability of success and \code{qprob} is the probability of failure.
#'
#' @name NegativeBinomial
#'
#' @section Constructor: NegativeBinomial$new(size = 10, prob = 0.5, qprob = NULL, type = "fbs", decorators = NULL, verbose = FALSE)
#'
#' @section Constructor Arguments:
#' \tabular{lll}{
#' \strong{Argument} \tab \strong{Type} \tab \strong{Details} \cr
#' \code{size} \tab numeric \tab number of failures. \cr
#' \code{prob} \tab numeric \tab probability of success. \cr
#' \code{qprob} \tab numeric \tab probability of failure. \cr
#' \code{type} \tab character \tab type of negative binomial, see details. \cr
#' \code{decorators} \tab Decorator \tab decorators to add functionality. \cr
#' \code{verbose} \tab logical \tab if TRUE parameterisation messages produced.
#' }
#'
#' @section Constructor Details: The Negative Binomial distribution is parameterised with size,
#' as an integer and either prob (probability of success) or qprob (probability of failure) as a number
#' between 0 and 1. If \code{qprob} is given then \code{prob} is ignored. The additional parameter
#' \code{type} determines which of the four Negative Binomial distributions should be constructed, this
#' cannot be updated after construction. \code{type} should be one of "sbf" (successes before failures),
#' "tbf" (trials before failures), "fbs" (failures before successes) or "tbs" (trials before successes).
#' "fbs" is taken as default as this is used in R stats (although "sbf" is typically more common).
#'
#'
#' @inheritSection SDistribution Public Variables
#' @inheritSection SDistribution Public Methods
#
#
#' @export
NULL
#-------------------------------------------------------------
# NegativeBinomial Distribution Definition
#-------------------------------------------------------------
NegativeBinomial <- R6::R6Class("NegativeBinomial", inherit = SDistribution, lock_objects = F)
NegativeBinomial$set("public", "name", "NegativeBinomial")
NegativeBinomial$set("public", "short_name", "NBinom")
NegativeBinomial$set("public", "traits", list(type = PosIntegers$new(zero = T),
                                         valueSupport = "discrete",
                                         variateForm = "univariate"))
NegativeBinomial$set("private",".type",NULL)
NegativeBinomial$set("public","package","distr6")

NegativeBinomial$set("public", "mean", function(){
  if(private$.type == "sbf")
    return(self$getParameterValue("size") * self$getParameterValue("prob") / self$getParameterValue("qprob"))
  else if(private$.type == "tbf")
    return((self$getParameterValue("size") * self$getParameterValue("prob") / self$getParameterValue("qprob"))+self$getParameterValue("size"))
  else if(private$.type == "tbs")
    return((self$getParameterValue("size") * self$getParameterValue("qprob") / self$getParameterValue("prob"))+self$getParameterValue("size"))
  else if(private$.type == "fbs")
    return(self$getParameterValue("size") * self$getParameterValue("qprob") / self$getParameterValue("prob"))
})
NegativeBinomial$set("public","var",function(){
  if(private$.type == "sbf" | private$.type == "tbf")
    return(self$getParameterValue("size") * self$getParameterValue("prob") / (self$getParameterValue("qprob")^2))
  else if(private$.type == "fbs" | private$.type == "tbs")
    return(self$getParameterValue("size") * self$getParameterValue("qprob") / (self$getParameterValue("prob")^2))
})
NegativeBinomial$set("public", "skewness", function(){
  if(private$.type == "sbf" | private$.type == "tbf")
    return((1 + self$getParameterValue("prob")) / sqrt(self$getParameterValue("size") * self$getParameterValue("prob")))
  else
    return((1 + self$getParameterValue("qprob")) / sqrt(self$getParameterValue("size") * self$getParameterValue("qprob")))
})
NegativeBinomial$set("public", "kurtosis", function(excess = TRUE){
  if(private$.type == "sbf" | private$.type == "tbf")
    exkurtosis = (self$getParameterValue("qprob")^2 - 6*self$getParameterValue("qprob") + 6)/
      (self$getParameterValue("size") * self$getParameterValue("prob"))
  else
    exkurtosis = (self$getParameterValue("prob")^2 - 6*self$getParameterValue("prob") + 6)/
      (self$getParameterValue("size") * self$getParameterValue("qprob"))

  if(excess)
    return(exkurtosis)
  else
    return(exkurtosis + 3)
})

NegativeBinomial$set("public", "mgf", function(t){
  if(t < -log(self$getParameterValue("prob"))){
    if(private$.type == "sbf" | private$.type == "tbf")
      return((self$getParameterValue("qprob")/(1 - self$getParameterValue("prob")*exp(t)))^self$getParameterValue("size"))
    else
      return((self$getParameterValue("prob")/(1 - self$getParameterValue("qprob")*exp(t)))^self$getParameterValue("size"))
  } else
    return(NaN)
})

NegativeBinomial$set("public", "cf", function(t){
  if(private$.type == "sbf" | private$.type == "tbf")
    return((self$getParameterValue("qprob")/(1 - self$getParameterValue("prob")*exp(t*1i)))^self$getParameterValue("size"))
  else
    return((self$getParameterValue("prob")/(1 - self$getParameterValue("qprob")*exp(t*1i)))^self$getParameterValue("size"))
})

NegativeBinomial$set("public", "pgf", function(z){
  if(abs(z) < 1/self$getParameterValue("prob")){
    if(private$.type == "sbf")
      return((self$getParameterValue("qprob") / (1 - self$getParameterValue("prob")*z))^self$getParameterValue("size"))
    else if(private$.type == "tbs")
      return(((self$getParameterValue("prob")*z) / (1 - self$getParameterValue("qprob")*z))^self$getParameterValue("size"))
    else if(private$.type == "fbs")
      return((self$getParameterValue("prob") / (1 - self$getParameterValue("qprob")*z))^self$getParameterValue("size"))
    else if(private$.type == "tbf")
      return(((self$getParameterValue("qprob")*z) / (1 - self$getParameterValue("prob")*z))^self$getParameterValue("size"))
  } else
    return(NaN)
})


NegativeBinomial$set("public","setParameterValue",function(lst, error = "warn"){
  super$setParameterValue(lst, error)
  if(private$.type == "tbf" | private$.type == "tbs")
    private$.properties$support <- PosIntegers$new(lower = self$getParameterValue("size"))
})
NegativeBinomial$set("private", ".getRefParams", function(paramlst){
  lst = list()
  if(!is.null(paramlst$size)) lst = c(lst, list(size = paramlst$size))
  if(!is.null(paramlst$prob)) lst = c(lst, list(prob = paramlst$prob))
  if(!is.null(paramlst$qprob)) lst = c(lst, list(prob = 1-paramlst$qprob))
  return(lst)
})


NegativeBinomial$set("public","initialize", function(size = 10, prob = 0.5, qprob = NULL, type = "fbs",
                                                     decorators = NULL, verbose = FALSE){

  if(!(type %in% c("fbs", "sbf", "tbf", "tbs")))
    type <- "fbs"

  private$.type <- type

  private$.parameters <- getParameterSet(self, size, prob, qprob, type, verbose)
  self$setParameterValue(list(size = size, prob = prob, qprob = qprob))

  if(type == "fbs"){
    pdf = function(x1) dnbinom(x1, self$getParameterValue("size"), self$getParameterValue("prob"))
    cdf = function(x1) pnbinom(x1, self$getParameterValue("size"), self$getParameterValue("prob"))
    quantile = function(x1) qnbinom(x1, self$getParameterValue("size"), self$getParameterValue("prob"))
    rand = function(x1) rnbinom(n, self$getParameterValue("size"), self$getParameterValue("prob"))
    support = PosIntegers$new(zero = T)
    description = "Negative Binomial (fbs) Probability Distribution."
  } else if(type == "sbf"){
    pdf = function(x1){
      return(choose(x1 + self$getParameterValue("size") - 1, x1) *
        self$getParameterValue("prob")^x1 *
        self$getParameterValue("qprob")^self$getParameterValue("size"))
    }
    cdf = function(x1){
      return(1 - pbeta(self$getParameterValue("prob"), x1+1, self$getParameterValue("size"))/beta(x1+1, self$getParameterValue("size")))
    }
    support = PosIntegers$new(zero = T)
    description = "Negative Binomial (sbf) Probability Distribution."
  } else if(type == "tbf"){
    pdf = function(x1){
      return(choose(x1 - 1, self$getParameterValue("size")-1) *
               self$getParameterValue("prob")^(x1 - self$getParameterValue("size")) *
               self$getParameterValue("qprob")^self$getParameterValue("size"))
    }
    cdf = function(x1){
      if(length(x1 == 1))
        return(sum(self$pdf(self$inf():x1)))
      else{
        return(unlist(sapply(x1, function(x) sum(self$pdf(self$inf():x)))))
      }
    }
    support = PosIntegers$new(lower = size)
    description = "Negative Binomial (tbf) Probability Distribution."
  } else{
    pdf = function(x1){
      return(choose(x1 - 1, self$getParameterValue("size")-1) *
               self$getParameterValue("prob")^self$getParameterValue("size") *
               self$getParameterValue("qprob")^(x1 - self$getParameterValue("size")))
    }
    cdf = function(x1){
      if(length(x1 == 1))
        return(sum(self$pdf(self$inf():x1)))
      else{
        return(unlist(sapply(x1, function(x) sum(self$pdf(self$inf():x)))))
      }
    }
    support = PosIntegers$new(lower = size)
    description = "Negative Binomial (tbs) Probability Distribution."
  }

  super$initialize(decorators = decorators, pdf = pdf, cdf = cdf, quantile = quantile,
                   rand = rand, support = support, distrDomain = PosIntegers$new(zero = T),
                   symmetric = FALSE)
  invisible(self)
})


