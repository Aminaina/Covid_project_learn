 --SELECT * FROM Covid_Porject.dbo.covid_deaths
 --ORDER BY 3,4
 --looking at persentage_of_deaths
  SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS persentage_of_deaths
  FROM Covid_Porject.dbo.covid_deaths
   WHERE location = 'Algeria'
  ORDER BY 1,2
  --looking at persentage_of_cases
  SELECT location,  population, total_cases ,(total_cases / population)*100 AS persentage_of_cases
  FROM Covid_Porject.dbo.covid_deaths
   --WHERE location  like 'Algeria%'
  ORDER BY   persentage_of_cases DESC
  --Looking at countries with highest infection rate compare to population
   SELECT location,  population, MAX(total_cases) AS highestInfectionCount,(MAX(total_cases / population))*100 AS persentage_population_infection
  FROM Covid_Porject.dbo.covid_deaths
   --WHERE location  like 'Algeria%'
    WHERE continent IS NOT NULL
   GROUP BY    location, population
  ORDER BY   persentage_population_infection DESC
  -- showing highest death count per population 
   SELECT location,  population, MAX(cast(total_deaths as int)) AS highestDeathsCount 
  FROM Covid_Porject.dbo.covid_deaths
   --WHERE location  like 'Algeria%'
   WHERE continent IS NOT NULL
   GROUP BY    location, population
  ORDER BY   highestDeathsCount DESC
  -- showing highest death count per CONTINENT 
   SELECT continent, MAX(cast(total_deaths as int)) AS highestDeathsCount 
  FROM Covid_Porject.dbo.covid_deaths
   --WHERE location  like 'Algeria%'
   WHERE continent IS NOT NULL
   GROUP BY    continent
  ORDER BY   highestDeathsCount DESC
  --Global Number
  SELECT  SUM(new_cases) AS num_new_cases, SUM(CAST(new_deaths as int)) AS num_new_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases)) AS persentage_deaths
  FROM Covid_Porject.dbo.covid_deaths
   --WHERE location  like 'Algeria%'
   WHERE continent IS NOT NULL
    
  ORDER BY  1,2
 WITH pop_vs_vac (continent, location,  date,  population,  new_vaccinations, vac_per_pop) AS
 (
 SELECT dea.continent ,dea.location, dea.date, dea.population, cov.new_vaccinations, SUM(CONVERT(float, cov.new_vaccinations)) OVER(PARTITION BY dea.location  order by dea.location, dea.date
 ) AS vac_per_pop
  FROM Covid_Porject.dbo.covid_deaths dea
  JOIN  Covid_Porject.dbo.covid_vaccinations cov
  ON  dea.location = cov.location
  AND dea.date = cov.date
    WHERE dea.continent IS NOT NULL
 

  )
  SELECT * , (vac_per_pop/population)*100 AS poppervac
  FROM pop_vs_vac
  ORDER BY  1,2, poppervac 
  SELECT   location,  MAX(CONVERT(float, new_vaccinations))   AS max_num_vac 
  FROM Covid_Porject.dbo.covid_vaccinations 
  WHERE continent IS NOT NULL
  GROUP BY location 
  ORDER BY  1

 -- -TAM TABLE
 
 DROP TABLE if exists #PercentPopulationVacinated
  CREATE TABLE #PercentPopulationVacinated
  (
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vacccinations numeric,
  Vac_per_pop numeric
  )
  INSERT INTO #PercentPopulationVacinated
  SELECT dea.continent, dea.location, dea.date, dea.population, cov.new_vaccinations, SUM(CONVERT(float, cov.new_vaccinations)) OVER(PARTITION BY dea.location  order by dea.location, dea.date
 ) AS vac_per_pop
  FROM Covid_Porject.dbo.covid_deaths dea
  JOIN  Covid_Porject.dbo.covid_vaccinations cov
  ON  dea.location = cov.location
  AND dea.date = cov.date
    WHERE dea.continent IS NOT NULL

 
  SELECT * , (Vac_per_pop/Population )*100 AS poppervac
  FROM #PercentPopulationVacinated
 USE Covid_Porject
 GO
 CREATE VIEW   
  PercentPopulationVacinated 
  AS
    SELECT dea.continent, dea.location, dea.date, dea.population, cov.new_vaccinations, SUM(CONVERT(float, cov.new_vaccinations)) OVER(PARTITION BY dea.location  order by dea.location, dea.date
 ) AS vac_per_pop
  FROM Covid_Porject.dbo.covid_deaths dea
  JOIN  Covid_Porject.dbo.covid_vaccinations cov
  ON  dea.location = cov.location
  AND dea.date = cov.date
    WHERE dea.continent IS NOT NULL	 
	SELECT * 
	FROM PercentPopulationVacinated 