Select*
From portfolio..[Covid deaths ]
Where continent is not null
order by 3,4


--Select*
--From portfolio..[covid vaccinations]
--Order by 3,4

--Select data that we are going to be using 


Select Location, date , total_cases , new_cases, total_deaths, population
From portfolio..[Covid deaths ]
Order by 1,2


--Looking at total cases vs Total deaths 
--Shows likelihood of dying if you contract covid in your country


Select Location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio..[Covid deaths ]
Where location like '%kingdom%'
Order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid
Select Location, date , population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From portfolio..[Covid deaths ]
--Where location like '%kingdom%'
Order by 1,2

-- Looking at countries with highest infection rate compared to Population 

Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 as 
PercentPopulationInfected
From portfolio..[Covid deaths ]
--Where location like '%kingdom%'
Group by Location, population
Order by PercentPopulationInfected desc


--Showing Countries with highest death count per population


Select Location, MAX(Cast (total_deaths as int)) AS TotalDeathCount 
From portfolio..[Covid deaths ]
--Where location like '%kingdom%'
Where continent is not null
Group by Location
Order by TotalDeathCount Desc

--Breaking things down by continent

Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount 
From portfolio.. [Covid deaths ]
---Where location like '%Kingdom%'
Where continent is not null
Group by continent
Order by TotalDeathCount Desc

--- Showing continents with highest death count per population

Select Continent, MAX(Cast (total_deaths as int)) AS TotalDeathCount 
From portfolio..[Covid deaths ]
--Where location like '%kingdom%'
Where continent is not null
Group by continent
Order by TotalDeathCount Desc

---Global numbers

Select SUM(new_cases) as total_cases , SUM (cast (new_deaths as int)) as total_deaths , Sum (cast (new_deaths as int))/ SUM (New_cases)*100 as Percentpeopleinfected
From portfolio..[Covid deaths ]
--Where location like '%kingdom%'
Where continent is not null
--Group by date
Order by 1,2

-- Above shows total number of cases and deaths in the world


--Looking at Total population vs Vaccinations

Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, dea.date)as RollingPeopleVaccinated

---  (RollingPeopleVaccinated/Population)*100

From portfolio..[Covid deaths ] dea
Join portfolio..[covid vaccinations] vac
     on Dea.location=vac.location
     and dea.date=vac.date
Where dea.continent is not null
Order by 2,3

---USE CTE

With PopvsVac (continent, location, date, population, New_vaccinations , RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--,  (RollingPeopleVaccinated/Population)*100
From portfolio..[Covid deaths ] dea
Join portfolio..[covid vaccinations] vac
     on Dea.location=vac.location
     and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3
)
 Select *,(RollingPeopleVaccinated/Population)*100
 From PopvsVac




 -- Temp table
 
 
 DROP Table if exists #PercentPopulationVaccinated
 Create table #PercentPopulationVaccinated 
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeoplevaccinated numeric
)

 Insert into #PercentPopulationVaccinated 
 Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--,  (RollingPeopleVaccinated/Population)*100
From portfolio..[Covid deaths ] dea
Join portfolio..[covid vaccinations] vac
     on Dea.location=vac.location
     and dea.date=vac.date
--Where dea.continent is not null
--Order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated
 
 
 --creating view to store data for later visualizations

 
 Create View PercentofPopulationVaccinated as
 Select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--,  (RollingPeopleVaccinated/Population)*100
From portfolio..[Covid deaths ] dea
Join portfolio..[covid vaccinations] vac
     on Dea.location=vac.location
     and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3

Select*
From PercentofPopulationVaccinated