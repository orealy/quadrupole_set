; Structure for modified SET/field gradient structure.
; C Webb z3288829
; Units in nanometers.  ; Start of file is definitions (parameters and functions
; Devise structure is generated at the end of the file.

; Global parameters
  (define extend_far 0.400)
  (define oxide_thickness 0.010)
  (define ot 0.003)
  (define delta (+ ot 0.001)) ; for finding Al bodies

; Create barrier. First create right, then mirror to create left.
; Call after making top-gate
(define create_barrier (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define barrier_sep 0.090)
  (define barrier_width 0.030)
  (define barrier_height 0.030)
  (define barrier_overhang 0.030)

  ; top left corner, bottom side
  (define a_x (/ barrier_sep 2))
  (define a_y  barrier_overhang)
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x (+ barrier_width (/ barrier_sep 2)))
  (define b_y (- extend_far))
  (define b_z barrier_height)

  ; Create right barrier insulator shell
  ; (isegeo:set-default-boolean "ABA") ; Subtract from top-gate
  (define barrier_right_insulator_id (isegeo:create-cuboid
    (position a_x a_y a_z) 
    (position b_x b_y b_z) 
    "Insulator1"
    "barrier_right_insulator"))

  ; Create right barrier aluminum
  (isegeo:set-default-boolean "ABA") ; Subtract from shell.
  (define barrier_right_id (isegeo:create-cuboid
    (position (+ a_x ot) (- a_y ot) a_z)
    (position (- b_x ot) b_y (- b_z ot))
    "Aluminum"
    "barrier_right"))

  ; flip x-coord around y-z plane
  ; note that now a_x is the right x corner, and b_x is the left x_corner
  (define a_x (- a_x))
  (define b_x (- b_x))
  ; Create left barrier insulator shell
  (isegeo:set-default-boolean "ABA") ; Subtract from top-gate
  (define barrier_left_insulator_id (isegeo:create-cuboid
    (position a_x a_y a_z) 
    (position b_x b_y b_z) 
    "Insulator1"
    "barrier_left_insulator"))

  ; Create left barrier aluminum
  (isegeo:set-default-boolean "ABA") ; Subtract from shell.
  (define barrier_left_id (isegeo:create-cuboid
    (position (- a_x ot) (- a_y ot) a_z)
    (position (+ b_x ot) b_y (- b_z ot))
    "Aluminum"
    "barrier_left"))

  ; Create left: mirror right barrier around y-plane
  ;(define mirror (transform:reflection (position 0 0 0) (gvector 1 0 0)))
  ;(define parts (list barrier_right_id barrier_right_insulator_id))
  ;(isegeo:mirror-selected parts mirror #t)

  (create_contact_set barrier_right_id "barrier_right_contact" "##")
  (create_contact_set barrier_left_id "barrier_left_contact" "||")
))

; create top gate on layer 2, along with the oxide
; Call before making barrier.
(define create_top_gate (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define top_gate_height 0.060)
  (define top_gate_width 0.060)

  ; top left corner, bottom side
  (define a_x (- extend_far))
  (define a_y 0)
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x extend_far)
  (define b_y (- top_gate_width))
  (define b_z top_gate_height)

  ; Fill in aluminum in shell.
  (isegeo:set-default-boolean "BAB") ; Don't subtract from barrier.
  (define top_gate_id (isegeo:create-cuboid
    (position a_x (- a_y ot) a_z)
    (position b_x (+ b_y ot) (- b_z ot))
    "Aluminum"
    "top_gate"))

  ; Create insulator shell.
  (isegeo:set-default-boolean "BAB") ; Don't subtract from barrier.
  (isegeo:create-cuboid
    (position a_x a_y a_z)
    (position b_x b_y b_z)
    "Insulator1"
    "top_gate_insulator")

  (create_contact_set top_gate_id "top_gate_contact" "::")
;   (isegeo:define-contact-set "topGate" 4.0 (color:rgb 1.0 0 0) "::")
 ;  (isegeo:define-3d-contact (entity:faces top_gate_id) "topGate")
))

(define create_plunger (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define plunger_top_gate_sep 0.080)
  (define plunger_width 0.030)
  (define plunger_height 0.030)

  ; top left corner, bottom side
  (define a_x (/ plunger_width -2))
  (define a_y extend_far)
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x (/ plunger_width 2))
  (define b_y plunger_top_gate_sep)
  (define b_z plunger_height)

  ; Create shell
  (isegeo:create-cuboid
    (position a_x a_y a_z)
    (position b_x b_y b_z)
    "Insulator1"
    "plunger_insulator")

  ; Fill in aluminum
  (isegeo:set-default-boolean "ABA") ; Subtract from shell
  (define plunger_id (isegeo:create-cuboid
    (position (+ a_x ot) a_y a_z)
    (position (- b_x ot) (+ b_y ot) (- b_z ot))
    "Aluminum"
    "plunger"))

  (create_contact_set plunger_id "plunger_contact" "--")
))

(define create_side_gate (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define side_gate_top_gate_sep 0.040)
  (define side_gate_sep 0.050)
  (define side_gate_width 0.030)
  (define side_gate_height 0.060)

  ; Create right side gate
  ; top left corner, bottom side
  (define a_x (/ side_gate_sep 2))
  (define a_y (+ side_gate_top_gate_sep side_gate_width))
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x extend_far)
  (define b_y side_gate_top_gate_sep)
  (define b_z side_gate_height)

  ; Create shell
  (define side_gate_insulator_id (isegeo:create-cuboid
    (position a_x a_y a_z)
    (position b_x b_y b_z)
    "Insulator1"
    "side_gate_right_insulator"))

  (isegeo:set-default-boolean "ABA") ; Subtract from shell
  (define side_gate_id (isegeo:create-cuboid
    (position (+ a_x ot) (- a_y ot) a_z)
    (position b_x (+ b_y ot) (- b_z ot))
    "Aluminum"
    "side_gate_right"))

  ; Create left: mirror right barrier around y-plane
  (define mirror (transform:reflection (position 0 0 0) (gvector 1 0 0)))
  (define parts (list side_gate_insulator_id side_gate_id))
  (define side_gate_left (isegeo:mirror-selected parts mirror #t))

  (create_contact_set side_gate_id "side_gate_right_contact" "::")
  (define a_x (- a_x)) ; flip a_x around y-z plane
  (define side_gate_left_faces (find-body-id (position (- a_x delta) (- a_y delta) (+ a_z delta))))
  (create_contact_set side_gate_left_faces "side_gate_left_contact" "//")
))

; create substrate and layers on the oxide
(define create_substrate (lambda ()
  (define domainWidth 1)
  (define domainLength 1)
  (define substrateHeight 0.200)

  (define domainX1 (/ domainWidth -2))
  (define domainY1 (/ domainLength -2))
  (define domainX2 (/ domainWidth 2))
  (define domainY2 (/ domainLength 2))

  (isegeo:set-default-boolean "ABA") ; remove everything here
  (isegeo:create-cuboid
    (position domainX1 domainY1 0)
    (position domainX2 domainY2 (- substrateHeight))
    "Silicon"
    "substrate")

  (isegeo:set-default-boolean "ABA") ; remove everything here
  (isegeo:create-cuboid
    (position domainX1 domainY1 0)
    (position domainX2 domainY2 (- oxide_thickness))
    "SiO2"
    "substrate_insulator")
))

; create an ohmic connection for the source and drain
; under the top_gate, far away
(define create_source_drain (lambda ()
  (define contact_width 0.040)
  (define contact_depth 0.040)

  ; top left corner, bottom side
  (define a_x (+ (- extend_far) delta))
  (define a_y (- 0 delta))
  (define a_z (- (+ ot 0)))

  ; bottom right corner, top side
  (define b_x (+ a_x contact_width))
  (define b_y (- contact_width))
  (define b_z (- (+ ot contact_depth)))

  (isegeo:imprint-rectangular-wire (position a_x a_y a_z) (position b_x b_y a_z))
  (define source_wire_id (find-face-id (position (+ a_x delta) (- a_y delta) a_z)))
  ;(create_contact_set source_wire "source_wire_contact" "##")
  (isegeo:define-3d-contact source_wire_id "source_wire_contact")
  (isedr:define-refinement-window "source_wire" "Cuboid" (position a_x a_y a_z) (position b_x b_y b_z))

  ; a_x -> b_x, b_x -> a_x
  (define b_x (- extend_far delta))
  (define a_x (- b_x contact_width))
  (define drain_wire_id (isegeo:imprint-rectangular-wire (position a_x a_y a_z) (position b_x b_y a_z)))
  ; (create_contact_set drain_wire_id "drain_wire_contact" "##")
  (isegeo:define-3d-contact drain_wire_id "drain_wire_contact")
  (isedr:define-refinement-window "drain_wire" "Cuboid" (position a_x a_y a_z) (position b_x b_y b_z))

  ; make the source and drain contacts ohmic.
  (isedr:define-constant-profile "ohmic" "PhosphorusActiveConcentration" 1e18)
  (isedr:define-constant-profile-placement "source_doping" "ohmic" "source_wire")
  (isedr:define-constant-profile-placement "drain_doping" "ohmic" "drain_wire")
))

(define create_refinement(lambda ()
  ; define larger refinement window 
  (isedr:define-refinement-size "2deg_ref" 0.005 0.002 0.003 0.002 0.001 0.001)
  (isedr:define-refinement-window "2deg_window" "Cuboid"
    (position -0.100 0.100 0)
    (position 0.100 -0.080 -0.030))
  (isedr:define-refinement-placement "2deg_placement" "2deg_ref" "2deg_window")

  (isedr:define-refinement-size "tg_ref" 0.020 0.020 0.003 0.010 0.010 0.001)
  (isedr:define-refinement-window "tg_window" "Cuboid"
    (position (- extend_far) 0 0)
    (position extend_far -0.060 -0.040))
  (isedr:define-refinement-placement "tg_placement" "tg_ref" "tg_window")
))

(define create_contact_set(lambda (id_list name pattern)
  (isegeo:define-contact-set name 4.0 (color:rgb 1.0 0 0) pattern)
  (isegeo:define-3d-contact (entity:faces id_list) name)
))

; Run DEVISE commands
  (ise:clear) ; Reset DEVISE

  ; Create structures and contact sets
  (create_barrier) ; barrier_right and barrier_left
  (create_top_gate) ; top_gate
  (create_plunger) ; plunger
  (create_side_gate) ; side_gate_right and side_gate_left
  (create_substrate) ; no contact set

  ; Create refinement windows
  ; (create_source_drain)
  (create_refinement)
   
  (ise:save-model "quad")
