/*
Formula 1 DNFs Planning

.DNFs per year/decade
.DNFs per year/decade for each constructor
.DNFs per year/decade for relevant drivers
.DNFs on a world map for circuits.

*/

select *
from PortfolioProject..formula1dnfs
order by year

--DNFs per year/decade 

select year
from PortfolioProject..formula1dnfs
order by year

-- DNFs per year/decade for each constructor

select year, constructorref
from PortfolioProject..formula1dnfs
order by year

-- DNFs per year/decade for relevant drivers

select driverref, year
from PortfolioProject..formula1dnfs
order by year

--DNFs on world map for circuits

select country, YEAR
from PortfolioProject..formula1dnfs

