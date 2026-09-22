/*=========================
2024-11-22
Survival Analysis
=========================*/

// Data : Panel_SurvivalAnalysis_Challengers_df_v2.dta


* 1. Load Data
set more off
use Panel_SurvivalAnalysis_Challengers_df_v2, clear


* 2. Preprocessing - Convert string variables to numeric categorical variables
// goal_category_level1
encode goal_category_level1, generate(goal_category_level1_f)
drop goal_category_level1
rename goal_category_level1_f goal_category_level1
// goal_category_level2
encode goal_category_level2, generate(goal_category_level2_f)
drop goal_category_level2
rename goal_category_level2_f goal_category_level2
// goal_category_level3
encode goal_category_level3, generate(goal_category_level3_f)
drop goal_category_level3
rename goal_category_level3_f goal_category_level3
// goal_dayOrPeriod
encode goal_dayOrPeriod, generate(goal_dayOrPeriod_f)
drop goal_dayOrPeriod
rename goal_dayOrPeriod_f goal_dayOrPeriod
// user_createdAt_yearMonth
encode user_createdAt_yearMonth, generate(user_createdAt_yearMonth_f)
drop user_createdAt_yearMonth
rename user_createdAt_yearMonth_f user_createdAt_yearMonth
// user_sex
encode user_sex, generate(user_sex_f)
drop user_sex
rename user_sex_f user_sex
// chlng_type
encode chlng_type, generate(chlng_type_f)
drop chlng_type
rename chlng_type_f chlng_type
// chlng_startDate_yearMonth
encode chlng_startDate_yearMonth, generate(chlng_startDate_yearMonth_f)
drop chlng_startDate_yearMonth
rename chlng_startDate_yearMonth_f chlng_startDate_yearMonth
// chlng_endDate_yearMonth
encode chlng_endDate_yearMonth, generate(chlng_endDate_yearMonth_f)
drop chlng_endDate_yearMonth
rename chlng_endDate_yearMonth_f chlng_endDate_yearMonth
// uc_publicType
encode uc_publicType, generate(uc_publicType_f)
drop uc_publicType
rename uc_publicType_f uc_publicType
// uc_result
gen uc_result_num = 1 if uc_result == "OVER_EIGHTY_FIVE"
replace uc_result_num = 2 if uc_result == "NORMAL"
replace uc_result_num = 3 if uc_result == "OVER_HUNDRED"
label define uc_result_label 1 "OVER_EIGHTY_FIVE" 2 "NORMAL" 3 "OVER_HUNDRED"
label values uc_result_num uc_result_label
drop uc_result
rename uc_result_num uc_result
// uc_failure_rate
gen uc_failure_rate = 100 - uc_ach_rate if uc_ach_rate < 100
replace uc_failure_rate = 0 if uc_ach_rate >= 100
* Loss/Gain High/Low 변수 생성 (Deposit Mean: 59917.62)
// Loss High
gen uc_result_HighLoss = 0
replace uc_result_HighLoss = 1 if (uc_result == 2) & (uc_deposit >= 60000)
// Loss Low
gen uc_result_LowLoss = 0
replace uc_result_LowLoss = 1 if (uc_result == 2) & (uc_deposit < 60000)
// Gain High
gen uc_result_HighGain = 0
replace uc_result_HighGain = 1 if (uc_result == 3) & (uc_deposit >= 60000)
// Gain High
gen uc_result_LowGain = 0
replace uc_result_LowGain = 1 if (uc_result == 3) & (uc_deposit < 60000)
* AchievementRateDiff X Result
// Result Loss, PastResult Loss
gen uc_ResultL_PastResultL = 0
replace uc_ResultL_PastResultL = 1 if (uc_result == 2) & (uc_ach_rate_cumMean_before < 85)
// Result Loss, PastResult Neutral
gen uc_ResultL_PastResultN = 0
replace uc_ResultL_PastResultN = 1 if (uc_result == 2) & (uc_ach_rate_cumMean_before >= 85) & (uc_ach_rate_cumMean_before < 100)
// Result Loss, PastResult Gain
gen uc_ResultL_PastResultG = 0
replace uc_ResultL_PastResultG = 1 if (uc_result == 2) & (uc_ach_rate_cumMean_before == 100)
// Result Neutral, PastResult Loss
gen uc_ResultN_PastResultL = 0
replace uc_ResultN_PastResultL = 1 if (uc_result == 1) & (uc_ach_rate_cumMean_before < 85)
// Result Neutral, PastResult Neutral
gen uc_ResultN_PastResultN = 0
replace uc_ResultN_PastResultN = 1 if (uc_result == 1) & (uc_ach_rate_cumMean_before >= 85) & (uc_ach_rate_cumMean_before < 100)
// Result Neutral, PastResult Gain
gen uc_ResultN_PastResultG = 0
replace uc_ResultN_PastResultG = 1 if (uc_result == 1) & (uc_ach_rate_cumMean_before == 100)
// Result Gain, PastResult Loss
gen uc_ResultG_PastResultL = 0
replace uc_ResultG_PastResultL = 1 if (uc_result == 3) & (uc_ach_rate_cumMean_before < 85)
// Result Gain, PastResult Neutral
gen uc_ResultG_PastResultN = 0
replace uc_ResultG_PastResultN = 1 if (uc_result == 3) & (uc_ach_rate_cumMean_before >= 85) & (uc_ach_rate_cumMean_before < 100)
// Result Gain, PastResult Gain
gen uc_ResultG_PastResultG = 0
replace uc_ResultG_PastResultG = 1 if (uc_result == 3) & (uc_ach_rate_cumMean_before == 100)


* 3. Accelerated Failure Time (AFT) Model


* 3.1 stset
stset uc_days_nextChallenge_noNeg_p1, fail(uc_nextChallenge=1)
tab  _st
tab _d


* 3.2 Main

// All Challenges (Time Ratio)
streg i.uc_result ///
	  uc_deposit_K uc_ach_rate_cumMean_before uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit chlng_regiCnt user_age i.user_sex /// 
	  if uc_deposit != 0 ///
	  , distribution(weibull) time tr nolog allbaselevels cformat(%9.3f) pformat(%5.3f) sformat(%8.3f) 
	  
// All Challenges (Coefficient)
streg i.uc_result ///
	  uc_deposit_K uc_ach_rate_cumMean_before uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit chlng_regiCnt user_age i.user_sex /// 
	  if uc_deposit != 0 ///
	  , distribution(weibull) time nolog allbaselevels cformat(%9.3f) pformat(%5.3f) sformat(%8.3f) 
	  
// Cox PH
stcox i.uc_result ///
	  uc_deposit_K uc_ach_rate_cumMean_before uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit chlng_regiCnt user_age i.user_sex /// 
	  if uc_deposit != 0 ///
	  , strata(user_id) allbaselevels nolog cformat(%9.3f) pformat(%5.3f) sformat(%8.3f) vce(cluster user_id)












