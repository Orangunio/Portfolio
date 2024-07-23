--select *
--from CovidDeaths;

select *
from CovidDeaths
where continent is null
order by 3,4

--Selecting Data tha I am going to be using

select Location, date, total_cases,new_cases, total_deaths, population
from CovidDeaths
order by 1,2

--Comparing Total Cases vs Total Deaths in Poland (because I'm Polish :) )
-- It shows probability of death if you caught covid in Poland
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location = 'Poland'
order by 1,2

--Total Cases vs Population ( of course in Poland again)
--Show percentage of population got Covid
select Location, date, Population, total_cases, (total_cases/Population)*100 as CovidSpread
from CovidDeaths
where location = 'Poland'
order by 1,2

-- Countries with highest infection rate compared to population
select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as CovidSpread
from CovidDeaths
group by Location, Population
order by 4 desc


--Countries with highest death count per population
select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by Location
order by 2 desc

-- Now we will do it with continents
-- We must do it by location and continent is null because we have data where we have summary of all countries in each continent
select location, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null
group by location
order by 2 desc

--Continents with the highest death count
select location, Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null and location not in ('World','International','European Union')
group by location
order by 2 desc

--Global Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1

--Joining two tables
select *
from CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date

--Total population vs vaccinations
With popvsvac(Continent, location,date,population,new_vaccinations,total_vac)-- I can do also this with temp table but i found this way faster in this situation
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as total_vac
from CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
Select *, (total_vac/population)*100 as vacperpop
from popvsvac


-- Creating view for store data for later 

create view PopVac as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as total_vac
from CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

Select * from PopVac