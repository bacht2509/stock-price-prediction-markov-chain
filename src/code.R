library(quantmod)
library(markovchain)

mdate <- "2001-01-03"
VNMPrices <- getSymbols("VNM.VN", from = mdate, auto.assign = F)
print(VNMPrices)
