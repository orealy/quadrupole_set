* DESSIS command file.

File {
    * Grid and doping file from mesh generator.
	Grid	= "quad_msh" # -> quad_msh.grd
	Doping	= "quad_msh" # -> quad_msh.dat

    * Where to output certain results. Conforms with
    * DESSIS manual file naming conventions.
	Plot	= "quad" # -> quad_des.plt
	Current	= "quad" # -> quad_des.dat
	Output	= "quad" # -> quad_des.log

    * Specify material parameter file.
	Parameter = "mosQD4.7.par"
}

Electrode {
	{ Name="topGate1"	Voltage=0.5 Material="Aluminum"}
	{ Name="barrierLeft1"	Voltage=0.6 Material="Aluminum"}
	{ Name="barrierRight1"	Voltage=0.6 Material="Aluminum"}
	{ Name="leadGateLeft1"	Voltage=2.5 Material="Aluminum"}
	{ Name="leadGateRight1"	Voltage=2.5 Material="Aluminum"}
	{ Name="source1" Voltage=0 Material="Aluminum"}
	{ Name="drain1" Voltage=0 Material="Aluminum"}

	{ Name="topGate2"	Voltage=1.1 Material="Aluminum"}
	{ Name="barrierLeft2"	Voltage=0.7 Material="Aluminum"}
	{ Name="barrierRight2"	Voltage=0.7 Material="Aluminum"}
	{ Name="leadGateLeft2"	Voltage=2.6 Material="Aluminum"}
	{ Name="leadGateRight2"	Voltage=2.6 Material="Aluminum"}
	{ Name="source2" Voltage=0.1 Material="Aluminum"}
	{ Name="drain2" Voltage=0.1 Material="Aluminum"}
}

Physics {
	Temperature=20
	Fermi
	Mobility(
		DopingDep
		eHighFieldsat(
			GradQuasiFermi)
		hHighFieldSat(
			GradQuasiFermi)
		Enormal
	)
  	EffectiveIntrinsicDensity( BandGapNarrowing( OldSlotBoom ))

	IncompleteIonization
}
#Physics(RegionInterface = "substrate/oxide") {
#	charge(Conc=-1.5e+12)
#}
Plot {
	eDensity
	#hDensity
	EffectiveIntrinsicDensity
	#eCurrent/Vector
	#hCurrent/Vector
	Potential
	SpaceCharge
	ElectricField/Vector
	eMobility
	#hMobility
	eVelocity
	#hVelocity
	#Doping
	#DonorConcentration
	#AcceptorConcentration
	#eQuantumPotential
	#hQuantumPotential
	BandGap
	EffectiveBandGap
	BandGapNarrowing
	ConductionBandEnergy
	ValenceBandEnergy
	eQuasiFermiPotential
	#hQuasiFermiPotential
	#eBarrierTunneling
	#hBarrierTunneling
	#eTrappedCharge
	#hTrappedCharge
	#eEffectiveField
	#hEffectiveField
	eGradQuasiFermi
	#hGradQuasiFermi
	eTemperature
	#hTemperature
}

Math {
	method=ILS
	number_of_threads=4
	#Extrapolate
	RelErrControl
	#Derivatives
	NewDiscretization
	ConstRefPot
	Iterations=100
	NotDamped=100
#	NoAutomaticCircuitContact
	RhsMin=1e-9
}



Solve {
	Poisson
#        Coupled { Poisson Electron Hole}
#	Save(FilePrefix="1top0.50V")

#	Quasistationary(
#                InitialStep=0.02
#                MinStep=0.0008
#                MaxStep=0.02
#                Goal { Name = "topGate1" Voltage = 1 }
#                )
#                { Poisson
#                Plot( FilePrefix = "1top0.50+0.01V" Time=(range=(0 1) intervals=50) NoOverWrite ) }

#	Save(FilePrefix="1top0.50+0.01V")
}
