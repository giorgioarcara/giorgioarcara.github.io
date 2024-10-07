### C statistics ###
# formula from Tryon (1982)
# C.statistics in input ha semplicemente il vettore di dati.
# L' ipotesi nulla è che non ci sia un trend nei dati.
# L'ipotesi alternativa è che ci sia un trend nei dati.

# Il test si utilizza (vedi Tryon, 1982). Attaccando sequenze di dati.
# Es. si effettua prima un test su baseline, per assicurarsi che non ci sia trend.
# poi si effettua un test baseline + blocco 1 per vedere che non ci sia trende.
# si effettua un test su bloccon + follow-up, per verificare se c'è trend (ulteriore miglioramento o peggioramento)

# Questo va desunto graficamente, visto che la C-statistics non ha un segno (che il trend sia positivo o negativo restituisce lo stesso risultato.)


C.statistics<-function(x){
	series=x[1:(length(x)-1)]
	series.fol=x[2:length(x)]
	
	dat=data.frame(series=series, series.fol=series.fol)
	
	dev=apply(dat, 1, function(x){x[1]-x[2]})
	sum.dev.sq=sum(dev^2)
	
	num=sum.dev.sq
	
	den=2*sum(scale(x, center=T,scale=F)^2)
	
	C.stat=1-(num/den)	
	
	n=length(x)
	
	Sc=sqrt((n+2)/((n-1)*(n+1)))
	
	Z=C.stat/Sc
	
	#### Z crit table for p < 0.01. fromm Tryon (1982)

	N.obs=c(8:25)
	z.crit.01.vals=c(2.17,2.18,2.20,2.21,2.22,2.22,2.23,2.24,2.24,2.25,2.25,2.26,2.26,2.26,2.26,2.27,2.27,2.27)
	z.crit.01.table=data.frame(N.obs, z.crit.01.vals)

	if (n<=25){
		z.crit.01=z.crit.01.table$z.crit.01.vals[match(n, z.crit.01.table$N.obs)]
	} else {
		
		z.crit.01=2.33 # if n > 25 the z crit of 2.33 is sued
	}
	
	
	### for p < 0.05, z crit = 1.64 for all sample size (from Tyron)
	
	
	results=data.frame(C=C.stat, z.obs=Z, z.crit.05=1.64, z.crit.01=z.crit.01)
	
	return(results)
	
	# for n points < 25 take from paper by Tryon. Otherwise 2.33.
	
	
}