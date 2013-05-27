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
	{ Name="top_gate_contact"	Voltage=1.3 Material="Aluminum"}
	{ Name="barrier_right_contact"	Voltage=0.6 Material="Aluminum"}
	{ Name="barrier_left_contact"	Voltage=0.6 Material="Aluminum"}
	{ Name="side_gate_left_contact"	Voltage=0.50 Material="Aluminum"}
	{ Name="side_gate_right_contact"	Voltage=0.40 Material="Aluminum"}
	{ Name="plunger_contact"	Voltage=0.55 Material="Aluminum"}
	{ Name="source_wire_contact"	Voltage=0.0 Material="Aluminum"}
	{ Name="drain_wire_contact"	Voltage=0.0 Material="Aluminum"}
}

Physics {
	Temperature=1
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

#	IncompleteIonization
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
