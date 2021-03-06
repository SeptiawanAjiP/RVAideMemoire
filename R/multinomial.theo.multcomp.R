multinomial.theo.multcomp <-
function(x,p=rep(1/length(x),length(x)),prop=FALSE,p.method="fdr") {
  if (is.factor(x)) {
    lab <- levels(x)
    x <- as.vector(table(x))
    names(x) <- lab
  }
  if (!is.vector(x)) {stop("'x' must be a vector")}
  if (sum(p)!=1) {stop("sum of probabilities must be 1")}
  if (length(x)!=length(p)) {stop("'x' and 'p' lengths differ")}
  theo <- p*sum(x)
  pval <- integer(length(x))
  for (i in 1:length(x)) {
    test <- binom.test(x[i],sum(x),p=p[i])
    pval[i] <- test$p.value
  }
  p.adj <- p.adjust(pval,method=p.method)
  obs <- if (prop) {x/sum(x)} else {x}
  theo2 <- if (prop) {p} else {theo}
  comp <- if (is.null(names(x))) {
    data.frame("observed"=obs,"expected"=theo2,"P-value"=p.adj," "=.psignif(p.adj),
	stringsAsFactors=FALSE,check.names=FALSE)
  } else {
    data.frame(" "=names(x),"observed"=obs,"expected"=theo2,"P-value"=p.adj," "=.psignif(p.adj),
	stringsAsFactors=FALSE,check.names=FALSE)
  }
  call <- match.call()
  dname.x <- if(length(call$x)==1) {call$x} else {paste(call$x[1],"(",paste(call$x[-1],collapse=","),")",sep="")}
  dname.p <- if(length(call$p)==1) {call$p} else {paste(call$p[1],"(",paste(call$p[-1],collapse=","),")",sep="")}
  dname <- paste(dname.x," and ",dname.p,sep="")
  result <- list(method="exact binomial tests",data.name=dname,observed=x,expected=theo,p.adjust.method=p.method,
    p.value2=p.adj,p.value=comp)
  class(result) <- "RV.multcomp"
  return(result)
}

