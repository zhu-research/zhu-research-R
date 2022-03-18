#' @title Clean and Calibrate PurpleAir
#' @author Jonathan Liu
#' @description Clean PurpleAir data using QA/QC methods from either the manufacturer or the EPA
#' @param PA_df PurpleAir data frame, should be read in with fread (data.table) to preserve column names properly.
#' @param criteria Either "manufacture" (default) or "epa" for EPA cleaning criteria.
#' @param calibrate Whether or not you want to calibrate values using US EPA's correction curve. If TRUE (default), produces an additional column (pm2.5_cal) with calibrated values.
#' @import dplyr
#' @export

clean_PA <- function(PA_df, criteria = "manufacture", calibrate = TRUE) {

  if(criteria %in% c("manufacture", "epa")) {
    temp <- PA_df %>%
      rename(pm2.5 = "PM2.5_CF_ATM_ug/m3_A", # renaming
             pm2.5.a = "PM2.5_CF_1_ug/m3_A",
             pm2.5b = "PM2.5_CF_ATM_ug/m3_B",
             pm2.5.ab = "PM2.5_CF_1_ug/m3_B",
             temp = "Temperature_F_A",
             humi = "Humidity_%_A",
             date.time = "created_at") %>%
      mutate(pm2.5_diff = abs(pm2.5-pm2.5b), # cleaning
             pm2.5_mean = (pm2.5+pm2.5b)/2,
             pm2.5_ratio = pm2.5_diff/pm2.5_mean,
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
>>>>>>> 3dd6e1b9b9daa6a3d187fdf0a30a3f785ef1a3ab
             # pm2.5_diff_sd = sd(pm2.5_diff, na.rm=T), # this is EPA criteria, which we are not using(?)
             # pm2.5_zscore = abs(pm2.5_diff-pm2.5_diff_mean)/pm2.5_diff_sd,
             # ex1 = ifelse(abs(pm2.5_diff) >= 5, 1,0),
             # ex2 = ifelse(abs(pm2.5_zscore) >= 2, 1,0), # 2 standard deviations from the mean
<<<<<<< HEAD
=======
>>>>>>> e6ca5dc8611c0483fa81baa68f13cfd28c1d1f34
>>>>>>> 3dd6e1b9b9daa6a3d187fdf0a30a3f785ef1a3ab
             ex1 = ifelse(pm2.5 < 100 & pm2.5_diff >= 10, 1,0), # manufacturer's standard
             ex1 = ifelse(pm2.5 >= 100 & pm2.5_ratio >= 0.1, 1,ex1),# replace ex1 with 2nd exclusion criteria if
             pm2.5 = ifelse(ex1 == 0, (pm2.5+pm2.5b)/2, NA)) %>%
      filter((temp >= -200) | (temp <= 1000) | (humi >= 0) | (humi <= 100))

    if(criteria == "epa") {
      PA_df2 <- temp %>%
        mutate(
          pm2.5_diff_mean = mean(pm2.5_diff, na.rm=T),
          pm2.5_diff_sd = sd(pm2.5_diff, na.rm=T), # this is EPA criteria, which we are not using(?)
          pm2.5_zscore = abs(pm2.5_diff-pm2.5_diff_mean)/pm2.5_diff_sd,
          ex1 = ifelse(abs(pm2.5_diff) >= 5, 1,0),
          ex2 = ifelse(abs(pm2.5_zscore) >= 2, 1,0), # 2 standard deviations from the mean
          pm2.5 = ifelse(ex1 == 0 | ex2 == 0, (pm2.5+pm2.5b)/2, NA)
        ) %>%
        filter(!is.na(pm2.5))
    } else if (criteria == "manufacture") {
      PA_df2 <- temp %>%
        mutate(
          ex1 = ifelse(pm2.5 < 100 & pm2.5_diff >= 10, 1,0), # manufacturer's standard
          ex1 = ifelse(pm2.5 >= 100 & pm2.5_ratio >= 0.1, 1,ex1),# replace ex1 with 2nd exclusion criteria if
          pm2.5 = ifelse(ex1 == 0, (pm2.5+pm2.5b)/2, NA)
      ) %>%
        filter(!is.na(pm2.5))

    }

    if(calibrate) {
      PA_df3 <- PA_df2 %>%
        mutate(pm2.5_cal = ifelse(pm2.5 <= 343, 0.52*pm2.5-0.086*humi+5.75, 0.46*pm2.5+3.93*pm2.5^2+2.97))
    }

    return(PA_df3)


  } else {
    return("Please enter a valid cleaning criteria")
  }



}
