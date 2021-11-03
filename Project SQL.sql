

select *
from PortfolioProject..[covid deaths]
where continent is not null
order by 3,4
 

select *
from PortfolioProject..[covid vaccinations]
order by 3,4

Select Location ,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..[covid deaths]
order by 1,2

-- Looking at Total Cases Vs Total Deaths
--Shows likelihood of dying if you contact Covid in your country

Select Location ,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..[covid deaths]
where location like 'india'

order by 1,2

-- Total cases VS Population
-- Shows what percentage of population got Covid 

Select Location ,date,total_cases,population,(total_cases/population)*100 as PopulationAffectedPercentage
from PortfolioProject..[covid deaths]
where location like 'india'
order by 1,2

--Looking at countries with Probability of Getting Covid

Select Location ,date,total_cases,population,(total_cases/population)*100 as PopulationAffectedPercentage
from PortfolioProject..[covid deaths]
--where location like 'india'
where continent is not null
order by 5 desc


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..[covid deaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing the countries with highest dead count per population

Select Location ,Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..[covid deaths]
where continent is not null
group by location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..[covid deaths]
--Where location like '%states%'
Where continent is  null 
Group by location
order by TotalDeathCount desc

-- Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..[covid deaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Looking at Total Population vs vaccination

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..[covid deaths] dea
Join PortfolioProject..[covid vaccinations] vac 
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3;
	
 -- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..[covid deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..[covid deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 





