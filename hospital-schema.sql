-- phpMyAdmin SQL Dump
-- version 4.6.4deb1+deb.cihar.com~trusty.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 11, 2016 at 04:40 PM
-- Server version: 5.5.52-0ubuntu0.14.04.1
-- PHP Version: 7.0.11-2+deb.sury.org~trusty+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `patientID` bigint(20) UNSIGNED NOT NULL,
  `empID` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `startTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `causeOfVisit` varchar(100) DEFAULT NULL,
  `vitals` text,
  `status` enum('Scheduled','Cancelled','InProgress','Done') NOT NULL DEFAULT 'Scheduled',
  `summary` text,
  `currentMedicine` text,
  `prescribedMedicine` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `appointment`
--
DELIMITER $$
CREATE TRIGGER `empCheckInsert` BEFORE INSERT ON `appointment` FOR EACH ROW BEGIN
	IF 'Doctor'!=(SELECT employee.type FROM employee WHERE employee.id=NEW.empID) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Correct the Employee';
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `empCheckUpdate` BEFORE UPDATE ON `appointment` FOR EACH ROW BEGIN
	IF 'Doctor'!=(SELECT employee.type FROM employee WHERE employee.id=NEW.empID) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Correct the Employee';
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `apptID` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `mode` set('Cash','Card','Check') NOT NULL,
  `Status` enum('Paid','PartillyPaid','Unpaid') NOT NULL DEFAULT 'Unpaid'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `firstName` varchar(20) NOT NULL,
  `lastName` varchar(20) DEFAULT NULL,
  `dob` date NOT NULL,
  `address` text NOT NULL,
  `phoneNo` bigint(12) UNSIGNED NOT NULL,
  `type` enum('Doctor','Nurse','Other') NOT NULL DEFAULT 'Other',
  `licenseNo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `firstName` varchar(20) NOT NULL,
  `lastName` varchar(20) DEFAULT NULL,
  `dob` date NOT NULL,
  `address` text NOT NULL,
  `phoneNo` bigint(12) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patientID` (`patientID`),
  ADD KEY `empID` (`empID`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patientID_2` (`apptID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dob` (`dob`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `patient`
--
ALTER TABLE `patient`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`empID`) REFERENCES `employee` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`patientID`) REFERENCES `patient` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`apptID`) REFERENCES `appointment` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
