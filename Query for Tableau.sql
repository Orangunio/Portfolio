-- Total cases and total deaths with death ratio
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2

-- Continents with death count
select location, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null and location not in ('World','International','European Union')
group by location
order by 2 desc

--Countries and their infection rate
select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as CovidSpread
from CovidDeaths
group by Location, Population
order by 4 desc

