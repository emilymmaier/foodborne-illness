# foodborne-illness
Identify symptom keywords from online data which are significantly correlated to foodborne illness outbreak up to five weeks prior to event

## Dependencies
- Written in R version 4.1.2
- Requires stringr

## Usage
All data files to be analyzed must:
- be contained in a directory which does not contain any other files
- be in csv format
- be name according to the following convention using underscores to separate information:

  `illness_dataSource_samplingFrequency.csv`
  
- have the following order of column names, with unlimited number of symptoms:
  
  > date  numberOfCases  symptom1  symptom2 symptom3 ...
  > 2019-01-06  21  229  53  107  ...
  > 2019-01-13  34  288  49  152  ...

  date: date of the first day of the sampling period
  numberOfCases: number of cases reported via laboratory testing for the sampling period
  symptomX: number of times the symptom keyword appeared in online data during the sampling period


Run in command line using:

> Rscript analysis_cases.R path_to_directory output.csv

path_to_directory: if directory containing files to be analyzed are not in the working directory, the full file path must be provided
output.csv: desired name of the program output containing the results

## Output
The program output is a csv file of the following format:

> data_source  illness  symptom  lag  correlation  pvalue  significant
> twitter  e coli  diarrhea  -5  0.129   0.089  0
> twitter  e coli  diarrhea  -4  0.196  0.012  0
