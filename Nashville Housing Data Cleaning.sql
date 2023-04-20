/*Cleaning data in SQL Queries*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

/*Standardize date format*/

SELECT SaleDate, CAST(SaleDate AS Date) 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CAST(SaleDate AS Date)

SELECT SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing

/*Populate Property Address Data*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing   /*Properties with same ParcelID have the same property address*/
ORDER BY ParcelID

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing B
	ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL                  /*No NULL Values returned*/


/*Breaking out Address into individual columns (Address, City, State)*/

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT PropertySplitAddress, PropertySplitCity
FROM PortfolioProject.dbo.NashvilleHousing

/*Change Y and N to "Yes" and "No" in SoldasVacant field*/

SELECT SoldAsVacant,
		CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
			 WHEN SoldAsVacant = 'N' THEN 'No'
			 ELSE SoldAsVacant
		END AS NewSoldasVacant
FROM PortfolioProject.dbo.NashvilleHousing
WHERE SoldAsVacant IN ('N', 'Y')

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END

SELECT SoldAsVacant
FROM PortfolioProject.dbo.NashvilleHousing
WHERE SoldAsVacant IN ('N', 'Y')

-- Delete unused columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, TaxDistrict

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
