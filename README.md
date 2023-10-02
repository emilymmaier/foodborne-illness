# foodborne-illness
Identify symptom keywords from online data occuring in the five weeks before and after foodborne illness cases are reported that have a significant correlation to case incidence. For more information on cross-correlation analysis and the ccf funtion in R, click [here](https://online.stat.psu.edu/stat510/lesson/8/8.2).

## Dependencies
- Written in R version 4.1.2
- Requires stringr

## Usage
All data files to be analyzed must:
- be contained in a single directory which does not contain any unnecessary files
- be in csv format
- be name according to the following convention using underscores to separate information:

  `illness_dataSource_samplingFrequency.csv`

  illness: Type of foodborne illness for which cases were quantified

  dataSource: Website from which symptom keyword occurances were quantified

  samplingFrequency: How often number of cases and number of symptom keyword occurences were measured (ie. daily, weekly, monthly, etc.). Sampling frequency must be consistent   for number of cases and number of symptom keyword occurences.
  
  
- have the following order of columns, with an unlimited number of symptoms:

  ```
  date        nCases  symptom1  symptom2  symptom3  ...
  2019-01-06  21      229       53        107       ...
  2019-01-13  34      288       49        152       ...
  ```
  date: Date of the first day of the sampling period
  
  nCases: Number of cases reported via laboratory testing (or other traditional methods of case reporting) during the sampling period
  
  symptomX: Number of times the symptom keyword appeared in online data during the sampling period



Run in command line using:

`Rscript analysis_cases.R path_to_directory output.csv`

path_to_directory: If directory containing files to be analyzed are not in the working directory, the full file path must be provided

output.csv: Desired name of output file which contains results as specified below


## Output
The program will output a csv file of the following format:

```
data_source  illness  symptom    lag  correlation  pvalue  significant
twitter      E. coli  diarrhea    -5   -0.029      0.099   0
twitter      E. coli  diarrhea    -4   0.196       0.012   1
```
data_source: Website from which symptom keyword occurances were quantified

illness: Type of foodborne illness for which cases were quantified

symptom: Symptom keyword detected in online data

lag: Number of sampling periods before (-) or after (+) the quantified cases that the correlation to the occurance of symptom keywords was computed for. Ex. There is a significant (p = 0.012) positive correltaion of 0.196 between the number of E. coli cases and the number of symptom keyword "diarrhea" occuring in Tweets four weeks prior.

correlation: Correlation coefficient representing the strength of association between the number of cases and the number of times a symptom keyword appears in online data

pvalue: The probability of obtaining a correlation at least as strong as the one computed, given the null hypothesis that there is no correlation between number of cases and number of symptom keyword occurences

significant: 1 if correlation is significantly greater or less than 0 (alpha = 0.05), else 0

