# foodborne-illness
Identify symptom keywords from online data which are significantly correlated to foodborne illness outbreak up to five weeks prior to event

## Dependencies
- Written in R version 4.1.2 #FIXME
- Requires stringr

## Usage
All files must be in the same directory, which is in your working directory


Outbreak data files must be named according to:
underscores should only be used to separate the illness, data source and sampling period
>illness_dataSource_samplingPeriod.csv
and must be formatted as following:

>date\tnumberOfCases\tsymptom1\tsymptom2\symptom3\n2019-01-06\t23\t195\t332\t107
