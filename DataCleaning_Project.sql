--Cleaning Data in SQL Quaries


SELECT * 
FROM NashvilleHousing


--Standardising Data Format


SELECT SaleDateConverted, Convert(Date,SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)


--Populating property address data


SELECT *
From NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
 On a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null

 Update a
 Set PropertyAddress = Isnull(a.PropertyAddress,b.PropertyAddress)
 From NashvilleHousing a
Join NashvilleHousing b
 On a.ParcelID = b.ParcelID 
 AND a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null


 --Breaking into Address into Individual Columns(Address,City,State)


 SELECT PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--Order By ParcelID

Select 
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address,
Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From NashvilleHousing


Select OwnerAddress
From NashvilleHousing

Select 
Parsename(Replace(OwnerAddress, ',', '.'), 3)
,Parsename(Replace(OwnerAddress, ',', '.'), 2)
,Parsename(Replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'), 1)


Select *
From NashvilleHousing


--Changing Y and N to Yes and NO in 'SoldAsVacant'


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End


--Removing Duplicates

With RowNumCTE As(
Select *,
	Row_Number() Over (
	Partition By ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	Order By UniqueID 
	) row_num
From NashvilleHousing	
--Order By ParcelId
--Where row_num > 1
)
Delete
From RowNumCTE
Where row_num >1
--Order By PropertyAddress



--Deleting Unused Columns


Select *
From NashvilleHousing

Alter table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table NashvilleHousing
Drop Column SaleDate






