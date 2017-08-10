library(VIM)

data = read.csv("ships2.csv")

head(data)
str(data)

mrt_data = data[!is.na(data$mrt_liverfat_s2),]

head(mrt_data)
str(mrt_data)

write.csv(file = "mrt_data.csv",x = mrt_data)

factor_data = mrt_data[c(-1,-5,-12,-15,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-40)]

str(factor_data)

write.csv(file = "factor_data.csv",x = factor_data)

factor_data1 = read.csv("factor_data.csv")

head(factor_data1)
str(factor_data1)

factor_data_impute = kNN(factor_data1)

write.csv(file = "factor_data_impute.csv",x = factor_data_impute)

head(factor_data_impute)
str(factor_data_impute)

factor_data_impute1 = factor_data_impute[c(-33:-64)]

write.csv(file = "factor_data_impute.csv",x = factor_data_impute1)

str(factor_data_impute1)

ship2$age_ship_s2[ship2$age_ship_s2 >= "20" & ship2$age_ship_s2 < "30"] <- "20-30"

write.csv(file = "Age_Discrete.csv",x = ship2)

str(age)
age = read.csv("Age_Discrete.csv")

age$mrt_liverfat_s2[age$mrt_liverfat_s2 >= "0" & age$mrt_liverfat_s2 < "10"] <- "0-10"
age$mrt_liverfat_s2[age$mrt_liverfat_s2 >= "25"] <- "25-45"
age$mrt_liverfat_s2 = as.factor(age$mrt_liverfat_s2)
write.csv(file = "mrt_discrete.csv",x = age)

data_mrt = read.csv("mrt_discrete.csv")