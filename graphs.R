png("tshirts.png", width=800, height=500, bg = "transparent")

x = rep(c(15,10,5,4,3,1,0), c(2,2,2,3,4,4,3))
simple_probs = x / sum(x)
plot(simple_probs, type='l', lwd=3, col='red', ylab='prob', xlab='')
text(17,0.15,'original',col='red')

x_s = x+1
smooth_probs = x_s / sum(x_s)
lines(smooth_probs, type='l', lwd=3, col='blue')
text(17,0.14,'succession',col='blue')

zero_value = 0.04545 / 3
gt_probs = rep(c(0.1603, 0.1074, 0.05435, 0.04374, 0.03311, 0.01169, zero_value), c(2,2,2,3,4,4,3))
lines(gt_probs, type='l', lwd=3, col='green')
text(17,0.13,'good-turing',col='green')

dev.off()

x = read.delim('freqs',header=FALSE)$V1
x_log = log(x)

