--select * from Project..CovidDeaths

--select Location, date, total_cases, new_cases, total_deaths, population from Project..CovidDeaths
--order by location, date

--Looking for total cases vs Total deaths
-- Likelihood chances of getting dying if you get covid
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from Project..CovidDeaths
where location like 'India'
order by DeathPercentage DESC


--Looking for total cases vs Population
--Shows what percentage of population infected by covid
Select location, date, total_cases, population, (total_cases/population)*100 AS PopulationPercentage from Project..CovidDeaths
where location like 'India'
order by PopulationPercentage DESC


-- Looking for the highest infection in the countries
Select Location, Population, max(total_cases) as HighestCases, max((total_cases/population)*100) as PercentPopulationInfected from Project..CovidDeaths
group by location, population
order by PercentPopulationInfected DESC

--Showing countries with the highest death count per population
Select location, max(cast(total_deaths as int)) as deaths from Project..CovidDeaths
where continent is not null 
group by location
order by deaths desc


-- GLOBAL NUMBERS of death percentage
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) *100 as GlobalDeathPercentage
from Project..CovidDeaths
where continent is not NULL
order by 1,2
 
--Looking at total Population vs total deaths
 Select d.continent, d.location, d.date,d.population, v.new_vaccinations,sum(Convert(int, v.new_vaccinations )) over(partition by d.location order by d.location,d.date)
 from project..CovidDeaths d join Project..CovidVaccines V
 on d.location = v.location and d.date = v.date
 where d.continent is  not null
 order by 2,3

 -- Looking st population vs vaccination
 with dnv (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
 as
 (
 Select d.continent, d.location, d.date,d.population, v.new_vaccinations,sum(Convert(int, v.new_vaccinations )) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
 from project..CovidDeaths d join Project..CovidVaccines V
 on d.location = v.location and d.date = v.date
 where d.continent is  not null
 --order by 2,3
 )
select *, (RollingPeopleVaccinated/Population)*100 from dnv


--Creating view 
Create view PopulationVaccinated as
Select d.continent, d.location, d.date,d.population, v.new_vaccinations,sum(Convert(int, v.new_vaccinations )) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
 from project..CovidDeaths d join Project..CovidVaccines V
 on d.location = v.location and d.date = v.date
 where d.continent is  not null
 --order by 2,3
