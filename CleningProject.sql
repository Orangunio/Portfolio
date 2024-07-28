-- Cleaning Data --
Select * 
from Clean
--Standarize Date format
select saledate, CONVERT(Date, SaleDate)
from Clean

Alter Table Clean
Alter Column SaleDate Date
-- Populate Property Adress data
Select *
from Clean
where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Clean a
Join Clean b on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set a.PropertyAddress = b.PropertyAddress
from Clean a
Join Clean b on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Adress into individual columns (Adress, City, State)

Select PropertyAddress
from Clean

Select SUBSTRING(PropertyAddress, 1, Charindex(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, Charindex(',',PropertyAddress)+1, LEN(PropertyAddress)) as address
from Clean

Alter table Clean
ADD PropertySplitAddress nvarchar(255)

Update Clean
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',',PropertyAddress)-1)

Alter Table Clean
ADD PropertySplitCity nvarchar(255)

Update Clean
Set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *
from clean

--------- Other option - easier way 
Select ownerAddress
from clean

Select PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from clean

Alter table clean
ADD OwnerSplitAddress Nvarchar(255)
Update clean
Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

Alter table clean
ADD OwnerSplitCity Nvarchar(255)

Update clean
Set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table clean
ADD OwnerSplitState Nvarchar(255)

Update clean
Set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)


--Change Y and to Yes and No in "Sold as Vacant" 
Select Distinct(soldasvacant), Count(soldasvacant)
from clean
group by soldasvacant

select soldasvacant,
case when soldasvacant = 'Y' Then 'Yes' when soldasvacant = 'N' then 'No' else soldasvacant end
from clean

Update clean
set soldasvacant = case when soldasvacant = 'Y' Then 'Yes' when soldasvacant = 'N' then 'No' else soldasvacant end


-- Remove Duplicates


with RowNum as(
select *, 
ROW_NUMBER() over (partition by ParcelID,PropertyAddress,SaleDate, SalePrice,LegalReference order by UniqueID) row_num
from clean
)
Delete
from RowNum
where row_num >1


-- Delete unused columns
-- using for views but I am doing it here just for example purposes
Select *
from clean

Alter table clean
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table clean
Drop column SaleDate

