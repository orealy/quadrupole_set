; Structure for modified SET/field gradient structure.
; C Webb z3288829
; Based on SET designed by Raj, and TCAD model supplied by Fahd.

; Begin journalling
; (journal:on "devise.jrl")

; Reset DEVISE
(ise:clear)

; Define parameters
  (define dotLength 0.04)
  (define dotdistance 0.2)

  (define barrierWidth 0.036)
  (define barrierHeight 0.030)
  (define barrierOxideThickness 0.004)
  (define barrierOxideThicknessBottom 0.002)
  (define barrierAngle 10)
  (define barrierPosition 0)
  (define chamferTop 0.005)
  (define chamferBottom 0.003)

  (define extraOxideAngle 40)
  (define extraOxidePosition 0.004)

  (define plungerWidth 0.070)
  (define plungerHeight 0.040)
  (define plungerOverlap 0.030)
  (define plungerOxideThickness 0.004)

  (define topGateWidth 0.050)
  (define topGateHeight 0.120)
  (define topGateOxideThickness 0.002)

  (define centrePositionX (/ (+ barrierWidth dotLength) -2))
  (define centrePositionY (/ dotdistance -2))
  (define centrePositionZ 0)

  (define topGateLength 0)
  (define leadGateLength 0)
  (define barrierExtendUp 0.04)
  (define barrierExtendDown 0.4)
  (define leadGateExtendRight 0)
  (define leadGateExtendLeft 0.7)
  (define topGateExtendRight 0.03)
  (define topGateExtendLeft 0.1)
  (define topGateBendAngle 40)
  (define topGateBendCover 0.07)
  (define topGateBendExtend 0.5)

; Ratios of defined parameters. Don't change.
  (define barrierLength topGateWidth)
  (define barrierLengthTotal (+ barrierExtendUp topGateWidth barrierExtendDown))

  (define barrierWidthHalf (/ barrierWidth 2))
  (define barrierHeightHalf (/ barrierHeight 2))
  (define barrierLengthHalf (/ barrierLength 2))

  (define barrier1X1 (- centrePositionX barrierWidthHalf))
  (define barrier1Y1 (- centrePositionY barrierLengthHalf barrierExtendDown))
  (define barrier1X2 (+ centrePositionX barrierWidthHalf))
  (define barrier1Y2 (+ centrePositionY barrierLengthHalf barrierExtendUp))

  (define leadGate1X1 (- centrePositionX (/ leadGateLength 2) leadGateExtendLeft))
  (define leadGate1Y1 (- centrePositionY (/ leadGateWidth 2)))
  (define leadGate1X2 (+ centrePositionX (/ leadGateLength 2) leadGateExtendRight))
  (define leadGate1Y2 (+ centrePositionY (/ leadGateWidth 2)))

  (define topGate1X1 (- centrePositionX (/ topGateLength 2) topGateExtendLeft))
  (define topGate1Y1 (- centrePositionY (/ topGateWidth 2)))
  (define topGate1X2 (+ centrePositionX (/ topGateLength 2) topGateExtendRight))
  (define topGate1Y2 (+ centrePositionY (/ topGateWidth 2)))

  (define selfBoolean (transform:translation (gvector 0 0 0)))

;Create Barrier
  ; Turn off overlap detections.
  (isegeo:set-default-boolean "XX")

  ; defines barrierOxideID to refer to a barrierOxide
  (define barrierOxideID
    (isegeo:create-cuboid
      (position barrier1X1 barrier1Y1 0)
      (position barrier1X2 barrier1Y2 barrierHeight)
      "Insulator1"
      "barrierOxide"))

  (define barrierOxideChamferTop
    (list
      (car (find-edge-id (position barrier1X1 centrePositionY barrierHeight)))
      (car (find-edge-id (position barrier1X2 centrePositionY barrierHeight)))
      (car (find-edge-id (position centrePositionX barrier1Y2 barrierHeight)))))

  (define barrierOxideChamferBottom
    (list
      (car (find-edge-id (position barrier1X1 centrePositionY 0)))
      (car (find-edge-id (position barrier1X2 centrePositionY 0)))
      (car (find-edge-id (position centrePositionX barrier1Y2 0)))))

  (define barrierOxideTaperFace
    (list
      (car (find-face-id (position barrier1X1 centrePositionY 0.0001)))
      (car (find-face-id (position barrier1X2 centrePositionY 0.0001)))
      (car (find-face-id (position centrePositionX barrier1Y2 0.0001)))))

  (isegeo:taper-faces
    barrierOxideTaperFace
    (position centrePositionX centrePositionY barrierPosition)
    (gvector 0 0 1)
    barrierAngle)

  (isegeo:chamfer-edges
    barrierOxideChamferTop
    chamferTop
    chamferTop)

  (define barrierAluminumID
    (isegeo:create-cuboid
      (position
        (+ barrier1X1 barrierOxideThickness)
        barrier1Y1
        barrierOxideThicknessBottom)
      (position
        (- barrier1X2 barrierOxideThickness)
        (- barrier1Y2 barrierOxideThickness)
        (- barrierHeight barrierOxideThickness))
      "Aluminum"
      "barrierAluminum"))

  (define barrierAluminumChamferTop
    (list
      (car (find-edge-id
          (position
            (+ barrier1X1 barrierOxideThickness)
            centrePositionY
            (- barrierHeight barrierOxideThickness))))
      (car (find-edge-id
        (position
          (- barrier1X2 barrierOxideThickness)
          centrePositionY
          (- barrierHeight barrierOxideThickness))))
      (car (find-edge-id
        (position
          centrePositionX
          (- barrier1Y2 barrierOxideThickness)
          (- barrierHeight barrierOxideThickness))))))

  (define barrierAluminumChamferBottom
    (list
      (car (find-edge-id
        (position
          (+ barrier1X1 barrierOxideThickness)
          centrePositionY
          barrierOxideThicknessBottom)))
      (car (find-edge-id
        (position
          (- barrier1X2 barrierOxideThickness)
          centrePositionY
          barrierOxideThicknessBottom)))
      (car (find-edge-id
        (position
          centrePositionX
          (- barrier1Y2 barrierOxideThickness)
          barrierOxideThicknessBottom)))))

  (define barrierAluminumTaperFace
    (list
      (car (find-face-id
        (position
          (+ barrier1X1 barrierOxideThickness)
          centrePositionY
          (+ barrierOxideThicknessBottom 0.0001))))
      (car (find-face-id
        (position
          (- barrier1X2 barrierOxideThickness)
          centrePositionY
          (+ barrierOxideThicknessBottom 0.0001))))
      (car (find-face-id
        (position
          centrePositionX
          (- barrier1Y2 barrierOxideThickness)
          (+ barrierOxideThicknessBottom 0.0001))))))

  (isegeo:taper-faces
    barrierAluminumTaperFace
    (position centrePositionX centrePositionY barrierPosition)
    (gvector 0 0 1)
    barrierAngle)

  (isegeo:chamfer-edges
    barrierAluminumChamferTop
    chamferTop
    chamferTop)

  (isegeo:chamfer-edges
    barrierAluminumChamferBottom
    chamferBottom
    chamferBottom)

  ; merge all pieces under the barrier oxide with itself.
  (isegeo:set-default-boolean "BAB")
  (isegeo:translate-selected barrierOxideID selfBoolean #f 1)

; Create LeadGate aluminum
  ; 199 devise: subtract all existing regions from new region
  (isegeo:set-default-boolean "BAB")

  (define leadGateAluminumID
    (isegeo:create-cuboid
      (position
        leadGate1X1
        (+ leadGate1Y1 leadGateOxideThickness)
        topGateOxideThickness)
      (position
        (- leadGate1X2 leadGateOxideThickness)
        (- leadGate1Y2 leadGateOxideThickness)
        (- leadGateHeight leadGateOxideThickness))
      "Aluminum"
      "leadGateAluminum"))

  ; 199 devise: merge/unite new regions with existing regions. Merged regions
  ; inherit the DATEX material (and name) from the new regions.
  (isegeo:set-default-boolean "AB")

  (define leadGateAluminumID
    (isegeo:create-cuboid
      (position
        (+ (- leadGate1X2 leadGateOverlap) leadGateOxideThickness)
        (+ leadGate1Y1 leadGateOxideThickness)
        (- leadGateHeight leadGateOxideThickness))
      (position
        (- leadGate1X2 leadGateOxideThickness)
        (- leadGate1Y2 leadGateOxideThickness)
        (- (+ leadGateHeight barrierHeight) leadGateOxideThickness))
      "Aluminum"
      "leadGateAluminum"))

; Create LeadGate oxide
  (isegeo:set-default-boolean "XX")
  (define leadGateOxideID
    (isegeo:create-cuboid
      (position leadGate1X1 leadGate1Y1 0)
      (position leadGate1X2 leadGate1Y2 leadGateHeight)
      "Insulator1"
      "leadOxide"))
  (define leadGateOxideID2
    (isegeo:create-cuboid
      (position (- leadGate1X2 leadGateOverlap)  leadGate1Y1 leadGateHeight)
      (position leadGate1X2 leadGate1Y2 (+ leadGateHeight barrierHeight))
      "Insulator1"
      "leadOxide"))
  (isegeo:bool-unite (list leadGateOxideID leadGateOxideID2))
  ; 199 devise: merge/unite new regions with existing regions.
  (isegeo:set-default-boolean "BAB")
  ; Transform the lead gate oxide by identity and delete the original.
  (isegeo:translate-selected leadGateOxideID selfBoolean #f 1)

; Create TopGate oxide
  (isegeo:set-default-boolean "BAB")
  (define topGateAluminumID
    (isegeo:create-cuboid
      (position topGate1X1 topGate1Y1 0)
      (position topGate1X2 topGate1Y2 topGateOxideThickness)
      "Insulator1"
      "gateOxide"))

; Create TopGate aluminum
  (isegeo:set-default-boolean "BAB")
  (define topGateAluminumID
    (isegeo:create-cuboid
      (position topGate1X1 topGate1Y1 0)
      (position topGate1X2 topGate1Y2 (+ topGateHeight leadGateHeight))
      "Aluminum"
      "topGateAluminum"))

  (define topGateBend
    (transform:rotation
      (position topGate1X1 topGate1Y2 0)
      (gvector 0 0 1)
      topGateBendAngle))

; Create TopGate oxide
  (isegeo:set-default-boolean "XX")
  (define topGateOxideBendID
    (isegeo:create-cuboid
      (position topGate1X1 topGate1Y1 0)
      (position (- topGate1X1 topGateBendExtend) topGate1Y2  topGateOxideThickness)
      "Insulator1"
      "bendOxide"))
  (isegeo:set-default-boolean "BAB")
  (isegeo:rotate-selected topGateOxideBendID topGateBend #f 1)

; Create TopGate aluminum
  (isegeo:set-default-boolean "XX")
  (define topGateAluminumBendID
    (isegeo:create-cuboid
      (position topGate1X1 topGate1Y1 0)
      (position (- topGate1X1 topGateBendExtend) topGate1Y2 topGateHeight)
      "Aluminum"
      "topGateAluminum"))
  (define topGateAluminumBend2ID
  (isegeo:set-default-boolean "ABA")
  (define oxideLayerID
    (isegeo:create-cuboid
      (position oxideLayerX1 oxideLayerY1 0)
      (position oxideLayerX2 oxideLayerY2 (- siliconOxideThickness))
      "SiO2"
      "oxideLayer"))

; Define contact sets
  (isegeo:define-contact-set "topGate1" 4.000000  (color:rgb 1.000000 0.000000 0.000000 ) "//" )
  (isegeo:define-contact-set "barrierLeft1" 4.000000  (color:rgb 1.000000 0.000000 1.000000 ) "##" )
  (isegeo:define-contact-set "barrierRight1" 4.000000  (color:rgb 1.000000 0.000000 1.000000 ) "##" )
  (isegeo:define-contact-set "leadGateLeft1" 4.000000  (color:rgb 1.000000 1.000000 0.000000 ) "||" )
  (isegeo:define-contact-set "leadGateRight1" 4.000000  (color:rgb 1.000000 1.000000 0.000000 ) "||" )
  (isegeo:define-3d-contact
    (entity:faces barrierAluminumID)
    "barrierLeft1")
  (isegeo:define-3d-contact
    (entity:faces
      (car( find-body-id( position (/ (+ barrierWidth dotLength) 2) centrePositionY (/ barrierHeight 2)))))
    "barrierRight1")
  (isegeo:define-3d-contact
    (entity:faces topGateAluminumID)
    "topGate1")
  (isegeo:define-3d-contact
    (entity:faces leadGateAluminumID)
    "leadGateLeft1")
  (isegeo:define-3d-contact
    (entity:faces (car(find-body-id (position 0.5 centrePositionY (/ barrierHeight 2)))))
    "leadGateRight1")

; Define Source Drain
  (isegeo:imprint-rectangular-wire
    (position
      sourceContact1X1
      sourceContact1Y1
      (- siliconOxideThickness))
    (position
      sourceContact1X2
      sourceContact1Y2
      (- siliconOxideThickness)))
  (define sourceID
    (find-face-id
      (position
        (+ sourceContact1X1 0.0001)
        (+ sourceContact1Y1 0.0001)
        (- siliconOxideThickness))))
  (isegeo:define-3d-contact sourceID "source1")

  (isegeo:imprint-rectangular-wire
    (position
      drainContact1X1
      drainContact1Y1
      (- siliconOxideThickness))
    (position
      drainContact1X2
      drainContact1Y2
      (- siliconOxideThickness)))
  (define drainID
    (find-face-id
      (position
        (- drainContact1X1 0.0001)
        (+ drainContact1Y1 0.0001)
        (- siliconOxideThickness))))
  (isegeo:define-3d-contact drainID "drain1")

  (isedr:define-refinement-window
    "sourceRegion1"
    "Cuboid"
    (position
      sourceContact1X1
      sourceContact1Y1
      (- siliconOxideThickness))
    (position
      sourceContact1X2
      sourceContact1Y2
      (- -0.01 siliconOxideThickness)))

  (isedr:define-refinement-window
    "drainRegion1"
    "Cuboid"
    (position
      drainContact1X1
      drainContact1Y1
      (- siliconOxideThickness))
    (position
      drainContact1X2
      drainContact1Y2
      (- -0.01 siliconOxideThickness)))



  (isedr:define-constant-profile "ohmic" "PhosphorusActiveConcentration" 1e16)
  (isedr:define-constant-profile-placement "sourceDoping" "ohmic" "sourceRegion1")
  (isedr:define-constant-profile-placement "drainDoping" "ohmic" "drainRegion1")

; Define refinement windows
  (isedr:define-refinement-size "generalRef" 0.1 0.1 0.1 0.02 0.02 0.02)
  (isedr:define-refinement-material "substratePlace" "generalRef" "Silicon")

; 2Deg window
  (define 2DegExtra 0.02)
  ; max x,y,z and min x,y,z for the window
  (isedr:define-refinement-size
    "2DegRef"
    0.05 0.05 0.01 0.005 0.005 0.001 )
  (isedr:define-refinement-window
    "2DegWindow"
    "Cuboid"
    (position (- leadGate1X1 2DegExtra) (- leadGate1Y1 2DegExtra) -0.03)
    (position (- 2DegExtra leadGate1X1) (- 2DegExtra leadGate1Y1) 0))
  (isedr:define-refinement-placement "2DegPlace" "2DegRef" "2DegWindow")

; Intersection window
  (define intesect1ExtraX 0.05)
  (define intesect1ExtraY 0.04)
  (isedr:define-refinement-size
    "intersect1Ref"
    0.01 0.01 0.003 0.005 0.005 0.001)
  (isedr:define-refinement-window
    "intersect1Window"
    "Cuboid"
    (position
      (- barrier1X1 intesect1ExtraX)
      (- leadGate1Y1 intesect1ExtraY)
      -0.02)
    (position
      (- intesect1ExtraX barrier1X1)
      (- intesect1ExtraY leadGate1Y1)
      -0.0075))
  (isedr:define-refinement-placement
    "intersect1Place"
    "intersect1Ref"
    "intersect1Window" )

; Save model
(ise:save-model "quad")

; End journaling
; (journal:save "devise.jrl")
