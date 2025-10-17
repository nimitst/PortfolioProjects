/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject..NashvilleHousing

---

-- standardise date format
select SaleDate, convert (date, saledate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, SaleDate)


select SaleDateConverted, convert (date, saledate)
from PortfolioProject..NashvilleHousing

alter table nashvillehousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date, saledate)


-- Populate Property Address Data

select *
from PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID

/* table showing which address lines are null and updating them with the relevant parcelid */

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
--order by ParcelID

select
substring(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as address,
substring(propertyaddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress)) as address
from PortfolioProject..NashvilleHousing


alter table nashvillehousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table nashvillehousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select * 
from PortfolioProject..NashvilleHousing

select OwnerAddress
from PortfolioProject..NashvilleHousing

select 
PARSENAME(replace(owneraddress, ',','.'), 3),
PARSENAME(replace(owneraddress, ',','.'), 2),
PARSENAME(replace(owneraddress, ',','.'), 1)
from PortfolioProject..NashvilleHousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update NashvilleHousing
set ownersplitaddress = PARSENAME(replace(owneraddress, ',','.'), 3)

alter table nashvillehousing
add Ownersplitcity nvarchar(255)

update NashvilleHousing
set Ownersplitcity = PARSENAME(replace(owneraddress, ',','.'), 2)

alter table nashvillehousing
add Ownersplitstate nvarchar(255)

update NashvilleHousing
set Ownersplitstate = PARSENAME(replace(owneraddress, ',','.'), 1)

select ownersplitaddress, Ownersplitcity, Ownersplitstate
from PortfolioProject..NashvilleHousing


-- Simplifying Y and N to Yes and No in "Sold as Vacant" field 

Select distinct(SoldAsVacant), count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject..NashvilleHousing

-- Remove duplicates


with rownumCTE as(
select *, 
ROW_NUMBER() over (
	partition by parcelid, 
				 propertyaddress, 
				 saleprice,
				 saledate, 
				 legalreference 
				 order by
					uniqueid
	) row_num
from PortfolioProject..NashvilleHousing
)
select *
from rownumCTE
where row_num > 1


-- Delete Unused Columns

select * 
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject..NashvilleHousing
drop column saledate