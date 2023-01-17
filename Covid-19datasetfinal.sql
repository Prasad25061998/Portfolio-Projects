-- This is Covid-19 data which includes information about deaths, people infected and vaccinations taken by people.
-- I have divided the dataset in 2 sheets: 1 for infected people and  other for vaccinations.

-- Retrieving the data from both the tables

Select * from [Covid_Deaths] 
Select * from [Covid_Vaccinations]

--Cleaning the data 

Select iso_code ,continent, location, date, ISNULL(population,0) AS Population,ISNULL(total_cases,0) AS TotalCases,ISNULL(new_cases,0) AS NewCases,ISNULL(new_cases_smoothed,0) AS NewCasesSmoothed,ISNULL(total_deaths, 0) AS TotalDeaths,ISNULL(new_deaths,0) AS NewDeaths,ISNULL(new_deaths_smoothed,0) AS NewDeathsSmoothed,ISNULL(total_cases_per_million,0) AS TotalCasesPerMillion,
ISNULL(new_cases_per_million,0) AS NewCasesPerMillion,ISNULL(new_cases_smoothed_per_million,0) AS NewCasesSmoothedPerMillion,ISNULL(total_deaths_per_million,0) AS TotalDeathsPerMillion,ISNULL(new_deaths_per_million,0) AS NewDeathsPerMillion,
ISNULL(new_deaths_smoothed_per_million,0) AS NewDeathsSmoothedPerMillion,ISNULL(reproduction_rate,0) AS ReproductionRate,ISNULL(icu_patients,0) AS ICUPatients,ISNULL(icu_patients_per_million,0) AS ICUPatientsPerMillion,ISNULL(hosp_patients,0) AS HospitalPatients,ISNULL(hosp_patients_per_million,0) AS HospitalPatientsPerMillion,
ISNULL(weekly_icu_admissions,0) AS WeeklyICUAdmissins,ISNULL(weekly_icu_admissions_per_million,0) AS WeeklyICUAdmissinsPerMillion,ISNULL(weekly_hosp_admissions,0) AS WeeklyHospitalAdmissions, ISNULL(weekly_hosp_admissions_per_million,0) AS WeeklyHospitalAdmissionsPerMillion INTO #FilteredDataCovidNewData from Covid_Deaths where continent is not null and population is not null

Select * from #FilteredDataCovidNewData

Select iso_code ,continent, location, date, ISNULL(total_tests,0) AS TotalTests,ISNULL(new_tests,0) AS NewTests,ISNULL(total_tests_per_thousand,0) AS TotalTestsPerThousand,ISNULL(new_tests_per_thousand,0) AS NewTestsPerThousand,ISNULL(new_tests_smoothed, 0) AS NewTestsSmoothed ,ISNULL(new_tests_smoothed_per_thousand,0) AS NewTestsSmoothedPerThousand,ISNULL(positive_rate,0) AS PositiveRate,ISNULL(tests_per_case,0) AS TestPerCase,
tests_units AS TestUnits,ISNULL(total_vaccinations,0) AS TotalVaccinations,ISNULL(people_vaccinated,0) AS PeopleVaccinated,ISNULL(people_fully_vaccinated,0) AS PeopleFullyVaccinated,
ISNULL(total_boosters,0) AS TotalBoosters,ISNULL(new_vaccinations,0) AS NewVaccinations,ISNULL(new_vaccinations_smoothed,0) AS NewVaccinationsSmoothed ,ISNULL(total_vaccinations_per_hundred,0) AS TotalVaccinationsPerHundred,ISNULL(people_vaccinated_per_hundred,0) AS PeopleVaccinationsPerHundred,ISNULL(people_fully_vaccinated_per_hundred,0) AS PeopleFullyVaccinationsPerHundred,
ISNULL(total_boosters_per_hundred, 0) AS TotalBoostersPerHundred, ISNULL(new_vaccinations_smoothed_per_million,0) AS NewVaccinationsSmoothedPerMillion, ISNULL(new_people_vaccinated_smoothed, 0) AS NewPeopleVaccinatedSmoothed,  ISNULL(new_people_vaccinated_smoothed_per_hundred, 0) AS NewPeopleVaccinatedSmoothedPerHundred, ISNULL(stringency_index, 0) AS StringencyIndex,
ISNULL(population_density, 0) AS PopulationDensity,  ISNULL(median_age, 0) AS MedianAge, ISNULL(aged_65_older, 0) AS Aged65OrOlder, ISNULL(aged_70_older, 0) AS Aged70OrOlder, ISNULL(gdp_per_capita, 0) AS GdpPerCapita, ISNULL(extreme_poverty, 0) AS ExtremePoverty,ISNULL(cardiovasc_death_rate, 0) AS CardioVascularDeathRate,ISNULL(diabetes_prevalence, 0) AS DiabetesPrevalence,
ISNULL(female_smokers, 0) AS FemaleSmokers, ISNULL(male_smokers, 0) AS MaleSmokers,ISNULL(handwashing_facilities, 0) AS HandwashingFacilites,ISNULL(hospital_beds_per_thousand, 0) AS HospitalBedsPerThousand,ISNULL(life_expectancy, 0) AS LifeExpectancy, ISNULL(human_development_index, 0) AS HumanDevelopmentIndex, ISNULL(excess_mortality_cumulative_absolute, 0) AS ExcessMortalityCumulativeAsbolute,  ISNULL(excess_mortality_cumulative, 0) AS ExcessMortalityCumulative,
ISNULL(excess_mortality,0) AS ExcessMortality, ISNULL(excess_mortality_cumulative_per_million,0) AS ExcessMortalityCumultivePerMillion INTO #FilteredVaccinationsCovidData from Covid_Vaccinations where continent is not null 

Select * from #FilteredVaccinationsCovidData

-- Global Numbers: Total Population, cases and deaths

Select SUM(Pop.GlobalPopulation) AS GlobalTotalPopulation, SUM(Pop.GlobalTotalCases) AS GlobalTotalCases, SUM(Pop.GlobalTotalDeaths) AS GlobalTotalDeaths
FROM (Select location, MAX(population) AS GlobalPopulation , MAX(TotalCases) AS GlobalTotalCases, MAX(CAST(TotalDeaths as int)) AS GlobalTotalDeaths
from #FilteredDataCovidNewData group by location) AS Pop

-- Total 10 countries having highest total cases, total deaths, total population and global death ratio

Select TOP 10 location AS Country, MAX(TotalCases) AS TotalCases,MAX(TotalDeaths) as TotalDeaths, MAX(Population) AS Population, MAX(TotalDeaths)/ MAX(TotalCases)*100 As DeathRatio
From #FilteredDataCovidNewData
where NewCases != 0 AND TotalDeaths != 0 AND Population != 0
Group By location
order by DeathRatio desc

--Top 20 countries having highest number of Covid-19 cases

Select Top 20  location, MAX(TotalCases) As TotalCases
From #FilteredDataCovidNewData
Group by  location
order by TotalCases desc

--Top 20 countries having highest infection rates

Select TOP 10 location AS Country, MAX(TotalCases) AS TotalCases, MAX(Population) AS Population, MAX(TotalCases)/ MAX(Population)*100 As InfectionRatio
From #FilteredDataCovidNewData
Group By location
order by InfectionRatio desc

-- Top 3 Continents having highest number of Deaths

Select Top 3 continent AS Continent, MAX(CAST(TotalDeaths as int)) As TotalDeaths 
from #FilteredDataCovidNewData
Group By continent
order by TotalDeaths desc

-- Top 3 Continents having highest number of Infections

Select Top 3 continent, SUM(TotalCases) As TotalCases 
from #FilteredDataCovidNewData
Group By continent
order by TotalCases desc

--Top 5 Countries having highest number of people hospitalised

Select TOP 5 location AS Country,MAX(HospitalPatients) AS HospitalPatients, MAX(Population) AS Population, MAX(HospitalPatients)/MAX(Population) *100 AS PercentageHospitalised
FROM #FilteredDataCovidNewData
Group By location
Order by PercentageHospitalised desc

--Top 5 Countries having highest number of people in serious condition (admitted in ICU)
Select TOP 5 location AS Country,MAX(ICUPatients) AS ICUPatients, MAX(Population) AS Population, MAX(ICUPatients)/MAX(Population) *100 AS PercentageICUAdmitted
FROM #FilteredDataCovidNewData
Group By location
Order by PercentageICUAdmitted desc

-- Top 10 Countries having highest numbers of Test conducted and highest Positivity Rate

Select TOP 10 location AS Country, MAX(TotalTests) AS TotalTests, MAX(PositiveRate) AS PositiveRate 
From #FilteredVaccinationsCovidData
Group By location
order by TotalTests desc, PositiveRate desc

-- Top 3 Continents having highest number of people vaccinated and highest number of booster dozes taken

Select TOP 3 continent AS Continent, MAX(PeopleVaccinated) AS PeopleVaccinated, MAX(TotalBoosters) AS TotalBoosters 
From #FilteredVaccinationsCovidData
Group By continent
order by PeopleVaccinated desc, TotalBoosters desc

-- Global Numbers:Total People Vaccinated and total booster dozes taken

Select SUM(Vac.GlobalPeopleVaccinated) AS GlobalTotalPopulation, SUM(Vac.GlobalPeopleVaccinated) AS GlobalTotalCases, SUM(Vac.GlobalTotalBoosters) AS GlobalTotalBoosters
FROM (Select location, MAX(CAST(PeopleVaccinated AS int)) AS GlobalPeopleVaccinated, MAX(CAST(TotalBoosters AS int)) AS GlobalTotalBoosters
from #FilteredVaccinationsCovidData group by location) AS Vac

-- Top 5 countries having highest number of vaccinations population wise

Select TOP 5 Va.location AS Country, MAX(P.Population) AS TotalPopulation, MAX(Va.TotalVaccinations) AS TotalVaccinations, MAX(Va.TotalVaccinations)/ MAX(P.Population)*100 As VaccinationRatio
FROM #FilteredDataCovidNewData P INNER JOIN #FilteredVaccinationsCovidData Va on
P.location = Va.location and P.date =Va.date
Group by Va.location
order by VaccinationRatio desc






