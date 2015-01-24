# NFL Historic Data
# Want to understand performance by wealth
# Performance is measured in winning pct as well as a homebaked formula
# which adds points for making playoffs, making super bowl, and winning superbowl
# Wealth is measured relatively by the 2014 Forbes Wealth ranking of NFL teams
# http://www.forbes.com/sites/mikeozanian/2014/08/20/the-nfls-most-valuable-teams/

setwd("~/Google Drive/NFL")

# Load libraries
require(ggplot2)

df.nfl <- read.csv("nfl_historic_forbes_data.csv")

# Make the program wait a second to process the data frame
Sys.sleep(1)

# Transform so 1 is lowest, 32 largest (makes scatterplots easier to interpret)
df.nfl$RankByWL <- ((( df.nfl$RankByWL - 32 ) * -1) + 1)
df.nfl$RankByWLPostseason <- ((( df.nfl$RankByWLPostseason - 32 ) * -1) + 1)
df.nfl$Forbes2014Rank <- ((( df.nfl$Forbes2014Rank - 32 ) * -1) + 1)

# Then plot by WLRank
png("nfl_historical_winning.png", width=480, height=480, units="px", res=72)
ggplot(df.nfl, aes(x=RankByWL, y=W.L., label=Team, fill=Conference))  + geom_bar(stat="identity")  + geom_text(aes(x=RankByWL, y=W.L., label=Team, size=1, angle=90)) + ylab("Historical Winning %") + xlab("Rank Order") + ggtitle("Historical Win/Loss % of NFL Teams")   
dev.off()

# Reorder data set by ForbesRanking ASC
df.nfl <- df.nfl[order(df.nfl$Forbes2014Rank),]

# Add a Rank order
df.nfl$ForbesRank <- c(1:32)


# Then plot by Forbes Ranking
png("nfl_2014_forbes_ranking.png", width=480, height=480, units="px", res=72)
ggplot(df.nfl, aes(x=ForbesRank, y=Forbes2014Rank, label=Team, fill=Conference))  + geom_bar(stat="identity")  + geom_text(aes(x=ForbesRank, y=Forbes2014Rank, label=Team, size=1, angle=90)) + ylab("Relative Team Worth (1=Lowest)") + xlab("Rank Order") + ggtitle("Relative Team Worth of NFL Teams")
dev.off()

View(df.nfl)

# View "RROI", Relative Return on Team Investment, which is the delta between the value of the team
# and its historical winning & winning performance ($ - perf, smaller numbers better). 
# Do not use postseason because it is not normalized by the number of years 
# (unfair since Bears have been around forever)
df.nfl$RROI <- df.nfl$Forbes2014Rank - df.nfl$RankByWL


# Teams with a high RROI mean they are a waste of money, teams with low RROI were a relatively great investment
# High historical WL%, lower relative cost/value

View(df.nfl)

# Best team by RROI = Oakland Raiders, Worst team = Houston Texans
# Let's see how the teams stack up next to one another
png("nfl_rroi_unsorted.png", width=480, height=480, units="px", res=72)
ggplot(df.nfl, aes(x=Forbes2014Rank, y=RROI, label=Team, fill=Conference))  + geom_bar(stat="identity")  + geom_text(aes(x=Forbes2014Rank, y=RROI, label=Team, size=1, angle=90))
dev.off()

# Reorder data set by RROI ASC
df.nfl <- df.nfl[order(df.nfl$RROI),]

# In order to sort teams by relative return on investment, need to make a ranking
df.nfl$RROIRank <- c(1:32)

# Then plot the new ordering
png("nfl_rroi_sorted.png", width=480, height=480, units="px", res=72)
ggplot(df.nfl, aes(x=RROIRank, y=RROI, label=Team, fill=Conference))  + geom_bar(stat="identity")  + geom_text(aes(x=RROIRank, y=RROI, label=Team, size=1, angle=90)) + ylab("Relative ROI (Cost - Performance)") + xlab("Rank Order") + ggtitle("Relative ROI on NFL Teams")
dev.off()

###############################
