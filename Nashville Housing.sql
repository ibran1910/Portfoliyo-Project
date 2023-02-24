# SQL Data cleaning Queries

SELECT *
FROM nashville_housing

##  STARNDARDIZE DATE FORMAT

SELECT saleDateConverted, CONVERT(Date, SaleDate)
from nashville_housing

update nashville_housing      
set SaleDate = convert(Date,SaleDate)

#If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)
 
 
#Populate Property Address Data


select *
from nashville_housing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyADDress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
      on a.ParcelID = b.ParcelID
      and a.[uniqueID] <> b.[uniqueID]
 where a.propertyAddress is null     

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
      on a.ParcelID = b.ParcelID
      and a.[uniqueID] <> b.[uniqueID]
 where a.PropertyAddress is nulll     
 
 
## Breking out Address into Individual Columns (Address, City,State)


select PropertyAddress
from nashville_housing

select
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN( PropertyAddress)) as Address 
 
 from nashville_housing


alter table nashville_housing
add PropertySplitAddress Nvarchar(255);

update nashville_housing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table nashville_housing
add PropertySplitAddress Nvarchar(255);

update nashville_housing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) +1, LEN( PropertyAddress))

select *
from nashville_housing

select OwnerAddress
from nashville_housing

select 
PARSENAME(REPLACE (OwnerAddress, ',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
from nahville_housing


alter table nashville_housing
add OwnerSplitAddress Nvarchar(255);

update nashville_housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

alter table nashville_housing
add OwnerSplitAddress Nvarchar(255);

update nashville_housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

alter table nashville_housing
add OwnerSplitAddress Nvarchar(255);

update nashville_housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from nashville_housing



## Change Y and N to Yes and No  in "Sold as Vacant " field



selecct Distinct(SoldAsVacant), Count(SoldAsVacant)
from nashville_housing
group by soldAsVacant
order by 2



select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from nashville_housing


update nashville_housing
set  SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


    ## Remove Dublicates

with RowNumCTE AS(
select *,
        ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
								PropertyAddress,
                                SalePrice,
                                SaleDate,
                                LegalReference
                                Order by
                                        uniqueID
                                        ) row_num
									
from nashville_housing
)

select * 
from RowNumCTE
where row_num > 1
Order by PropertyAddress


select *
from nashville_housing



   ## Delete unused Columns
   
   
   select *
   from nashville_housing

alter table nashville_housing
drop column OwenerAddress, TaxDistrict, PropertyAddress, SaleDate













