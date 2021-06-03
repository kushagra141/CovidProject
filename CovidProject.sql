	Select * 
	From PortfolioProject.dbo.CovidDeath
	Order by 3 ,4

	--Select * 
	--From PortfolioProject.dbo.CovidVaccination
	--Order by 3 ,4

	Select location, date , total_cases , new_cases , total_deaths , population 
	From PortfolioProject. . CovidDeath
	Order by 1, 2

	-- Total Cases vs Total Deaths

	Select location, date , total_cases ,  population  , (total_cases/population) * 100 as CasePercentage
	From PortfolioProject. . CovidDeath
	Where location like 'India'
	Order by 1 , 2

	Select location, date , total_deaths , total_cases ,  (total_deaths/total_cases) * 100 as DeathPercentage
	From PortfolioProject. . CovidDeath
	Where location like 'India'
	Order by 1 , 2

	--Countries with highest infection rate compared to population
	Select location, population , max(total_cases) as HighestInfectionCount  , Max((total_cases/population)) * 100 as PercentagePopulationInfected
	From PortfolioProject.dbo. CovidDeath
	--Where location like 'India'
	Group by location, population
	Order by PercentagePopulationInfected desc

	--Countries with Highest Death Rates
	Select location, max(cast(total_deaths as int)) as TotalDeathCount 
	From PortfolioProject.dbo. CovidDeath
	--Where location like 'India'
	Where continent is not null
	Group by location
	Order by TotalDeathCount   desc

	--Continent wise deaths
	Select location, max(cast(total_deaths as int)) as TotalDeathCount 
	From PortfolioProject.dbo. CovidDeath
	--Where location like 'India'
	Where continent is  null
	Group by location
	Order by TotalDeathCount   desc

	-- Global Numbers

	Select date , total_deaths , total_cases ,  (total_deaths/total_cases) * 100 as DeathPercentage
	From PortfolioProject. . CovidDeath
	Where location is not null
	Order by 1 , 2


	--Total Population Vs Vaccinations

select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations))  Over (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeath dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

With PopVsVac (Continent , location , Date , Population ,new_vaccinations,RollingPeoplevaccinated)
as
(
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations))  Over (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinate
from PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeath dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeoplevaccinated/population) * 100
From PopVsVac


--Temporary Table
 Create Table #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationvaccinated
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations))  Over (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinate
from PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeath dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingpeopleVaccinated/population)* 100
From #PercentPopulationvaccinated

--Creating view for visualization

Create View PercentagePopulationVaccinated as 
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations))  Over (Partition by dea.location  Order by dea.location, dea.date) as RollingPeopleVaccinate
from PortfolioProject..CovidVaccination vac
join PortfolioProject..CovidDeath dea
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentagePopulationVaccinated
