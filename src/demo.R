library(quantmod)
library(markovchain)
library(dplyr)
library(ggplot2)
library(xts)

# load data
data <- getSymbols("BID.VN", from = "2020-01-01", to = "2023-12-31", auto.assign = F)
summary(data)
nrow(data)
head(data, n = 10)

# chuyển data dạng xts thành data frame
data_df <- as.data.frame(data)
data_df$dates <- index(data)
rownames(data_df) <- NULL
head(data_df, n = 10)
# loại bỏ các cột không cần thiết
date_df <- na.omit(data_df)
data_df <- subset(data_df, select = -c(BID.VN.Open, BID.VN.High, BID.VN.Low, BID.VN.Volume, BID.VN.Adjusted))

# thêm cột price_diff: chênh lệch giá đóng cửa giữa 2 ngày liên tiếp
data_df$price_diff <- c(NA, diff(data_df$BID.VN.Close))
head(data_df, n = 10)

# tạo cột trạng thái xu hướng
data_df$trend_state[data_df$price_diff == 0] <- "Stable"
data_df$trend_state[data_df$price_diff > 0] <- "Up"
data_df$trend_state[data_df$price_diff < 0] <- "Down"
head(data_df, n = 10)

# tạo markov chain cho các trạng thái về xu hướng
fitted_trend_mc <- markovchainFit(data = data_df$trend_state, method = "mle")
trend_mc <- fitted_trend_mc$estimate
print(trend_mc)
steadyStates(trend_mc)

# biên độ dao dộng giá quy định trên sàn HOSE
rate = 0.07
# chia biên độ này thành 5 khoảng ứng với 5 trạng thái
rate_bins <- seq(from = -rate, to = rate, length.out = 6)
print(rate_bins)

for (i in seq(2, nrow(data_df))){
  data_df$change_rates[i] <- data_df$price_diff[i] / data_df$BID.VN.Close[i - 1]
}
head(data_df, n = 10)

data_df$change_rates<- cut(data_df$change_rates, breaks = rate_bins)
head(data_df, n = 10)

labels = c(1,2,3,4,5)
data_df$change_rates_state <- factor(data_df$change_rates, labels = labels, exclude = NA)
head(data_df, n = 10)

fitted_change_mc <- markovchainFit(data_df$change_rates_state, method = "mle")
change_mc <- fitted_change_mc$estimate
print(change_mc)

initial_state <- c(0,1,0,0,0)
initial_state * change_mc

test_data <- getSymbols("BID.VN", from = "2024-01-01", to = Sys.Date(), auto.assign = F)
head(test_data, n=10)
nrow(test_data)
print(test_data)
