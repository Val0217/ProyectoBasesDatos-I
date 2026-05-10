ALTER TABLE ReportList ADD CONSTRAINT fk_ReportList_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Rescuer ADD CONSTRAINT fk_Rescuer_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Admin ADD CONSTRAINT fk_Admin_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Adopter ADD CONSTRAINT fk_Adopter_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Email ADD CONSTRAINT fk_Email_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Donation ADD CONSTRAINT fk_Donation_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Donation ADD CONSTRAINT fk_Donation_Currency FOREIGN KEY (IdCurrency) REFERENCES Currency(Id);

ALTER TABLE Donation ADD CONSTRAINT fk_Donation_Association FOREIGN KEY (IdAssociation) REFERENCES Association(Id);

ALTER TABLE Calification ADD CONSTRAINT fk_Calification_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE Phone ADD CONSTRAINT fk_Phone_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE FosterHome ADD CONSTRAINT fk_FosterHome_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE BlockList ADD CONSTRAINT fk_BlockList_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE PetPhoto ADD CONSTRAINT fk_PetPhoto_Pet FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_PetLevelEnergy FOREIGN KEY (IdEnergy) REFERENCES PetLevelEnergy(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_PetState FOREIGN KEY (IdState) REFERENCES PetState(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_PetType FOREIGN KEY (IdType) REFERENCES PetType(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_PetBreed FOREIGN KEY (IdBreed) REFERENCES PetBreed(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_District FOREIGN KEY (IdDistrict) REFERENCES District(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_SpaceRequired FOREIGN KEY (IdSpace) REFERENCES SpaceRequired(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_PetTraining FOREIGN KEY (IdPetTraining) REFERENCES PetTraining(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_PetSize FOREIGN KEY (IdSize) REFERENCES PetSize(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_Person FOREIGN KEY (IdOwner) REFERENCES Person(Id);

ALTER TABLE Pet ADD CONSTRAINT fk_Pet_Veterinarian FOREIGN KEY (IdVeterinarian) REFERENCES Veterinarian(Id);

ALTER TABLE Veterinarian ADD CONSTRAINT fk_Veterinarian_District FOREIGN KEY (IdDistrict) REFERENCES District(Id);

ALTER TABLE PetBreed ADD CONSTRAINT fk_PetBreed_PetType FOREIGN KEY (IdType) REFERENCES PetType(Id);

ALTER TABLE District ADD CONSTRAINT fk_District_Canton FOREIGN KEY (IdCanton) REFERENCES Canton(Id);

ALTER TABLE Canton ADD CONSTRAINT fk_Canton_Province FOREIGN KEY (IdProvince) REFERENCES Province(Id);

ALTER TABLE Province ADD CONSTRAINT fk_Province_Country FOREIGN KEY (IdCountry) REFERENCES Country(Id);

ALTER TABLE PetLevelEnergyXFosterHome ADD CONSTRAINT fk_PetLevelEnergyXFosterHome FOREIGN KEY (IdFosterHome) REFERENCES FosterHome(Id);

ALTER TABLE PetLevelEnergyXFosterHome ADD CONSTRAINT fk_FosterHomeXPetLevelEnergy FOREIGN KEY (IdPetLevelEnergy) REFERENCES PetLevelEnergy(Id);

ALTER TABLE PetSizeXFosterHome ADD CONSTRAINT fk_PetSizeXFosterHome FOREIGN KEY (IdFosterHome) REFERENCES FosterHome(Id);

ALTER TABLE PetSizeXFosterHome ADD CONSTRAINT fk_FosterHomeXSize FOREIGN KEY (IdPetSize) REFERENCES PetSize(Id);

ALTER TABLE SpaceRequiredXFosterHome ADD CONSTRAINT fk_SpaceRequiredXFosterHome FOREIGN KEY (IdFosterHome) REFERENCES FosterHome(Id);

ALTER TABLE SpaceRequiredXFosterHome ADD CONSTRAINT fk_FosterHomeXSpaceRequired FOREIGN KEY (IdSpaceRequired) REFERENCES SpaceRequired(Id);

ALTER TABLE PetXPetTreatment ADD CONSTRAINT fk_PetXPetTreatment FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE PetXPetTreatment ADD CONSTRAINT fk_PetTreatmentXPet FOREIGN KEY (IdPetTreatment) REFERENCES PetTreatment(Id);

ALTER TABLE PetXMedicine ADD CONSTRAINT fk_PetXMedicine FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE PetXMedicine ADD CONSTRAINT fk_MedicineXPet FOREIGN KEY (IdMedicine) REFERENCES Medicine(Id);

ALTER TABLE PetXPetIllness ADD CONSTRAINT fk_PetXPetIllness FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE PetXPetIllness ADD CONSTRAINT fk_PetIllnessXPet FOREIGN KEY (IdPetIllness) REFERENCES PetIllness(Id);

ALTER TABLE FoundReport ADD CONSTRAINT fk_FoundReport_Pet FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE FoundReport ADD CONSTRAINT fk_FoundReport_Person FOREIGN KEY (IdPerson) REFERENCES Person(Id);

ALTER TABLE PetMatch ADD CONSTRAINT fk_PetMatch_LostReport FOREIGN KEY (IdLostReport) REFERENCES LostReport(Id);

ALTER TABLE PetMatch ADD CONSTRAINT fk_PetMatch_FoundReport FOREIGN KEY (IdFoundReport) REFERENCES FoundReport(Id);

ALTER TABLE LostReport ADD CONSTRAINT fk_LostReport_Pet FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE LostReport ADD CONSTRAINT fk_LostReport_Currency FOREIGN KEY (IdCurrency) REFERENCES Currency(Id);

ALTER TABLE Adoption ADD CONSTRAINT fk_Adoption_Pet FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE Adoption ADD CONSTRAINT fk_Adoption_AdopterPerson FOREIGN KEY (IdAdopter) REFERENCES Person(Id);

ALTER TABLE Adoption ADD CONSTRAINT fk_Adoption_OwnerPerson FOREIGN KEY (IdOwner) REFERENCES Person(Id);

ALTER TABLE Rescued ADD CONSTRAINT fk_Rescued_Pet FOREIGN KEY (IdPet) REFERENCES Pet(Id);

ALTER TABLE Rescued ADD CONSTRAINT fk_Rescued_Rescuer FOREIGN KEY (IdRescuer) REFERENCES Rescuer(Id); -- en el original estaba como Person pero mejor lo lige a rescatista

ALTER TABLE Rescued ADD CONSTRAINT fk_Rescued_PetSeverity FOREIGN KEY (IdPetSeverity) REFERENCES PetSeverity(Id);