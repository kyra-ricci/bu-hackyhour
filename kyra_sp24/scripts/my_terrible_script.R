# Workspace setup --------------------------------------------------------------
install.packages("lubridate")
install.packages("tm")

## Read in data ----------------------------------------------------------------

files <- list.files("iNat Exports ADULTS/iNat Exports ADULTS/", 
                    pattern=".csv", 
                    full.names = T)

# ctrl + shift + c = comment out multiple lines
# ctrl + shift + a = cleans up parentheses 

## Read in iNaturalist data ---------------------------------------------------

# Create object that represents the number of zipped files (there is a list of 83)
filenos <- (1:83)

# One option to unzip them all
# for(i in filenos){
#   read.csv(unzip(files[i]))
# }

# Another more efficient option
out <- lapply(files, function(x){
  read.csv(unzip(x))
})

# lapply function gives a function to a list
# lapply(X=1:5, function=mean) # this is the same as
# for (i in 1:5){
#   print(mean(i))
# }

# Put them all into a single dataframe
# do.call function allows you to do something to the list
## first argument "what" tells it what to do
## second argument tells what to do that to
# the following code tells it to rbind the list "out" to make one dataframe
inat <- do.call(what = rbind, out)
View(inat)

inat <- inat[!inat$observed_on=="",]
inat$week <- lubridate::week(inat$observed_on)
inat$week <- factor(append(inat$week, 1:52))[1:nrow(inat)]
inat$year <- lubridate::year(inat$observed_on)

inat <- inat[inat$year>2018,]
## Read in historical data -----------------------------------------------------

# historical <- as.data.frame(readxl::read_xlsx("../Trap lantern data from Ithaca (3).xlsx",
#                                               sheet=3, col_names = T))

historical <- read.csv("data/PhenolCharts.csv")

# historical <- historical[!is.na(historical$`Found in iNat`),]
# historical <- historical[!is.na(historical$`1919First`),]
# can combine these
View(historical)
historical <- historical[!(is.na(historical$Found.in.iNat) 
                         | is.na(historical$X1919First)),]

# Species name matching --------------------------------------------------------
inat <- inat[!grepl("Bailey", inat$scientific_name),]
# grepl will look for anything that has "sordens" in inat$scientific_name and will return true if it is present
inat$scientific_name[grepl("sordens", inat$scientific_name)] <- "Apamea sordens"

sp <- historical$Species.name
sp.inat <- historical$Name.change.
# trim white space will remove spaces/white space trmws("     bannana  ") 
sp.inat <- trimws(tm::removePunctuation(sp.inat))
# sp.inat <- trimws(tm::removePunctuation(gsub("\n", "", sp.inat)))
sp.inat[sp.inat ==""] <- sp[sp.inat==""]

# create a new dataframe to replace old taxonomical names with current ones

sp.changes <- data.frame(
  old.names = c(
    "Chlorochamys chloroleucaria",
    "Estigmene acraea",
    "Crambus vulgivagellus"
  ),
  new.names = c(
    "Chlorochlamys chloroleucaria",
    "Estigmene acrea",
    "Agriphila vulgivagellus"
  )
)


# here is a less efficient way to do this by each separate species
# sp.inat[sp.inat=="Chlorochamys chloroleucaria"] <- "Chlorochlamys chloroleucaria"
# #sp.inat[sp.inat=="Chlorochamys chloroleucaria"] <- "Chlorochlamys chloroleucaria"
# sp.inat[sp.inat=="Estigmene acraea"] <- "Estigmene acrea"
# sp.inat[grepl("Bailey", sp.inat)] <- NA
# 
# # Why is Idia concisa in downloads?
# # And Euphyia intermediata?
# # Anania tertialis?
# # Herpetogramma thestealis?
# sp.inat[sp.inat=="Crambus vulgivagellus"] <- "Agriphila vulgivagellus"
# sp.inat[sp.inat=="Evergestis straminalis"] <- "Evergestis pallidata"
# sp.inat[sp.inat=="Apamea sordens"] <- "Apamea sordens"
# sp.inat[sp.inat=="Eudeilinea herminiata"] <- "Eudeilinia herminiata"
# sp.inat[sp.inat=="Ennomos subsignarius"] <- "Ennomos subsignaria"
# sp.inat[sp.inat=="Archips argyrospilus"] <- "Archips argyrospila"
# sp.inat[sp.inat=="Herpetogramma abdominalis"] <- "Herpetogramma thestealis"


# Make old names and new names match up in the sp.inat dataframe
for(i in 1:nrow(sp.changes)){
  sp.inat <- sub(pattern = sp.changes$old.names[i],
                 replacement = sp.changes$new.names[i],
                 x = sp.inat)
}

# Look to see how many unique species show up
# %in% tells you which items from one vector are also in another vector
unique(inat$scientific_name[!inat$scientific_name%in%sp.inat])

sp.inat[!sp.inat%in%inat$scientific_name]
sp[!sp.inat%in%inat$scientific_name]


table(inat$scientific_name)

# Exclude the following species
excl.sp <- c(
  "Mythimna unipuncta",
  "Autographa precationis",
  "Idia aemula",
  "Hypena scabra",
  "Pleuroprucha insularia",
  "Lambdina fiscellaria",
  "Orthosia hibisci",
  "Pyreferra hesperidago"
)

# excl.sp <- append(excl.sp, "Pyreferra hesperidago")
# and exclude Orthosia hibisci -- too early
# disappeared: Noctua baja, Apamea nictitans, Datana angusii, Xanthotype crocataria,
# Phlyctaenia terrealis, Gracilaria superbifrontella
# Macaria granitata - last observed 2012, but has export because entered later on

# Phenology data cleaning ------------------------------------------------------

# Array should have:
# 1) Species name
# species <- cbind(sp, sp.inat)
# species <- species[!species[,2]%in%excl.sp[7],]
# species <- species[!species[,1]%in%excl.sp[7],]

species <- cbind(sp, sp.inat)[!(sp %in% excl.sp |
                                sp.inat %in% excl.sp),]

# 2) Week of first flight (1919, 1922, recent)
# create two empty arrays
firstflight <- lastflight <- array(dim=c(nrow(species), 3))

for(i in 1:nrow(species)){
  inat.tmp <- inat[inat$scientific_name==species[i,2],]
  hist.tmp <- historical[historical$Species.name==species[i,1],]
  firstflight[i, 1:2] <- unlist(hist.tmp[,c("X1919First", "X1922First")])
  firstflight[i, 3] <- min(as.numeric(inat.tmp$week), na.rm=T)
  lastflight[i, 1:2] <- unlist(hist.tmp[,c("X1919Last", "X1922Last")])
  lastflight[i, 3] <- max(as.numeric(inat.tmp$week), na.rm=T)
}

# instead of repeating code to make plots, you can create a function

generate_lineplot <- function (x, y, z, ylab = null) {
  ff1 <- table(x)
  ff2 <- table(y)
  ff3 <- table(z)
  
  plot(
    names(ff1) ~ rep(1, length(ff1)),
    cex = log(ff1 + 1),
    pch = 16,
    xlim = c(0.75, 3.25),
    ylab = "First flight week",
    xlab = "Year",
    axes = F,
    ylim = c(0, 40),
    col = "white"
  )
  axis(2, at = seq(0, 40, 10))
  axis(1,
       at = c(1, 2, 3),
       labels = c(1919, 1922, "iNaturalist"))
  
  ff12 <- table(firstflight[, 1], firstflight[, 2])
  for (i in 1:nrow(ff12)) {
    for (j in 1:ncol(ff12)) {
      if (ff12[i, j] > 0) {
        arrows(
          x0 = 1,
          x1 = 2,
          y0 = as.numeric(rownames(ff12)[i]),
          y1 = as.numeric(colnames(ff12)[j]),
          lwd = ff12[i, j],
          col = lav,
          length = 0
        )
      }
    }
  }
  
  ff23 <- table(firstflight[,2], firstflight[,3])
  for(i in 1:nrow(ff23)){
    for(j in 1:ncol(ff23)){
      if(ff23[i,j]>0){
        arrows(x0=2, x1=3, y0=as.numeric(rownames(ff23)[i]), y1=as.numeric(colnames(ff23)[j]),
               lwd=ff23[i,j], col=lav,
               length=0)
      }
    }
  }
  
}


generate_lineplot(firstflight[,1], firstflight[,2], firstflight)






# ff13 <- table(firstflight[,1], firstflight[,3])
# for(i in 1:nrow(ff13)){
#   for(j in 1:ncol(ff13)){
#     if(ff13[i,j]>0){
#       if(is.na(ff23[i,j])){
#         arrows(x0=1, x1=3, y0=as.numeric(rownames(ff13)[i]), y1=as.numeric(colnames(ff13)[j]),
#                lwd=ff13[i,j], col=lav,
#                length=0)
#       }
#     }
#   }
# }


#
# points(names(ff1) ~ rep(1, length(ff1)), cex=log(ff1+1), pch=16, col="white")
# points(names(ff2) ~ rep(2, length(ff2)), cex=log(ff2+1), pch=16, col="white")
# points(names(ff3) ~ rep(3, length(ff3)), cex=log(ff3+1), pch=16, col="white")
points(names(ff1) ~ rep(1, length(ff1)), cex=log(ff1+1), pch=16, col="#B19CD9")
points(names(ff2) ~ rep(2, length(ff2)), cex=log(ff2+1), pch=16, col="#B19CD9")
points(names(ff3) ~ rep(3, length(ff3)), cex=log(ff3+1), pch=16, col="#B19CD9")




lf1 <- table(lastflight[,1])
lf2 <- table(lastflight[,2])
lf3 <- table(lastflight[,3])

plot(names(lf1) ~ rep(1, length(lf1)), cex=log(lf1+1), pch=16, xlim=c(0.75, 3.25),
     ylab="Last flight week", xlab="Year", axes=F, ylim=c(15, 52))
axis(2, at=seq(15, 50, 10))
axis(1, at=c(1,2,3), labels=c(1919, 1922, "iNaturalist"))
# points(names(lf2) ~ rep(2, length(lf2)), cex=log(lf2+1), pch=16)
# points(names(lf3) ~ rep(3, length(lf3)), cex=log(lf3+1), pch=16)


lf12 <- table(lastflight[,1], lastflight[,2])
for(i in 1:nrow(lf12)){
  for(j in 1:ncol(lf12)){
    if(lf12[i,j]>0){
      arrows(x0=1, x1=2, y0=as.numeric(rownames(lf12)[i]), y1=as.numeric(colnames(lf12)[j]),
             lwd=lf12[i,j], col="#00000088",
             length=0)
    }
  }
}

lf23 <- table(lastflight[,2], lastflight[,3])
for(i in 1:nrow(lf23)){
  for(j in 1:ncol(lf23)){
    if(lf23[i,j]>0){
      arrows(x0=2, x1=3, y0=as.numeric(rownames(lf23)[i]), y1=as.numeric(colnames(lf23)[j]),
             lwd=lf23[i,j], col="#00000088",
             length=0)
    }
  }
}


plot(0:3 ~ rep(1, 4), cex=1, pch=16, xlim=c(0.75, 3.25),
     ylab="Last flight week", xlab="Year", axes=F)#, ylim=c(15, 52))
axis(2, at=seq(15, 50, 10))
axis(1, at=c(1,2,3), labels=c(1919, 1922, "iNaturalist"))
# points(names(lf2) ~ rep(2, length(lf2)), cex=log(lf2+1), pch=16)
#
b23 <- table(historical$Broods, historical$`Broods in iNat`)
for(i in 1:nrow(b23)){
  for(j in 1:ncol(b23)){
    if(b23[i,j]>0){
      arrows(x0=2, x1=3, y0=as.numeric(rownames(b23)[i]), y1=as.numeric(colnames(b23)[j]),
             lwd=b23[i,j], col="#00000088",
             length=0)
    }
  }
}





duration <- (lastflight - firstflight) +1

dur1 <- table(duration[,1])
dur2 <- table(duration[,2])
dur3 <- table(duration[,3])

plot(names(dur1) ~ rep(1, length(dur1)), cex=log(dur1+1), pch=16, xlim=c(0.75, 3.25),
     ylab="Duration of flight period (weeks)", xlab="Year", axes=F, ylim=c(0, 52))
axis(2, at=seq(0, 50, 10))
axis(1, at=c(1,2,3), labels=c(1919, 1922, "iNaturalist"))
points(names(dur2) ~ rep(2, length(dur2)), cex=log(dur2+1), pch=16)
points(names(dur3) ~ rep(3, length(dur3)), cex=log(dur3+1), pch=16)


dur12 <- table(duration[,1], duration[,2])
for(i in 1:nrow(dur12)){
  for(j in 1:ncol(dur12)){
    if(dur12[i,j]>0){
      arrows(x0=1, x1=2, y0=as.numeric(rownames(dur12)[i]), y1=as.numeric(colnames(dur12)[j]),
             lwd=dur12[i,j], col="#00000088",
             length=0)
    }
  }
}

dur23 <- table(duration[,2], duration[,3])
for(i in 1:nrow(dur23)){
  for(j in 1:ncol(dur23)){
    if(dur23[i,j]>0){
      arrows(x0=2, x1=3, y0=as.numeric(rownames(dur23)[i]), y1=as.numeric(colnames(dur23)[j]),
             lwd=dur23[i,j], col="#00000088",
             length=0)
    }
  }
}



species <- cbind(sp, sp.inat)
species.all <- species
species <- species[!species[,2]%in%excl.sp[7],]
species <- species[!species[,1]%in%excl.sp[7],]



relab <- as.data.frame(readxl::read_xlsx("../Trap lantern data from Ithaca (3).xlsx",
                                         sheet=2, col_names = T))
relab2 <- as.data.frame(readxl::read_xlsx("../Trap lantern data from Ithaca (3).xlsx",
                                          sheet=5, col_names = T))

relab <- rbind(relab[,1:11], relab2)
relab <- relab[relab$`Species name`%in%sp,]

relative <- c()
for(i in 1:nrow(species)){
  relative[i] <- sum(relab$Count[relab$`Species name`==species[i,1]], na.rm=T)/sum(relab$Count, na.rm=T)
}

#relative <- relative[!sp%in%excl.sp[7]]
# sp2 <- sp[!sp%in%excl.sp[7]]
# sp3 <- sp.inat[!sp%in%excl.sp[7]]
#
disap <- species[,2]%in%excl.sp
#
plot(disap ~ relative)

mod.d <- glm(disap ~ relative, family="binomial")
summary(mod.d)
lines(predict(mod.d, newdata = data.frame(relative=seq(0, 0.1, 0.001)),
              type="response") ~ seq(0, 0.1, 0.001))


shift.dur <- duration[,3] - apply(duration[,1:2], 1, mean, na.rm=T)
#shift.dur <- shift.dur[!shift.dur%in%c(NA, "-Inf")]
plot(shift.dur[!shift.dur%in%c(NA, "-Inf")] ~ relative[!shift.dur%in%c(NA, "-Inf")])
abline(lm(shift.dur[!shift.dur%in%c(NA, "-Inf")] ~ relative[!shift.dur%in%c(NA, "-Inf")]))


shift.ff <- firstflight[,3] - apply(firstflight[,1:2], 1, mean, na.rm=T)
#shift.ff <- shift.ff[!shift.ff%in%c(NA, "-Inf")]
plot(shift.ff[!shift.ff%in%c(NA, "-Inf", "Inf")] ~ relative[!shift.ff%in%c(NA, "-Inf", "Inf")])
abline(lm(shift.ff[!shift.ff%in%c(NA, "-Inf", "Inf")] ~ relative[!shift.ff%in%c(NA, "-Inf", "Inf")]))

shift.lf <- lastflight[,3] - apply(lastflight[,1:2], 1, mean, na.rm=T)
#shift.lf <- shift.lf[!shift.lf%in%c(NA, "-Inf")]
plot(shift.lf[!shift.lf%in%c(NA, "-Inf", "Inf")] ~ relative[!shift.lf%in%c(NA, "-Inf", "Inf")],
)
abline(lm(shift.lf[!shift.lf%in%c(NA, "-Inf", "Inf")] ~ relative[!shift.lf%in%c(NA, "-Inf", "Inf")]))



#
# predict(mod.d, newdata = data.frame(relative=0.08), type="response")
# boxplot(relative ~ disap)
# boxplot(duration[,1] ~ disap)
# boxplot(firstflight[,1] ~ disap)
# boxplot(lastflight[,1] ~ disap)
# points(0.01, 0.06)
# historical$Broods[historical$`Name change?`%in%excl.sp]
#

disap <- grepl("no", historical$`Exported?`)
disap <- disap[!historical$`Species name`%in%excl.sp[7]]
#which(sp%in%disap)

plot(disap ~ relative, pch=19, col="#000000bb")



# arrows(x0=rep(1, nrow(firstflight)), y0 = firstflight[,1], x1=rep(2, nrow(firstflight)),
#        y1=firstflight[,2], length = 0, lwd=1.2)
# arrows(x0=rep(2, nrow(firstflight)), y0 = firstflight[,2], x1=rep(3, nrow(firstflight)),
#        y1=firstflight[,3], length = 0, lwd=1.2)
#

table(firstflight[,1])

par(pty="s", las=1)
plot(firstflight[,1] ~ rep(1, nrow(firstflight)), xlim=c(0.75, 3.25), ylim=c(0,40), pch=20, cex=1.25,
     col="#00000088",
     ylab="First flight week", xlab="Year", axes=F)
axis(2)
axis(1, at=c(1,2,3), labels=c(1919, 1922, "iNaturalist"))
points(firstflight[,2] ~ rep(2, nrow(firstflight)), cex=1.25, pch=20)
points(firstflight[,3] ~ rep(3, nrow(firstflight)), cex=1.25, pch=20)


plot(lastflight[,1] ~ rep(1, nrow(lastflight)), xlim=c(0, 4), ylim=c(10,52), pch=20, cex=1.25)
points(lastflight[,2] ~ rep(2, nrow(lastflight)), cex=1.25, pch=20)
points(lastflight[,3] ~ rep(3, nrow(lastflight)), cex=1.25, pch=20)
arrows(x0=rep(1, nrow(lastflight)), y0 = lastflight[,1], x1=rep(2, nrow(lastflight)),
       y1=lastflight[,2], length = 0, lwd=1.2)
arrows(x0=rep(2, nrow(lastflight)), y0 = lastflight[,2], x1=rep(3, nrow(lastflight)),
       y1=lastflight[,3], length = 0, lwd=1.2)


plot(duration[,1] ~ rep(1, nrow(duration)), xlim=c(0, 4), ylim=c(0,52), pch=20, cex=1.25)
points(duration[,2] ~ rep(2, nrow(duration)), cex=1.25, pch=20)
points(duration[,3] ~ rep(3, nrow(duration)), cex=1.25, pch=20)
arrows(x0=rep(1, nrow(duration)), y0 = duration[,1], x1=rep(2, nrow(duration)),
       y1=duration[,2], length = 0, lwd=1.2)
arrows(x0=rep(2, nrow(duration)), y0 = duration[,2], x1=rep(3, nrow(duration)),
       y1=duration[,3], length = 0, lwd=1.2)


# 3) Week of last flight (1919, 1922, recent)
# 4) Week of peak flight
# 5) Total flight duration (last - first)
#

fd <- density(unlist(firstflight[,1:2])[!is.na(unlist(firstflight[,1:2]))])
fd.m <- density(unlist(firstflight[,3])[!is.na(unlist(firstflight[,3]))])
ff.h <- unlist(firstflight[,1:2])[!is.na(unlist(firstflight[,1:2]))]
ff.m <- unlist(firstflight[,3])[!is.na(unlist(firstflight[,3]))]
ff.m <- ff.m[ff.m <55]
ff.tt <- t.test(ff.h, ff.m)

par(cex.lab=2, cex.axis=1.5)
plot(fd, type="n", xlab="Week of first flight (all species)", ylab="Density",
     axes=F, main="", xlim=c(0, 52), ylim=c(0, 0.15))
legend("topright", legend=c("Historical", "Recent", paste0("t = ", round(ff.tt$statistic, 2)),
                            paste0("p = ", round(ff.tt$p.value, 2))),
       col=c(brown, lav, NA, NA), pch=c(15, 15, NA, NA), pt.cex=3, bty="n",
       cex=1.5)

polygon(c(fd$x, rev(fd$x)),
        c(fd$y, rep(0, length(fd$y))),
        col=brown, border=brown)

polygon(c(fd.m$x, rev(fd.m$x)),
        c(fd.m$y, rep(0, length(fd.m$y))),
        col=lav, border=lav)
axis(1); axis(2)


fd <- density(unlist(lastflight[,1:2])[!is.na(unlist(lastflight[,1:2]))])
fd.m <- density(unlist(lastflight[,3])[!is.na(unlist(lastflight[,3]))])
lf.h <- unlist(lastflight[,1:2])[!is.na(unlist(lastflight[,1:2]))]
lf.m <- unlist(lastflight[,3])[!is.na(unlist(lastflight[,3]))]
lf.m <- lf.m[lf.m <55 & lf.m>0]
lf.tt <- t.test(lf.h, lf.m)

par(cex.lab=2, cex.axis=1.5)
plot(fd, type="n", xlab="Week of last flight (all species)", ylab="Density",
     axes=F, main="", xlim=c(0, 52), ylim=c(0, 0.15))
legend("topright", legend=c("Historical", "Recent", paste0("t = ", round(lf.tt$statistic, 2)),
                            paste0("p = ", "5.4e-06" )),
       col=c(brown, lav, NA, NA), pch=c(15, 15, NA, NA), pt.cex=3, bty="n",
       cex=1.5)
polygon(c(fd$x, rev(fd$x)),
        c(fd$y, rep(0, length(fd$y))),
        col=brown, border=brown)

polygon(c(fd.m$x, rev(fd.m$x)),
        c(fd.m$y, rep(0, length(fd.m$y))),
        col=lav, border=lav)
axis(1); axis(2)



fd <- density(unlist(duration[,1:2])[!is.na(unlist(duration[,1:2]))])
fd.m <- density(unlist(duration[,3])[!is.na(unlist(duration[,3]))])
dur.h <- unlist(duration[,1:2])[!is.na(unlist(duration[,1:2]))]
dur.m <- unlist(duration[,3])[!is.na(unlist(duration[,3]))]
dur.m <- dur.m[dur.m <55 & dur.m>0]
dur.tt <- t.test(dur.h, dur.m)

par(cex.lab=2, cex.axis=1.5)
plot(fd, type="n", xlab="Flight duration (weeks)", ylab="Density",
     axes=F, main="", xlim=c(0, 52), ylim=c(0, 0.15))
legend("topright", legend=c("Historical", "Recent", paste0("t = ", round(dur.tt$statistic, 2)),
                            paste0("p = ", round(dur.tt$p.value, 3) )),
       col=c(brown, lav, NA, NA), pch=c(15, 15, NA, NA), pt.cex=3, bty="n",
       cex=1.5)
polygon(c(fd$x, rev(fd$x)),
        c(fd$y, rep(0, length(fd$y))),
        col=brown, border=brown)

polygon(c(fd.m$x, rev(fd.m$x)),
        c(fd.m$y, rep(0, length(fd.m$y))),
        col=lav, border=lav)
axis(1); axis(2)

# looks like conistra is still in but should be dropped; not in 1922, only 1919


volts <- as.data.frame(cbind(histb=historical$Broods, currb=historical$`Broods in iNat`))
colnames(volts)
volts$voltinism <- volts$histb
volts$voltinism[volts$histb%in%c(1) & volts$currb%in%c(1)] <- "1univoltine"
volts$voltinism[volts$histb%in%c(1) & volts$currb%in%c(2,3)] <- "2shift"
volts$voltinism[volts$histb%in%c(2,3) & volts$currb%in%c(1)] <- "2shift"
volts$voltinism[volts$histb%in%c(2,3) & volts$currb%in%c(2,3)] <- "3multivoltine"
volts$voltinism[volts$voltinism%in%c(1,2,3)] <- NA

volts <- volts[!sp.inat%in%excl.sp,]
plot(firstflight[,1], firstflight[,3],
     pch=19, col=c(lav, brown, sage)[factor(volts$voltinism)],
     cex=3)
abline(0, 1)

extant <- lastflight[,3]>0

lf1 <- lastflight[extant & !is.na(volts$voltinism),1]
lf3 <- lastflight[extant & !is.na(volts$voltinism),3]
vs <- as.numeric(factor(volts$voltinism[extant & !is.na(volts$voltinism)]))
# vs[vs%in%c(1,2)] <- 2
# vs[vs%in%c(3)] <- 1

par(pty="s")
plot(lf3 ~ lf1,
     pch=19, col=c(lav, brown, sage)[vs],
     cex=3)
# lme4::glmer(lf1 ~ lf3 + (1|vs),
#             family="poisson")


mod1 <- glm(lf3 ~ lf1 + vs + lf1*vs, family="poisson")

lines(exp(predict(mod1, newdata = data.frame(lf1=seq(20, 50, 1), vs=1))) ~ seq(20, 50, 1), col=lav, lwd=2)
lines(exp(predict(mod1, newdata = data.frame(lf1=seq(20, 50, 1), vs=2))) ~ seq(20, 50, 1), col=brown, lwd=2)
lines(exp(predict(mod1, newdata = data.frame(lf1=seq(20, 50, 1), vs=3))) ~ seq(20, 50, 1), col=sage, lwd=2)
p1 <- predict(mod1,newdata = data.frame(lf1=seq(20, 50, 1), vs=1), se.fit = T, type="response")
p2 <- predict(mod1,newdata = data.frame(lf1=seq(20, 50, 1), vs=2), se.fit = T, type="response")
p3 <- predict(mod1,newdata = data.frame(lf1=seq(20, 50, 1), vs=3), se.fit = T, type="response")

polygon(x = c(seq(20, 50, 1), seq(50, 20, -1)), y=c(p1$fit+p1$se.fit*1.96, rev(p1$fit+p1$se.fit*-1.96)),
        col=lav, border=lav)
polygon(x = c(seq(20, 50, 1), seq(50, 20, -1)), y=c(p2$fit+p2$se.fit*1.96, rev(p2$fit+p2$se.fit*-1.96)),
        col=brown, border=brown)
polygon(x = c(seq(20, 50, 1), seq(50, 20, -1)), y=c(p3$fit+p3$se.fit*1.96, rev(p3$fit+p3$se.fit*-1.96)),
        col=sage, border=sage)

#lines(exp(predict(mod1, newdata = data.frame(lf1=seq(20, 50, 1), vs=3))) ~ seq(20, 50, 1), col=sage, lwd=2)
abline(0, 1, lty=2, lwd=3)





ff1 <- firstflight[extant & !is.na(volts$voltinism),1]
ff3 <- firstflight[extant & !is.na(volts$voltinism),3]
vs <- as.numeric(factor(volts$voltinism[extant & !is.na(volts$voltinism)]))
# vs[vs%in%c(1,2)] <- 2
# vs[vs%in%c(3)] <- 1

par(pty="s")
plot(ff3 ~ ff1,
     pch=19, col=c(lav, brown, sage)[vs],
     cex=3)
# lme4::glmer(ff1 ~ ff3 + (1|vs),
#             family="poisson")


mod1 <- glm(ff3 ~ ff1 + vs + ff1*vs, family="poisson")

lines(exp(predict(mod1, newdata = data.frame(ff1=seq(10, 50, 1), vs=1))) ~ seq(10, 50, 1), col=lav, lwd=2)
lines(exp(predict(mod1, newdata = data.frame(ff1=seq(10, 50, 1), vs=2))) ~ seq(10, 50, 1), col=brown, lwd=2)
lines(exp(predict(mod1, newdata = data.frame(ff1=seq(10, 50, 1), vs=3))) ~ seq(10, 50, 1), col=sage, lwd=2)
p1 <- predict(mod1,newdata = data.frame(ff1=seq(10, 50, 1), vs=1), se.fit = T, type="response")
p2 <- predict(mod1,newdata = data.frame(ff1=seq(10, 50, 1), vs=2), se.fit = T, type="response")
p3 <- predict(mod1,newdata = data.frame(ff1=seq(10, 50, 1), vs=3), se.fit = T, type="response")

polygon(x = c(seq(10, 50, 1), seq(50, 10, -1)), y=c(p1$fit+p1$se.fit*1.96, rev(p1$fit+p1$se.fit*-1.96)),
        col=lav, border=lav)
polygon(x = c(seq(10, 50, 1), seq(50, 10, -1)), y=c(p2$fit+p2$se.fit*1.96, rev(p2$fit+p2$se.fit*-1.96)),
        col=brown, border=brown)
polygon(x = c(seq(10, 50, 1), seq(50, 10, -1)), y=c(p3$fit+p3$se.fit*1.96, rev(p3$fit+p3$se.fit*-1.96)),
        col=sage, border=sage)

#lines(exp(predict(mod1, newdata = data.frame(ff1=seq(10, 50, 1), vs=3))) ~ seq(10, 50, 1), col=sage, lwd=2)
abline(0, 1, lty=2, lwd=3)






dur1 <- duration[extant & !is.na(volts$voltinism),1]
dur3 <- duration[extant & !is.na(volts$voltinism),3]
vs <- as.numeric(factor(volts$voltinism[extant & !is.na(volts$voltinism)]))
# vs[vs%in%c(1,2)] <- 2
# vs[vs%in%c(3)] <- 1

par(pty="s")
plot(dur3 ~ dur1,
     pch=19, col=c(lav, brown, sage)[vs],
     cex=3)
# lme4::glmer(dur1 ~ dur3 + (1|vs),
#             family="poisson")


mod1 <- glm(dur3 ~ dur1 + vs + dur1*vs, family="poisson")

lines(exp(predict(mod1, newdata = data.frame(dur1=seq(0, 50, 1), vs=1))) ~ seq(0, 50, 1), col=lav, lwd=2)
lines(exp(predict(mod1, newdata = data.frame(dur1=seq(0, 50, 1), vs=2))) ~ seq(0, 50, 1), col=brown, lwd=2)
lines(exp(predict(mod1, newdata = data.frame(dur1=seq(0, 50, 1), vs=3))) ~ seq(0, 50, 1), col=sage, lwd=2)
p1 <- predict(mod1,newdata = data.frame(dur1=seq(0, 50, 1), vs=1), se.fit = T, type="response")
p2 <- predict(mod1,newdata = data.frame(dur1=seq(0, 50, 1), vs=2), se.fit = T, type="response")
p3 <- predict(mod1,newdata = data.frame(dur1=seq(0, 50, 1), vs=3), se.fit = T, type="response")

polygon(x = c(seq(0, 50, 1), seq(50, 0, -1)), y=c(p1$fit+p1$se.fit*1.96, rev(p1$fit+p1$se.fit*-1.96)),
        col=lav, border=lav)
polygon(x = c(seq(0, 50, 1), seq(50, 0, -1)), y=c(p2$fit+p2$se.fit*1.96, rev(p2$fit+p2$se.fit*-1.96)),
        col=brown, border=brown)
polygon(x = c(seq(0, 50, 1), seq(50, 0, -1)), y=c(p3$fit+p3$se.fit*1.96, rev(p3$fit+p3$se.fit*-1.96)),
        col=sage, border=sage)

#lines(exp(predict(mod1, newdata = data.frame(dur1=seq(0, 50, 1), vs=3))) ~ seq(0, 50, 1), col=sage, lwd=2)
abline(0, 1, lty=2, lwd=3)




leps <- ape::read.tree("C:/Users/egrames/Downloads/b7b9b77f-458d-49d2-90d8-2e6af50f2c8b/dataset-288943.nhx")

species[,2]%in%leps$tip.label

head(leps$tip.label)
species[,2]

grep(species[1,2], leps$tip.label)

matches <- c()

for(i in 1:nrow(species)){
  tmp <- grep(species[i,2], leps$tip.label)
  if(length(tmp)==0){
    tmp <- NA
  }
  matches[i] <- tmp
}

#savematchs <- matches

matches[species[,2]%in%"Feltia herilis"] <- 94238
matches[species[,2]%in%"Mythimna unipuncta"] <- 96542
matches[species[,2]%in%"Mythimna oxygala"] <- 96443
matches[species[,2]%in%"Nerice bidentata"] <- 104748
matches[species[,2]%in%"Apamea sordens"] <- 91100
matches[species[,2]%in%"Ponometia erastrioides"] <- 85365
matches[species[,2]%in%"Cecrita guttivitta"] <- 103870
matches[species[,2]%in%"Tetracis cachexiata"] <- 41059
matches[species[,2]%in%"Pantographa limata"] <- 135224
matches[species[,2]%in%"Evergestis straminalis"] <- 129755 # pallidata??
matches[species[,2]%in%"Algedonia mysippusalis"] <- 130794
matches[species[,2]%in%"Crambus vulgivagellus"] <- 128112


# For plotting only - using position of other members of the genus
matches[species[,2]%in%"Trichopolia incincta"] <- 98942 # tricopolia
matches[species[,2]%in%"Morrisonia confusa"] <- 87165 # auchmis?
matches[species[,2]%in%"Chytolita morbidalis"] <- 80074 # Zanclognatha ??
matches[species[,2]%in%"Fissicrambus mutabilis"] <- 128889 # fissicrambus
matches[species[,1]%in%"Baileya species"] <- 101972 # fissicrambus


species[is.na(matches), ]
# species[2,]

#cbind(species[dat.order,2], tre2$tip.label)
# leps$tip.label[grep("Baileya", leps$tip.label)]
# grep("Baileya", leps$tip.label)

#tre2 <- leps[matches,]
matches <- matches[!species[,2]%in%excl.sp]

leps2 <- ape::drop.tip(leps, which(!c(1:164574)%in%matches))
plot.phylo(leps2,show.node.label = F, type="fan")
# tre2 <- phylobase::subset(leps, tips.include=matches)

library(ape)
tre2 <- castor::get_subtree_with_tips(leps,
                                      only_tips = matches,
                                      collapse_monofurcations = T)$subtree

# plot.phylo(tre2$subtree, type="fan")

name.matching <- leps$tip.label[matches]

dat.order <- match(tre2$tip.label, name.matching)
#
tre2$tip.label
species[,2]

library(ape)
library(phylosignal)

# phenol.dat <- cbind(firstflight, lastflight, duration)[dat.order,]

ffhist <- apply(firstflight[,1:2], 1, min, na.rm=T)[!species[,2]%in%excl.sp]
lfhist <- apply(lastflight[,1:2], 1, max, na.rm=T)[!species[,2]%in%excl.sp]
duhist <- apply(duration[,1:2], 1, max, na.rm=T)[!species[,2]%in%excl.sp]

phenol.dat <- cbind(ffhist, firstflight[!species[,2]%in%excl.sp,3],
                    lfhist, lastflight[!species[,2]%in%excl.sp,3],
                    duhist, duration[!species[,2]%in%excl.sp,3])[dat.order,]

colnames(phenol.dat) <- paste(rep(c("first flight", "last flight", "flight duration"), each=2),
                              c("1919-1922", "2019-2023"))

phenol.dat <- cbind(phenol.dat, phenol.dat[,2]-phenol.dat[,1],
                    phenol.dat[,4]-phenol.dat[,3],
                    phenol.dat[,6]-phenol.dat[,5])

phenol.dat[is.na(phenol.dat)] <- 0
phenol.dat[phenol.dat<c(-99)] <- 0
phenol.dat[phenol.dat>99] <- 0

phenol.dat

#
# phenol.dat <- cbind(ffhist, firstflight[,3]-ffhist,
#                     lfhist, lastflight[,3]-lfhist,
#                     duhist, duration[,3]-duhist)[dat.order,]
#
# colnames(phenol.dat) <- paste(rep(c("first flight", "last flight", "flight duration"), each=2),
#                               c("1919-1922", "2019-2023"))
#
# phenol.dat[is.na(phenol.dat)] <- 0
# phenol.dat[phenol.dat<0] <- 0
# phenol.dat[phenol.dat>99] <- 0
# #
# tre2$edge.length[5] <- 5
# tre2$edge.length[tre2$edge[,2]==4] <- 4
#
# grep("tentorif", tre2$tip.label)
#


# phenol.dat[,1:2] <- apply(phenol.dat[,1:2], 2, scale)
# phenol.dat[,3:4] <- apply(phenol.dat[,3:4], 2, scale)
# phenol.dat[,5:6] <- apply(phenol.dat[,5:6], 2, scale)

tree3 <- phylo4d(tre2, phenol.dat)

phyloSignal(tree3)
# dev.off()
# tree3@label <- species[dat.order, 2]
species[22,2] <- "Baileya sp."
tipLabels(tree3) <- species[!species[,2]%in%excl.sp,][dat.order, 2]
# species <- species[!species[,2]%in%excl.sp[7],]
# species <- species[!species[,1]%in%excl.sp[7],]
# tree4 <- collapse.singles(tree3)
library(phylobase)
library(phylosignal)
gridplot(tree3[,1:9], tree.type="cladogram",
         grid.vertical=F, show.color.scale=T,
         scale=F, center=F, tip.cex=.85,
         trait.bg.col="white",
         show.trait=F,
         tree.ratio=.2,
         tree.open.angle=45, use.edge.length=F,
         cell.col=colorRampPalette(c("white",
                                     lav,
                                     "#351431"))(30))


# nodelabels("Geometridae", 8)
nl <- leps2$node.label
nl[-c(3, 10, 14, 21, 29, 30, 34)] <- NA
nl[30] <- "Tortricidae"
nodelabels(nl,
           bg = "#00000000", frame = "none",
           cex=.85)
nodelabels()

# ape::plot.phylo(tre2, type="fan", show.tip.label = F)

lastflight[1,]

which(species[,2]=="Caenurgina crassiuscula")

lastflight[24,]
tree3
summary(mod1)

plot(exp(predict(mod1))
     
     abline(exp(2.8), 0.016)
     abline(mod1)
     abline(0, 1)
     
     plot(duration[,1], duration[,3],
          pch=19, col=c(lav, brown, sage)[factor(volts$voltinism)],
          cex=3)
     abline(0, 1)
     
     hweath <- read.csv("../PRISM_ppt_tmin_tmean_tmax_stable_4km_191901_192201_42.4520_-76.4737.csv", skip=10)
     head(hweath)
     
     cweath <- read.csv("../PRISM_ppt_tmin_tmean_tmax_stable_4km_201901_202201_42.4520_-76.4737.csv", skip=10)
     head(cweath)
     
     plot(cweath$tmean..degrees.C. ~ hweath$tmean..degrees.C.)
     abline(0,1)
     
     plot(cweath$tmean..degrees.C.)
     
     plot()
     lines(density(unlist(firstflight[,3])[!is.na(unlist(firstflight[,3]))]), col="red")
     
     plot(density(unlist(lastflight[,1:2])[!is.na(unlist(lastflight[,1:2]))]))
     lines(density(unlist(lastflight[,3])[!is.na(unlist(lastflight[,3]))]), col="red")
     
     plot(density(unlist(duration[,1:2])[!is.na(unlist(duration[,1:2]))]))
     lines(density(unlist(duration[,3])[!is.na(unlist(duration[,3]))]), col="red")
     
     historical$Broods[grep("early", historical$Broods)] <- 2
     historical$Broods <- as.numeric(historical$Broods)
     
     
     table(historical$Broods, historical$`Broods in iNat`)
     
     dat.b <- as.data.frame((rbind(prop.table(table(historical$Broods)),
                                   prop.table(table(historical$`Broods in iNat`)[-1]))))
     
     barplot(t(dat.b), col=rev(c("#644899", "#8d70c4", lav)), border=F, width = c(.25, .25),
             xlim=c(0, 1))
     par(xpd=T)
     text(x=c(0.25, 0.5), y=c(-.01, -.01), c("Historical", "iNaturalist"), srt=45, adj=1, cex=1.25)
     legend("topright", legend=c("Univoltine", "Bivoltine", "Multivoltine"),
            col=rev(c("#644899", "#8d70c4", lav)), pch=15, pt.cex=3, cex=1.5, bty="n")
     
     
     axis(1, at=c(0.5, 1), labels=c("Historical", "iNaturalist"))
     
     #hist2 <- historical[!sp.inat%in%excl.sp,]
     bp <- barplot(unlist(as.data.frame((rbind(prop.table(table(historical$Broods)),
                                               prop.table(table(historical$`Broods in iNat`)[-1]))))),
                   col=c(lav, brown), border=F, axes=F, names.arg = F)
     
     axis(2)
     axis(1, at=c(1.3, 3.7, 6.1),
          labels = c("One flight", "Two flights", "Three flights"),
          tick = F)
     
     
     species[(species[,2]%in%names( table(inat$scientific_name[as.numeric(inat$week)>40])) & species[,1]%in%names(table(historical$`Species name`[historical$`1922Last`>35]))),]
     #sp                              sp.inat                  
     # [1,] "Cirphis unipuncta"             "Mythimna unipuncta"   # drop from analysis - marked as 'nov'  
     # [2,] "Autographa precationis"        "Autographa precationis" # drop 1922 from analysis - obs in week 40
     # [3,] "Epizeuxis aemula"              "Idia aemula"            # drop - obs in week 40
     # [4,] "Plathypena scabra"             "Hypena scabra"          # drop from analysis - marked as 'nov'
     # [5,] "Pleuroprucha insulsaria"       "Pleuroprucha insulsaria" # drop, obs in oct
     # [6,] "Ellopia (Therina) fiscellaria" "Lambdina fiscellaria"   # drop, obs in oct
     # [7,] "Sabulodes transverata"         "Prochoerodes lineola"   # stays!
     #
     
     excl.sp <- c("Mythimna unipuncta", "Autographa precationis", "Idia aemula",
                  "Hypena scabra", "Pleuroprucha insularia", "Lambdina fiscellaria", "Orthosia hibisci")
     # and exclude Orthosia hibisci -- too early
     
     species[(species[,2]%in%names(table(inat$scientific_name[as.numeric(inat$week)<18])) & species[,1]%in%names(table(historical$`Species name`[historical$`1922Last`<19]))),]
     
     species[,1][which(historical$Broods>historical$`Broods in iNat`)]
     
     barplot(table(historical$Broods))
     barplot(table(historical$`Broods in iNat`)[-1])
     
     
     pdf(file = "../check_broods_inat.pdf", width = 7, height=3)
     for(i in 1:nrow(species)){
       tmp <- inat[inat$scientific_name==species[i,2],]
       barplot(table(tmp$week), main=paste(species[i,1], species[i,2], sep=" || "), col="black", border=F)
       #plot(density(as.numeric(tmp$week)))
     }
     dev.off()
     
     
     
     
     # hist(firstflight[,1:2], col="#ff000088", border=F, 20)
     # hist(firstflight[,3], col="#0000ff88", border=F, 30, add=T)
     #
     # hist(firstflight[,1:2], col="#ff000088", border=F, 20)
     # hist(firstflight[,3], col="#0000ff88", border=F, 30, add=T)
     #
     
     # hist.counts <- as.data.frame(historical[,c(2,12, 23:70)])
     # hist.counts[1,3:ncol(hist.counts)] <- paste0("Week_", hist.counts[1,3:ncol(hist.counts)])
     # head(hist.counts)
     # colnames(hist.counts) <- hist.counts[1,]
     # hist.counts <- hist.counts[-1,]
     # hist.counts$`Name change?`[is.na(hist.counts$`Name change?`)] <- hist.counts$`Species name`[is.na(hist.counts$`Name change?`)]
     #
     # hist.counts <- hist.counts[!apply(hist.counts[,-c(1:2)], 1, function(x){
     #   all(is.na(x))
     # }),]
     #
     # species <- unique(inat$scientific_name)
     # species <- species[species%in%hist.counts$`Name change?`]
     # pdf(file = "../iNat_phenology_hist.pdf")
     # min.dat <- end.dat <- c()
     # par(las=1, cex.names=0.7)
     # for(i in 1:length(species)){
     #   tmp <- inat[inat$scientific_name==species[i],]
     #   barplot(prop.table(table(tmp$week)), xlim=c(1, 52), col="black", border=F,
     #           main=species[i], xlab="Week of year", ylab="# Observations", cex.names = 0.7,
     #           ylim=c(-1,1))
     #   old <- hist.counts[hist.counts$`Name change?`==species[i],]
     #   x19 <- old[,3:26]
     #   x22 <- old[,27:50]
     #  
     #   x19 <- as.data.frame(cbind(colnames(x19), t(x19[1,]), t(x22[1,])))
     #   x19$V1 <- as.numeric(gsub("Week_", "", x19$V1))
     #   colnames(x19)[2:3] <- c("A", "B")
     #   x19$A <- as.numeric(x19$A)
     #   x19$B <- as.numeric(x19$B)
     #  
     #   x19$count <- rowSums(x19[,2:3], na.rm=T)
     #   tmp.count <- c()
     #   for(j in 1:nrow(x19)){
     #     if(!is.na(x19$count[j])){
     #       tmp.count <- append(tmp.count, rep(x19$V1[j], x19$count[j]))
     #      
     #     }
     #   }
     #   tmp.count <- factor(append(tmp.count, 1:52))[1:length(tmp.count)]
     #  
     #   barplot(prop.table(table(tmp$week)), xlim=c(1, 52), col="black", border=F,
     #           main=species[i], xlab="Week of year", ylab="# Observations", cex.names = 0.7,
     #           ylim=c(-1,1))
     #   barplot(-prop.table(table(tmp.count)), add=T, col="grey80", border=F, names.arg = F)
     #  
     #   # min.dat[i] <- min(as.numeric(tmp$week))
     #   # end.dat[i] <- max(as.numeric(tmp$week))
     # }
     # dev.off()
     #
     # lubridate::week("1919-06-01")
     # lubridate::week("1922-05-01")
     # lubridate::week("1919-09-01")