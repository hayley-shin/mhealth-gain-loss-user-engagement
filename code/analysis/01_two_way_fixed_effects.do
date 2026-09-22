/*=========================
2024-11-22
Two-Way Fixed Effects Model
=========================*/

// Data : Panel_Challengers_df_v4.dta


* 1. Load Data
set more off
use Panel_Challengers_df_v4, clear


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
// uc_result (그냥 변환)
encode uc_result, generate(uc_result_factor)
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
// uc_deposit_K (low, medium, high) (25%/75%)
gen uc_deposit_K_LMH = 1 if uc_deposit_K <= 10
replace uc_deposit_K_LMH = 2 if (10 < uc_deposit_K) & (uc_deposit_K <= 100)
replace uc_deposit_K_LMH = 3 if uc_deposit_K > 100
label define uc_deposit_K_LMH_label 1 "low" 2 "medium" 3 "high"
label values uc_deposit_K_LMH uc_deposit_K_LMH_label
// uc_deposit_K (low, high) (50%)
gen uc_deposit_K_LH = 1 if uc_deposit_K <= 20
replace uc_deposit_K_LH = 2 if uc_deposit_K > 20
label define uc_deposit_K_LH_label 1 "low" 2 "high"
label values uc_deposit_K_LH uc_deposit_K_LH_label
// uc_ach_rate_diff2_100 (neg, 0, pos)
gen uc_ach_rate_diff_0NP = 1 if uc_ach_rate_diff2_100 == 0
replace uc_ach_rate_diff_0NP = 2 if uc_ach_rate_diff2_100 < 0
replace uc_ach_rate_diff_0NP = 3 if uc_ach_rate_diff2_100 > 0
label define uc_ach_rate_diff_0NP_label 1 "zero" 2 "neg" 3 "pos"
label values uc_ach_rate_diff_0NP uc_ach_rate_diff_0NP_label



* 3. Two-Way Fixed Effects Models

* RQ1: Association between financial outcomes and subsequent participation timing
// (uc_result) Baseline model without interaction terms
reghdfe uc_days_nextChallenge_noNeg ///
		i.uc_result /// 
		uc_deposit_K uc_ach_rate_cumMean_before_100 ///
		uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit_K chlng_regiCnt ///
		i.chlng_startDate_yearMonth ///
		if uc_deposit != 0 ///
		, absorb(user_id chlng_id) cluster(user_id) cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)
		
* RQ2: Moderating effect of deposit amount on the relationship between financial outcomes and subsequent participation timing
// (uc_result) Financial outcome × deposit amount (+ Time Fixed Effects, Control Variables)
reghdfe uc_days_nextChallenge_noNeg ///
		i.uc_result /// 
		c.uc_deposit_K#i.uc_result ///
		uc_deposit_K uc_ach_rate_cumMean_before_100 ///
		uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit_K chlng_regiCnt ///
		i.chlng_startDate_yearMonth ///
		if uc_deposit != 0 ///
		, absorb(user_id chlng_id) cluster(user_id) cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)
		
* RQ3: Moderating effect of prior performance on the relationship between financial outcomes and subsequent participation timing
// (uc_result) Financial outcome × prior achievement rate (+ Time Fixed Effects, Control Variables)
reghdfe uc_days_nextChallenge_noNeg ///
		i.uc_result /// 
		c.uc_ach_rate_cumMean_before_100#i.uc_result ///
		uc_deposit_K uc_ach_rate_cumMean_before_100 ///
		uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit chlng_regiCnt ///
		i.chlng_startDate_yearMonth ///
		if uc_deposit != 0 ///
		, absorb(user_id chlng_id) cluster(user_id) cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)


* 4. Additional Analysis
* Examine whether financial outcomes are associated with changes in the deposit amount for the subsequent challenge
reghdfe uc_deposit_diffNext_K ///
		i.uc_result /// 
		uc_deposit_K uc_ach_rate_cumMean_before_100 /// 
		uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit_K chlng_regiCnt ///
		i.chlng_startDate_yearMonth ///
		if (uc_deposit != 0) ///
		, absorb(user_id chlng_id) cluster(user_id) cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)

		
* 5. Robustness Check
* Examine participation in zero-deposit challenges

// Financial outcome specification
reghdfe uc_days_nextChallenge_noNeg ///
		i.uc_result /// 
		uc_deposit_K uc_ach_rate_cumMean_before_100 ///
		uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit_K chlng_regiCnt ///
		i.chlng_startDate_yearMonth ///
		if uc_deposit == 0 ///
		, absorb(user_id chlng_id) cluster(user_id) cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)

// Achievement-rate specification
reghdfe uc_days_nextChallenge_noNeg ///
		uc_ach_rate_100 /// 
		uc_deposit_K uc_ach_rate_cumMean_before_100 ///
		uc_feeds i.goal_category_level1 goal_req_feedsPerDay i.goal_dayOrPeriod chlng_period chlng_deposit_K chlng_regiCnt ///
		i.chlng_startDate_yearMonth ///
		if uc_deposit == 0 ///
		, absorb(user_id chlng_id) cluster(user_id) cformat(%9.3f) pformat(%5.3f) sformat(%8.3f)











