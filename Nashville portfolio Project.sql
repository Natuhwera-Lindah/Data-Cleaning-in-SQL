
-- Cleaning data in SQL queries
SELECT *
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing


--Standardize Date Format
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate Property Address Data
SELECT *
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing AS A
JOIN [PORTFOLIO PROJECT].dbo.NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress) 
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing AS A
JOIN [PORTFOLIO PROJECT].dbo.NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


--Breaking out address into individual columns(Address, City, State)
SELECT Propertyaddress
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

SELECT 
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', Propertyaddress) -1) AS Address
, SUBSTRING(Propertyaddress, CHARINDEX(',', Propertyaddress) +1, LEN(Propertyaddress))AS Address
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress  = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', Propertyaddress) -1) 

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar (255);

UPDATE NashvilleHousing
SET PropertySplitCity  = SUBSTRING(Propertyaddress, CHARINDEX(',', Propertyaddress) +1, LEN(Propertyaddress))

SELECT *
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

SELECT OwnerAddress
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

SELECT *
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


 --Remove duplicates
WITH RowNumCTE AS (
 SELECT *,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	   PropertyAddress,
	   SalePrice,
	   SaleDate,
	   LegalReference
	   ORDER BY 
	   UniqueID
	   ) row_num
FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress


--Delete Unused Columns
 SELECT *
 FROM [PORTFOLIO PROJECT].dbo.NashvilleHousing

 ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

 ALTER TABLE [PORTFOLIO PROJECT].dbo.NashvilleHousing
DROP COLUMN SaleDate















